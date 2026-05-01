extends Area2D

@export var dialog_name: String = "doll_found"

var picked := false

func interact():
	if picked:
		return

	picked = true
	GameState.doll_found = true

	var secret_door = get_tree().get_first_node_in_group("secret_door")
	if secret_door:
		secret_door.unlock()

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(false)

	if not Dialogic.timeline_ended.is_connected(_on_dialog_finished):
		Dialogic.timeline_ended.connect(_on_dialog_finished)

	Dialogic.start("doll_found")

func _on_dialog_finished():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(true)

	queue_free()
