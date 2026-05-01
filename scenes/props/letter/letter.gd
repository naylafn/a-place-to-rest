extends Area2D

signal letter_opened
signal letter_closed

@export_multiline var letter_text: String = ""

@onready var letter_ui = $LetterUI
@onready var label = $"LetterUI/Panel/MarginContainer/ScrollContainer/Label"
@onready var icon = $ExclamationIcon

var icon_start_y := 0.0
var time := 0.0
var has_been_read := false
var is_open := false

func _ready():
	letter_ui.visible = false
	icon_start_y = icon.position.y

	has_been_read = GameState.letter_read
	icon.visible = not has_been_read
	
func _process(delta):
	if not has_been_read:
		time += delta
		icon.position.y = icon_start_y + sin(time * 4.0) * 3.0

func set_letter_text(new_text: String):
	letter_text = new_text

func read_letter():
	if is_open:
		return

	is_open = true
	letter_opened.emit()

	label.text = letter_text
	letter_ui.visible = true

	has_been_read = true
	GameState.letter_read = true
	icon.visible = false

func _unhandled_input(event):
	if not is_open:
		return

	if event.is_action_pressed("mouse_left"):
		close_letter()

func close_letter():
	is_open = false
	letter_ui.visible = false
	letter_closed.emit()
