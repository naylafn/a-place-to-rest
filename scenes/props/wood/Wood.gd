extends Area2D

@onready var sprite = $Sprite2D
@onready var icon = $ExclamationIcon

@export var wood_texture: Texture2D
@export var stick_texture: Texture2D
@export var hits_needed: int = 2

signal cut

var hit_count := 0
var is_cutting := false
var is_cut := false
var icon_start_y := 0.0
var time := 0.0

func _ready():
	icon_start_y = icon.position.y
	sprite.region_enabled = false
	sprite.texture = wood_texture
	icon.visible = not is_cut

func _process(delta):
	if is_cut:
		return

	time += delta
	icon.position.y = icon_start_y + sin(time * 4.0) * 3.0

func cut_grass():
	if is_cut or is_cutting:
		return

	is_cutting = true
	hit_count += 1

	await get_tree().create_timer(0.25).timeout

	if hit_count >= hits_needed:
		is_cut = true
		sprite.region_enabled = false
		sprite.texture = stick_texture
		icon.visible = false
		cut.emit()

	is_cutting = false
