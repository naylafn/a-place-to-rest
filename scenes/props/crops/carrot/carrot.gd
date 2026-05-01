extends Area2D

enum CropState {
	NEW,
	GROWN,
	ROTTEN
}

@export var state: CropState = CropState.NEW
@export var new_texture: Texture2D
@export var grown_texture: Texture2D
@export var rotten_texture: Texture2D
@export var needs_water: bool = true


@onready var sprite = $Sprite2D
@onready var water_icon = $WaterIcon


signal watered
var time := 0.0


func _ready():
	update_visual()
	update_water_icon()


func _process(delta):
	time += delta
	water_icon.position.y = -15 + sin(time * 4.0) * 3.0

func water():
	if state == CropState.ROTTEN:
		return

	if not needs_water:
		return

	needs_water = false
	watered.emit()

	await get_tree().create_timer(0.5).timeout
	water_icon.visible = false

func grow():
	if state == CropState.NEW:
		state = CropState.GROWN
	elif state == CropState.GROWN:
		state = CropState.ROTTEN

	update_visual()
	

func update_water_icon():
	water_icon.visible = needs_water and state != CropState.ROTTEN

func update_visual():
	match state:
		CropState.NEW:
			sprite.texture = new_texture
		CropState.GROWN:
			sprite.texture = grown_texture
		CropState.ROTTEN:
			sprite.texture = rotten_texture
