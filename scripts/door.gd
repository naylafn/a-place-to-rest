extends Area2D

@export var target_scene: String
@export var target_spawn_point: String = ""
@export var target_day: int = 1

@export var use_requirement: bool = false
@export var required_doll_found: bool = false
@export var locked_dialog: String = "need_to_find_doll"

@export var fallback_scene: String = "res://days/day_2/Day 2.tscn"
@export var fallback_spawn_point: String = "BridgeSpawn"
@export var fallback_day: int = 2

var player_in_range = false

func interact():
	if use_requirement and required_doll_found and not GameState.doll_found:
		GameState.current_day = fallback_day
		SceneTransition.spawn_point_name = fallback_spawn_point
		get_tree().change_scene_to_file(fallback_scene)
		return
	
	GameState.current_day = target_day
	SceneTransition.spawn_point_name = target_spawn_point
	get_tree().change_scene_to_file(target_scene)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_area_2d_body_exited(body):
	print("Body exited door area:", body.name)
	if body.is_in_group("player"):
		player_in_range = false
