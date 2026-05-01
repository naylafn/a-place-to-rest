extends CanvasLayer

@onready var color_rect = $ColorRect

func _ready():
	color_rect.visible = false
	color_rect.modulate.a = 0.0

# Fade IN
func fade_in(duration: float = 1.0):
	color_rect.visible = true
	color_rect.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	await tween.finished

# Fade OUT
func fade_out(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	color_rect.visible = false

func fade_black():
	await fade_in(0.5)

func fade_clear():
	await fade_out(0.5)
