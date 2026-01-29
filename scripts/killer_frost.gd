extends CharacterBody2D

@export var speed := 120
@export var gravity := 800
@export var min_x := 16
@export var max_x := 640 - 16

var on_ladder := false
@onready var sprite := $Sprite2D

func _physics_process(delta):
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")

	if on_ladder:
		if direction_y != 0:
			# Subiendo o bajando
			velocity.y = direction_y * speed
			velocity.x = 0
		else:
			# Caminando por delante de la escalera
			velocity.y = 0
			velocity.x = direction_x * speed
	else:
		# Movimiento normal
		if not is_on_floor():
			velocity.y += gravity * delta
		velocity.x = direction_x * speed

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
