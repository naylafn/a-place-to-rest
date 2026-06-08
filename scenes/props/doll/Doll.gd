extends Area2D

@export var dialog_name: String = "doll_found"

@onready var icon = $ExclamationIcon

var picked := false
var icon_start_y := 0.0
var time := 0.0

func _ready():
	icon_start_y = icon.position.y

func _process(delta):
	if picked:
		return

	time += delta
	icon.position.y = icon_start_y + sin(time * 4.0) * 3.0

func interact():
	if picked:
		return

	picked = true
	icon.visible = false
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
