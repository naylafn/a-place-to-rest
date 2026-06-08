extends Area2D

@onready var sprite = $Sprite2D
@onready var icon = $ExclamationIcon

@export var stage_0: Texture2D
@export var stage_1: Texture2D

signal cut
var stage: int = 1  # Default: rumput panjang
var is_cutting: bool = false
var icon_start_y := 0.0
var time := 0.0

func _ready():
	monitoring = true      # Area2D bisa mendeteksi area lain
	monitorable = true     # Area2D ini bisa dideteksi
	icon_start_y = icon.position.y
	update_visual()

func _process(delta):
	if stage == 0:
		return

	time += delta
	icon.position.y = icon_start_y + sin(time * 4.0) * 3.0

func update_visual():
	match stage:
		0:
			sprite.texture = stage_0
			icon.visible = false
		1:
			sprite.texture = stage_1
			icon.visible = true

func cut_grass():
	if stage == 0 or is_cutting:
		return

	is_cutting = true
	cut.emit()

	await get_tree().create_timer(0.35).timeout

	stage = 0
	update_visual()
	is_cutting = false
