extends Area2D

@onready var sprite = $Sprite2D

@export var wood_texture: Texture2D
@export var stick_texture: Texture2D
@export var hits_needed: int = 2

signal cut

var hit_count := 0
var is_cutting := false
var is_cut := false

func _ready():
	sprite.texture = wood_texture

func cut_grass():
	if is_cut or is_cutting:
		return

	is_cutting = true
	hit_count += 1

	await get_tree().create_timer(0.25).timeout

	if hit_count >= hits_needed:
		is_cut = true
		sprite.texture = stick_texture
		cut.emit()

	is_cutting = false
