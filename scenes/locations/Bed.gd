extends Area2D

@export var target_spawn_point: String = ""
@export var wakeup_marker_path: NodePath

func interact():
	if GameState.current_day == 1 and not GameState.day_1_objectives_done:
		var player = get_tree().get_first_node_in_group("player")
		player.set_can_move(false)

		if not Dialogic.timeline_ended.is_connected(_on_dialog_finished):
			Dialogic.timeline_ended.connect(_on_dialog_finished)

		Dialogic.start("bed_not_ready")
		return

	var room = get_tree().current_scene
	await room.sleep_transition(wakeup_marker_path)
	
func _on_dialog_finished():
	var player = get_tree().get_first_node_in_group("player")
	player.set_can_move(true)
