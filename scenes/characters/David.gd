extends CharacterBody2D

@export var speed: float = 100.0

@onready var anim = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN  # default menghadap bawah

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Input movement
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	# Simpan arah terakhir kalau sedang bergerak
	if direction != Vector2.ZERO:
		last_direction = direction

	handle_animation(direction)


func handle_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		play_idle_animation()
		return

	if abs(direction.x) > abs(direction.y):
		# Horizontal
		anim.play("walk_side")
		anim.flip_h = direction.x < 0
	else:
		# Vertical
		if direction.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")


func play_idle_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		# Horizontal idle
		anim.play("idle_side")
		anim.flip_h = last_direction.x < 0
	else:
		# Vertical idle
		if last_direction.y > 0:
			anim.play("idle_down")
		else:
			anim.play("idle_up")
