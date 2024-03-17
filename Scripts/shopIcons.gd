extends TabContainer

func setIcon(index, imgResPath):
	var image = load(imgResPath)
	# image.flags = 0
	set_tab_icon(index, image)
	set_tab_title(index, "")

func _ready():
	setIcon(0, "res://Sprites/Icons/lufkaIconSmall.png")
	setIcon(1, "res://Sprites/Icons/upgIconSmall.png")
	setIcon(2, "res://Sprites/Icons/mapIconSmall.png")

func setUpgradesHightlight(highlighted : bool):
	if highlighted:
		setIcon(1, "res://Sprites/Icons/upgHighlightSmall.png")
	else:
		setIcon(1, "res://Sprites/Icons/upgIconSmall.png")
