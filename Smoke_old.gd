extends Panel

#
# This is the implementation using 2D arrays which fucking sucks performance-wise
#

var n = 50
var dens : Array = []
var _u : Array = []
var _v : Array = []	
@onready var timestep = get_node("Smoke Update Timer").wait_time
func _ready():

	for i in range(0,n):
		dens.append([])
		_u.append([])
		_v.append([])
		for j in range(0,n+1):
			dens[i].append(0)
			_u[i].append(0)
			_v[i].append(-0.6)

# The Stam method
func IX(i,j):
	return ((i)+(n+2)*(j))
func diffuse ( N : int, b : int, x, x0, diff : float, dt : float):
	var a=dt*diff*N*N;
	for k in range(0,5):
		for i in range(0,N):
			for j in range(1,N):
				x[i][j] = (x0[i][j] + a*(x[i-1][j]+x[i+1][j]+x[i][j-1]+x[i][j+1]))/(1+4*a)
				# x[i][j] = max(0, x[i][j]-0.000000001)
	set_bnd ( N, b, x )

func advect ( N, b, d, d0, u,v, dt ):
	var i0 
	var j0
	var i1
	var j1
	var x
	var y
	var s0
	var t0
	var s1
	var t1
	var dt0 = dt*(N);
	N = N-1
	for i in range(0,N):
		for j in range(0,N):
			x = i-dt0*u[i][j]
			y = j-dt0*v[i][j]
			if (x<0.5):
				x=0.5
			if (x>N+0.5):
				x=N+0.5
			i0=int(x)
			i1=i0+1
			if (y<0.5):
				y=0.5
			if (y>N+0.5):
				y=N+ 0.5
			j0=int(y)
			j1=j0+1;
			s1 = x-i0; s0 = 1-s1; t1 = y-j0; t0 = 1-t1;
			# if i0 == 40 or i1 == 40 or j0 == 40 or j1 == 40:
			# 	print(i0)
			# 	print(i1)
			# 	print(j0)
			# 	print(j1)
			# Fuck you you stupid piece of shit stop fuckingcrashing my game asshole
			d[i][j] = s0*(
				t0*d0[i0][j0]+t1*d0[i0][j1])+(
					s1*(t0*d0[i1][j0]+t1*d0[1][1]));
	set_bnd ( N, b, d )

func project ( N, u, v, p, div):
	# a na razie to ja to pierdole wsm xddddddd
	# te bez spacji komentarze to do wpisania som
	N = N-3
	var h = 1.0/N
	for i in range(0,N):
		for j in range(0,N):
			div[i][j] = -0.5*h*(u[i+1][j]-u[i-1][j]+v[i][j+1]-v[i][j-1])
			p[i][j] = 0;
	set_bnd ( N, 0, div ); set_bnd ( N, 0, p );
	for k in range(0,20):
		for i in range(0,N):
			for j in range(0,N):
				p[i][j] = (div[i][j]+p[i-1][j]+p[i+1][j]+p[i][j-1]+p[i][j+1])/4;
	set_bnd ( N, 0, p );

	for i in range(0,N):
		for j in range(0,N):
			u[i][j] -= 0.5*(p[i+1][j]-p[i-1][j])/h
			v[i][j] -= 0.5*(p[i][j+1]-p[i][j-1])/h
	set_bnd ( N, 1, u ); set_bnd ( N, 2, v );

func set_bnd ( N, b, x ):
	return
	for i in range(0,N):
		x[0][i] = -x[1][i] if b==1 else x[1][i]
		x[n-1][i] = -x[n-2][i] if b==1 else x[n-2][i]
		x[i][0] = -x[i][1] if b==2 else x[i][1]
		x[i][n-1] = -x[i][n-2] if b==2 else x[i][n-2]
	x[0][0] = 0.5*(x[1][0]+x[0][1])
	x[0][n-1] = 0.5*(x[1][n-1]+x[0][n-2])
	x[n-1][0] = 0.5*(x[n-2][0]+x[n-1][1])
	x[n-1][n-1] = 0.5*(x[n-1][n-2]+x[n-1][n-2])


var fire_threshold = 1.15
const fire_col = Color(1.0,0.5,0.0,1.0)
# const fire_col = Color(1.0,0,0,1.0)
func _draw():
	var viewport = get_viewport_rect().size
	draw_set_transform(Vector2(0,0),0,Vector2(2,2))
	for i in range(dens.size()):
		for j in range(dens[i].size()):
			var pos = Vector2(i,j)  * (viewport / (n*2))
			var d = min(dens[i][j], 0.6)
			var col = Color(d,d,d,d)
			#if dens[i][j] > fire_threshold:
			#	col += fire_col
			# draw_primitive([pos], [col], [Vector2(0,0)])
			# There is a +15 instead of n/2 because the division works weird and im lazy
			var rect = Rect2(pos, Vector2(viewport.x/n,viewport.y/n))
			draw_rect(rect,col,true)

var isMousePressed = false
func _input(event):
	if isMousePressed and event is InputEventMouseMotion:
		var viewport = get_viewport_rect().size
		var pos = floor((get_local_mouse_position() / get_viewport_rect().size) * n)

		
		# fuck you nigga
		if pos.x < dens.size():
			if pos.y < dens[pos.x].size():
				dens[pos.x][pos.y] += 3.75
				_u[pos.x][pos.y] = event.relative.x / 5
				_v[pos.x][pos.y] = event.relative.y / 5

func addSmoke(screenPos, density):
	var pos = floor((screenPos / get_viewport_rect().size) * (n))
	if dens.size() > pos.x:
		if dens[pos.x].size() > pos.y:
			dens[pos.x][pos.y] += density
func setSmoke(screenPos, density):
	var pos = (screenPos / get_viewport_rect().size) * n
	dens[pos.x][pos.y] = density

func _on_smoke_update_timer_timeout():
	updateSmoke()











@export var shutdown = false
func updateSmoke():
	if shutdown:
		return
	var densDup = dens.duplicate()
	diffuse(n-1, 10, dens, dens, 0.003, timestep)
	advect(n-1,10,dens,densDup, _u, _v,timestep)



	# The velocities
	var uDup = _u.duplicate()
	var vDup = _v.duplicate()
	diffuse(n-1, 10, _u, uDup, 0.003, timestep)
	diffuse(n-1, 10, _v, vDup, 0.003, timestep)
	#project(n-1, _u, _v, uDup, vDup)
	#uDup = _u.duplicate()	
	#vDup = _v.duplicate()
	#advect(n-1, 1, _u, uDup, _v, vDup, timestep)
	#advect(n-1, 2, _v, vDup, _u, uDup, timestep)
	#project(n-1, _u, _v, uDup, vDup)
	queue_redraw()
