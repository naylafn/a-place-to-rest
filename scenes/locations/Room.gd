extends Node2D

@onready var player = $David
@onready var fade_transition = $FadeTransition
@onready var door = $Area2D

func _ready():
	if not GameState.enter_house_dialog_played:
		GameState.enter_house_dialog_played = true
		play_enter_house_dialog()

	update_exit_door()

func play_enter_house_dialog():
	player.set_can_move(false)

	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

	Dialogic.start("enter_house")

func _on_dialogic_timeline_ended():
	player.set_can_move(true)
	
func sleep_transition(wakeup_marker_path: NodePath):
	player.set_can_move(false)

	await fade_transition.fade_black()

	GameState.current_day = 2

	if wakeup_marker_path != NodePath(""):
		var marker = get_node(wakeup_marker_path)
		player.global_position = marker.global_position

	update_exit_door()

	await get_tree().create_timer(0.3).timeout
	await fade_transition.fade_clear()

	player.set_can_move(true)

func update_exit_door():
	match GameState.current_day:
		1:
			door.target_scene = "res://days/day_1/Day 1.tscn"
			door.target_spawn_point = "HouseDoorSpawn"
		2:
			door.target_scene = "res://days/day_2/Day 2.tscn"
			door.target_spawn_point = "HouseDoorSpawn"
		3:
			door.target_scene = "res://days/day_3/Day 3.tscn"
			door.target_spawn_point = "HouseDoorSpawn"
