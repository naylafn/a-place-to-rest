extends Area2D

@export var first_dialog: String = "yippie"
@export var ending_dialog: String = "ending"
@export var no_doll_dialog: String = "need_doll"

@onready var bonfire_anim = $AnimatedSprite2D
@onready var fire_anim = $Fire
@onready var light = $PointLight2D
@onready var spirit = get_tree().current_scene.get_node("Spirits")

var has_burned_doll := false
var dialog_playing := false

func _ready():
	bonfire_anim.play("default")
	fire_anim.visible = false
	light.enabled = false
	spirit.visible = false

func _process(delta):
	if light.enabled:
		light.energy = randf_range(1.0, 1.3)

func interact():
	if dialog_playing or has_burned_doll:
		return

	# Bonfire belum bisa dipakai sebelum dialog secret_room selesai
	if not GameState.secret_room_dialog_done:
		return

	var player = get_tree().get_first_node_in_group("player")

	# Jika secret_room sudah selesai tapi doll belum ditemukan
	if not GameState.doll_found:
		if player:
			player.set_can_move(false)

		dialog_playing = true
		Dialogic.timeline_ended.connect(_on_no_doll_dialog_finished, CONNECT_ONE_SHOT)
		Dialogic.start(no_doll_dialog)
		return

	# Jika doll sudah ditemukan, mulai ending flow
	has_burned_doll = true
	GameState.doll_found = false
	dialog_playing = true

	if player:
		player.set_can_move(false)

	fire_anim.visible = true
	fire_anim.play("default")
	light.enabled = true

	Dialogic.timeline_ended.connect(_on_yippie_finished, CONNECT_ONE_SHOT)
	Dialogic.start(first_dialog)

func _on_yippie_finished():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(false)

	var current_scene = get_tree().current_scene
	var fade = current_scene.get_node("FadeTransition")

	await fade.fade_black()
	await get_tree().create_timer(0.5).timeout
	await fade.fade_clear()

	if player:
		player.set_can_move(false)

	var spirit = current_scene.get_node("Spirits")
	spirit.visible = true

	Dialogic.timeline_ended.connect(_on_ending_dialog_finished, CONNECT_ONE_SHOT)
	GameState.ending_started = true
	Dialogic.start(ending_dialog)

func _on_no_doll_dialog_finished():
	dialog_playing = false

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_can_move(true)

func _on_ending_dialog_finished():
	dialog_playing = false

	var current_scene = get_tree().current_scene
	await current_scene.show_ending_screen()
