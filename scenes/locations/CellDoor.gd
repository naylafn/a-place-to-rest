extends Area2D

@export var dialog_name: String = "secret_room"

var dialog_playing := false
var has_triggered := false

func interact():
	if dialog_playing:
		return

	if has_triggered:
		return

	has_triggered = true
	dialog_playing = true

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(false)

	if not Dialogic.timeline_ended.is_connected(_on_dialog_finished):
		Dialogic.timeline_ended.connect(_on_dialog_finished)

	Dialogic.start(dialog_name)

func _on_dialog_finished():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(true)

	GameState.secret_room_dialog_done = true

	var scene = get_tree().current_scene
	if scene.has_method("update_objective_ui"):
		scene.update_objective_ui()

	dialog_playing = false
