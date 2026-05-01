extends CharacterBody2D

@export var speed: float = 100.0

@onready var anim = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var attack_shape = $AttackArea/CollisionShape2D
@onready var interact_area = $InteractArea
@onready var interact_shape = $InteractArea/CollisionShape2D
@onready var water_sfx = $WaterSFX

var last_direction: Vector2 = Vector2.DOWN
var is_attacking: bool = false

var current_crop: Area2D = null
var is_watering: bool = false
var can_move := true

var current_interactable: Area2D = null

func _ready():
	attack_shape.disabled = true
	update_interact_area()
	
func _physics_process(delta):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		play_idle_animation()
		return
		
	if is_attacking or is_watering:
		return

	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		last_direction = direction
		update_interact_area()

	handle_animation(direction)

func _input(event):
	if not can_move:
		return
	if event.is_action_pressed("mouse_left"):
		start_slice()
	if event.is_action_pressed("interact"):
		start_interact()
		
func set_can_move(value: bool):
	can_move = value
	velocity = Vector2.ZERO
	
func start_interact():
	if is_attacking or is_watering:
		return

	if current_interactable == null:
		print("No interactable")
		return
		
	if current_interactable.has_method("interact"):
		current_interactable.interact()
		return

	if current_interactable.has_method("read_letter"):
		current_interactable.read_letter()
		return

	if current_interactable.has_method("water"):
		start_watering()
		return

func start_slice():
	if is_attacking:
		return

	is_attacking = true
	velocity = Vector2.ZERO

	update_attack_area()
	play_slice_animation()

	# Enable the hitbox — signal fires automatically on overlap
	attack_shape.disabled = false
	
func start_watering():
	if is_attacking or is_watering:
		return

	if current_interactable == null:
		return

	is_watering = true
	velocity = Vector2.ZERO

	play_watering_animation()
	
	if water_sfx:
		water_sfx.play()

	if current_interactable.has_method("water"):
		current_interactable.water()

func update_attack_area():
	if abs(last_direction.x) > abs(last_direction.y):
		attack_area.position = Vector2(30 if last_direction.x > 0 else -30, -15)
	else:
		attack_area.position = Vector2(0, 5 if last_direction.y > 0 else -50)

func update_interact_area():
	if abs(last_direction.x) > abs(last_direction.y):
		interact_area.position = Vector2(15 if last_direction.x > 0 else -15, -10)
	else:
		interact_area.position = Vector2(0, 4 if last_direction.y > 0 else -25)
		
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
	if anim.animation.begins_with("watering"):
		is_watering = false
		
func _on_interact_area_area_entered(area: Area2D):
	print("Interact entered:", area.name)
	if area.has_method("read_letter") or area.has_method("water") or area.has_method("interact"):
		current_interactable = area

func _on_interact_area_area_exited(area: Area2D):
	if area == current_interactable:
		current_interactable = null

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

func play_watering_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		anim.play("watering_side")
		anim.flip_h = last_direction.x < 0
	else:
		if last_direction.y > 0:
			anim.play("watering_down")
		else:
			anim.play("watering_up")
