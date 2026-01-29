extends CharacterBody2D

@export var speed := 120
@export var gravity := 800
@export var min_x := 16
@export var max_x := 640 - 16

@export var stamina_max := 100.0
@export var stamina := 100.0
@export var stamina_drain_walk := 10.0   # por segundo
@export var stamina_drain_ladder := 15.0
@export var stamina_recover := 20.0       # por segundo
@export var tired_speed_factor := 0.5     # velocidad cuando está cansado

var on_ladder := false
@onready var sprite := $Sprite2D

func _physics_process(delta):
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	var is_moving := false

	var current_speed := speed
	if stamina <= 0:
		current_speed *= tired_speed_factor
		
	if on_ladder:
		if direction_y != 0:
			is_moving = true
			velocity.y = direction_y * current_speed
			velocity.x = 0
		elif direction_x != 0:
			is_moving = true
			velocity.y = 0
			velocity.x = direction_x * current_speed
		else:
			velocity.y = 0
			velocity.x = 0
	else:
		# Movimiento normal
		velocity.y = velocity.y
		if not is_on_floor():
			velocity.y += gravity * delta
		if direction_x != 0:
			is_moving = true
		velocity.x = direction_x * current_speed

	# STAMINA
	if is_moving:
		if on_ladder and direction_y != 0:
			stamina -= stamina_drain_ladder * delta
		else:
			stamina -= stamina_drain_walk * delta
	else:
		stamina += stamina_recover * delta

	stamina = clamp(stamina, 0.0, stamina_max)
	
	# Animaciones	
	if on_ladder:
		if direction_y != 0:
			sprite.play("walk") # luego será "climb"
		elif direction_x != 0:
			sprite.play("walk")
			sprite.flip_h = direction_x < 0
		else:
			sprite.play("idle")
	else:
		if direction_x != 0:
			sprite.play("walk")
			sprite.flip_h = direction_x < 0
		else:
			sprite.play("idle")

	move_and_slide()

	# Límite de pantalla (lo que ya tenías)
	position.x = clamp(position.x, min_x, max_x)



func _on_ladder_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("ladder"):
		on_ladder = true
		velocity = Vector2.ZERO # Replace with function body.


func _on_ladder_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("ladder"):
		on_ladder = false # Replace with function body.
