extends RichTextEffect
class_name RichTextBreathing
var frequency = 2.0
var bbcode = "breathe"
func _process_custom_fx(char_fx: CharFXTransform):
	var time = Time.get_ticks_msec() / 1000.0
	var scale_factor = sin(time * frequency) * 0.2 + 1.2
	char_fx.transform = char_fx.transform * scale_factor
	return true
