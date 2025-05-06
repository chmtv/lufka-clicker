extends Panel

@export var mapStyleBox : StyleBoxTexture
@export var specialStyleBox : StyleBoxTexture

@export var buyButton : Button
@export var name_label : Label
@export var desc_label : Label
func set_style_map():
	add_theme_stylebox_override("panel", mapStyleBox)
	self_modulate = Color(.67,.67,.67,1.)
	
	buyButton.add_theme_stylebox_override("normal", mapStyleBox)
	buyButton.add_theme_stylebox_override("hover", mapStyleBox)
	buyButton.add_theme_stylebox_override("pressed", mapStyleBox)
	buyButton.add_theme_color_override("font_color", "ff2c55")
	buyButton.add_theme_color_override("font_outline_color", "c41e3d")

	name_label.add_theme_color_override("font_color", "ff2c55")
	name_label.add_theme_color_override("font_outline_color", "c41e3d")
	desc_label.add_theme_color_override("font_color", "ff2c55")
	desc_label.add_theme_color_override("font_outline_color", "c41e3d")

func set_style_special():
	add_theme_stylebox_override("panel", specialStyleBox)
	
	buyButton.add_theme_stylebox_override("normal", specialStyleBox)
	buyButton.add_theme_stylebox_override("hover", specialStyleBox)
	buyButton.add_theme_stylebox_override("pressed", specialStyleBox)
	buyButton.add_theme_color_override("font_color", "ff2c55")
	buyButton.add_theme_color_override("font_outline_color", "c41e3d")

	name_label.add_theme_color_override("font_color", "ff2c55")
	name_label.add_theme_color_override("font_outline_color", "c41e3d")
	desc_label.add_theme_color_override("font_color", "ff2c55")
	desc_label.add_theme_color_override("font_outline_color", "c41e3d")
