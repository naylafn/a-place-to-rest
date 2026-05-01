extends Area2D

@onready var sprite = $Sprite2D

@export var stage_0: Texture2D
@export var stage_1: Texture2D

signal cut
var stage: int = 1  # Default: rumput panjang
var is_cutting: bool = false

func _ready():
	monitoring = true      # Area2D bisa mendeteksi area lain
	monitorable = true     # Area2D ini bisa dideteksi
	update_visual()

func update_visual():
	match stage:
		0:
			sprite.texture = stage_0
		1:
			sprite.texture = stage_1

func cut_grass():
	if stage == 0 or is_cutting:
		return

	is_cutting = true
	cut.emit()

	await get_tree().create_timer(0.35).timeout

	stage = 0
	update_visual()
	is_cutting = false
