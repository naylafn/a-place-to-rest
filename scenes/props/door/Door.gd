extends Node2D

@export var is_locked: bool = false
@export var locked_dialog: String = "door_locked"

@export var unlock_when_doll_found: bool = false
@export var secret_room_path: NodePath

@onready var anim = $AnimatedSprite2D
@onready var blocker_collision = $Blocker/CollisionShape2D

var is_open := false
var is_animating := false

func _ready():
	if unlock_when_doll_found and GameState.doll_found:
		is_locked = false

	if secret_room_path != NodePath(""):
		var secret_room = get_node(secret_room_path)
		secret_room.visible = false

func unlock():
	is_locked = false

func interact():
	if is_animating:
		return

	if is_locked:
		play_locked_dialog()
		return

	if not is_open:
		await open_door()

func open_door():
	is_animating = true
	anim.play("open")

	await anim.animation_finished

	is_open = true
	is_animating = false
	blocker_collision.disabled = true

	show_secret_room_if_any()

func show_secret_room_if_any():
	if secret_room_path == NodePath(""):
		return

	var secret_room = get_node(secret_room_path)
	secret_room.visible = true

func play_locked_dialog():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(false)

	if not Dialogic.timeline_ended.is_connected(_on_dialog_finished):
		Dialogic.timeline_ended.connect(_on_dialog_finished)

	Dialogic.start(locked_dialog)

func _on_dialog_finished():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(true)
