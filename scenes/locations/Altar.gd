extends Node2D

@onready var player = $David

func _ready():
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

	if not GameState.opening_altar_dialog_played:
		GameState.opening_altar_dialog_played = true
		player.set_can_move(false)
		Dialogic.start("opening_altar")
	else:
		player.set_can_move(true)

func _on_dialogic_timeline_ended():
	player.set_can_move(true)
