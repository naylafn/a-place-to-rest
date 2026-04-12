extends CharacterBody2D

@export var speed: float = 100.0

@onready var anim = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var attack_shape = $AttackArea/CollisionShape2D

var last_direction: Vector2 = Vector2.DOWN
var is_attacking: bool = false

func _ready():
	attack_shape.disabled = true
	
func _physics_process(delta):
	if is_attacking:
		return

	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		last_direction = direction

	handle_animation(direction)

func _input(event):
	if event.is_action_pressed("mouse_left"):
		start_slice()

func start_slice():
	if is_attacking:
		return

	is_attacking = true
	velocity = Vector2.ZERO

	update_attack_area()
	play_slice_animation()

	# Enable the hitbox — signal fires automatically on overlap
	attack_shape.disabled = false

func update_attack_area():
	if abs(last_direction.x) > abs(last_direction.y):
		attack_area.position = Vector2(30 if last_direction.x > 0 else -30, -15)
	else:
		attack_area.position = Vector2(0, 5 if last_direction.y > 0 else -50)

# This fires automatically whenever AttackArea overlaps an Area2D
func _on_attack_area_entered(area: Area2D):
	if not is_attacking:
		return
	if area.has_method("cut_grass"):
		area.cut_grass()

func _on_animated_sprite_2d_animation_finished():
	if anim.animation.begins_with("slice"):
		is_attacking = false
		attack_shape.disabled = true  # Disable hitbox after attack ends
# Animations
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

func play_slice_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		anim.play("slice_side")
		anim.flip_h = last_direction.x < 0
	else:
		if last_direction.y > 0:
			anim.play("slice_down")
		else:
			anim.play("slice_up")
