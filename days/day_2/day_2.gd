extends Node2D

@onready var objective_label = $ObjectiveUI/Panel/VBoxContainer/ObjectiveLabel
@onready var player = $David

var bridge_investigated := false
var total_wood := 0
var cut_wood := 0

func _ready():
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

	if not GameState.opening_2_dialog_played:
		GameState.opening_2_dialog_played = true
		player.set_can_move(false)
		Dialogic.start("opening_2")
	else:
		player.set_can_move(true)

	if SceneTransition.spawn_point_name != "":
		var spawn_point = get_node(SceneTransition.spawn_point_name)
		player.global_position = spawn_point.global_position
		SceneTransition.spawn_point_name = ""
		
	show_investigate_objective()

	var woods = get_tree().get_nodes_in_group("source")
	total_wood = woods.size()

	for wood in woods:
		wood.cut.connect(_on_wood_cut)

	var broken_bridge = $BrokenBridge
	broken_bridge.bridge_investigated.connect(_on_bridge_investigated)

func show_investigate_objective():
	objective_label.text = "Investigate the footprints"

func _on_bridge_investigated():
	bridge_investigated = true
	update_wood_objective()

func _on_wood_cut():
	if not bridge_investigated:
		return

	cut_wood += 1
	update_wood_objective()

func update_wood_objective():
	objective_label.text = "Collect wood: %d / %d" % [cut_wood, total_wood]

	if cut_wood >= total_wood:
		GameState.day_2_wood_done = true
		objective_label.text = "Return to the broken bridge."

func _on_dialogic_timeline_ended():
	player.set_can_move(true)
