extends Node2D

@onready var player = $David
@onready var end_screen = $EndScreen
@onready var end_label = $EndScreen/Label
@onready var fade = $FadeTransition
@onready var objective_label = $ObjectiveUI/Panel/VBoxContainer/ObjectiveLabel

func _ready():
	end_screen.visible = false

	if SceneTransition.spawn_point_name != "":
		var spawn_point = get_node(SceneTransition.spawn_point_name)
		player.global_position = spawn_point.global_position
		SceneTransition.spawn_point_name = ""

	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

	if not GameState.opening_3_dialog_played:
		GameState.opening_3_dialog_played = true
		player.set_can_move(false)
		Dialogic.start("opening_3")
	else:
		player.set_can_move(true)
	
	update_objective_ui()

func show_ending_screen():
	player.set_can_move(false)

	await fade.fade_in(2.0)

	end_screen.visible = true
	end_label.modulate.a = 0.0
	end_label.text = "A Place to Rest"

	var tween = create_tween()
	tween.tween_property(end_label, "modulate:a", 1.0, 2.0)

	await tween.finished
	await get_tree().create_timer(5.0).timeout

	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func update_objective_ui():
	if not GameState.secret_room_dialog_done:
		objective_label.text = "Unlock secret room in the house."
	else:
		objective_label.text = "Go to the bonfire."

func _on_dialogic_timeline_ended():
	if GameState.ending_started:
		return

	player.set_can_move(true)
