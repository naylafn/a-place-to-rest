extends Node2D
@onready var spirit1 = $Spirit1
@onready var spirit2 = $Spirit2
@onready var skeleton1 = $Skeleton1
@onready var skeleton2 = $Skeleton2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spirit1.play("default")
	spirit2.play("default")
	skeleton1.play("default")
	skeleton2.play("default")
