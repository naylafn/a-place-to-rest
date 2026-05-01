extends Node2D

@onready var player = $Node2D
@onready var letter = $Letter
@onready var carrot_label = $ObjectiveUI/Panel/VBoxContainer/CarrotLabel
@onready var grass_label = $ObjectiveUI/Panel/VBoxContainer/GrassLabel
@onready var complete_label = $ObjectiveUI/Panel/VBoxContainer/CompleteLabel

var total_carrots := 0
var watered_carrots := 0

var total_grass := 0
var cut_grass := 0

var after_letter_triggered := false

func _ready():
	GameState.is_outdoor = true
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

	if not GameState.opening_dialog_played:
		GameState.opening_dialog_played = true
		player.set_can_move(false)
		Dialogic.start("opening")
	else:
		player.set_can_move(true)
	
	if SceneTransition.spawn_point_name != "":
		var spawn_point = get_node(SceneTransition.spawn_point_name)
		player.global_position = spawn_point.global_position
		SceneTransition.spawn_point_name = ""
		
	letter.set_letter_text(
		"Dear David,

If you are reading this,
then you’ve finally made it here.

I wish I could be there to welcome you in person.
Things have been… a little complicated on my end.

The farm needs someone to look after it,
so I’m trusting you with it for now.
Take care of it, and it will take care of you.

Just don’t wander too far.
Some paths don’t lead back the way you expect.

If something feels strange…
it’s best not to dwell on it.
This place has its own way of keeping things as they are.

I’ll come back when I feel better.
Until then, make yourself at home.

— Grandpa"
	)

	letter.letter_opened.connect(_on_letter_opened)
	letter.letter_closed.connect(_on_letter_closed)
	
	var carrots = get_tree().get_nodes_in_group("crops")
	var grasses = get_tree().get_nodes_in_group("source")

	total_carrots = carrots.size()
	total_grass = grasses.size()

	for carrot in carrots:
		carrot.watered.connect(_on_carrot_watered)

	for grass in grasses:
		grass.cut.connect(_on_grass_cut)

	update_objective_ui()
	
func show_complete_message():
	complete_label.visible = true
	complete_label.modulate.a = 0.0
	complete_label.text = "All tasks done!\nGo to sleep."

	var tween = create_tween()
	tween.tween_property(complete_label, "modulate:a", 1.0, 0.5)

func _on_letter_opened():
	player.set_can_move(false)

func _on_letter_closed():
	if after_letter_triggered:
		player.set_can_move(true)
		return

	after_letter_triggered = true
	
	player.set_can_move(false)
	Dialogic.start("after_letter")
	
func _on_carrot_watered():
	watered_carrots += 1
	update_objective_ui()
	check_day_complete()

func _on_grass_cut():
	cut_grass += 1
	update_objective_ui()
	check_day_complete()

func update_objective_ui():
	carrot_label.text = "Water crops: %d / %d" % [watered_carrots, total_carrots]
	grass_label.text = "Cut grass: %d / %d" % [cut_grass, total_grass]

func check_day_complete():
	if watered_carrots >= total_carrots and cut_grass >= total_grass:
		GameState.day_1_objectives_done = true
		show_complete_message()

func _on_dialogic_timeline_ended():
	player.set_can_move(true)
