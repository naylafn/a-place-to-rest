extends Node2D

signal bridge_investigated

@onready var icon = $ExclamationIcon
@export var altar_scene: String = "res://scenes/locations/Altar.tscn"
@export var altar_spawn_point: String = ""

var icon_start_y := 0.0
var time := 0.0
var dialog_playing := false
var has_been_investigated := false

func _ready():
	icon_start_y = icon.position.y

func _process(delta):
	time += delta
	icon.position.y = icon_start_y + sin(time * 4.0) * 3.0

func interact():
	if GameState.day_2_wood_done:
		SceneTransition.spawn_point_name = altar_spawn_point
		get_tree().change_scene_to_file(altar_scene)
		return

	if dialog_playing:
		return

	dialog_playing = true

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(false)

	if not Dialogic.timeline_ended.is_connected(_on_dialog_finished):
		Dialogic.timeline_ended.connect(_on_dialog_finished)

	Dialogic.start("broken_bridge")

func _on_dialog_finished():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(true)

	dialog_playing = false

	if not has_been_investigated:
		has_been_investigated = true
		bridge_investigated.emit()
		icon.visible = false
