extends Node2D

@onready var objective_label = $ObjectiveUI/Panel/VBoxContainer/ObjectiveLabel
@onready var player = $David

var bridge_investigated := false
var total_crops := 0
var watered_crops := 0
var total_grass := 0
var cut_grass := 0
var total_wood := 0
var cut_wood := 0

func _ready():
	GameState.is_outdoor = true
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

	var crops = get_tree().get_nodes_in_group("crops")
	total_crops = crops.size()

	for crop in crops:
		crop.watered.connect(_on_crop_watered)

	var grass_map = get_node_or_null("GrassMap")
	if grass_map:
		var grasses = grass_map.get_children()
		total_grass = grasses.size()

		for grass in grasses:
			grass.cut.connect(_on_grass_cut)

	var wood_map = get_node_or_null("WoodMap")
	if wood_map:
		var woods = wood_map.get_children()
		total_wood = woods.size()

		for wood in woods:
			wood.cut.connect(_on_wood_cut)

	var broken_bridge = $BrokenBridge
	broken_bridge.bridge_investigated.connect(_on_bridge_investigated)

	update_objective_ui()

func update_objective_ui():
	if not bridge_investigated:
		objective_label.text = "Investigate the footprints"
		return

	objective_label.text = "Water crops: %d / %d\nCut grass: %d / %d\nCollect wood: %d / %d" % [watered_crops, total_crops, cut_grass, total_grass, cut_wood, total_wood]

	if watered_crops >= total_crops and cut_grass >= total_grass and cut_wood >= total_wood:
		GameState.day_2_wood_done = true
		objective_label.text = "Return to the broken bridge."

func _on_bridge_investigated():
	bridge_investigated = true
	update_objective_ui()

func _on_crop_watered():
	watered_crops += 1
	update_objective_ui()

func _on_grass_cut():
	cut_grass += 1
	update_objective_ui()

func _on_wood_cut():
	cut_wood += 1
	update_objective_ui()

func _on_dialogic_timeline_ended():
	player.set_can_move(true)
