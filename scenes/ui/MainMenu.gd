extends Control

@export var start_scene: String = "res://days/day_1/Day 1.tscn"

@onready var start_button = $VBoxContainer/StartButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	start_button.grab_focus()

	$VBoxContainer.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 1.0, 1.5)

func _on_start_pressed():
	reset_game_state()
	get_tree().change_scene_to_file(start_scene)

func reset_game_state():
	GameState.current_day = 1
	GameState.day_1_objectives_done = false
	GameState.day_2_wood_done = false
	GameState.doll_found = false
	GameState.letter_read = false
	GameState.opening_dialog_played = false
	GameState.opening_2_dialog_played = false
	GameState.opening_3_dialog_played = false
	GameState.opening_altar_dialog_played = false
	GameState.enter_house_dialog_played = false
	GameState.ending_started = false
	SceneTransition.spawn_point_name = ""
