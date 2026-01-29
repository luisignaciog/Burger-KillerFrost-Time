extends CharacterBody2D

@export var speed := 80
@export var patrol_width := 640

var direction := 1
var start_x := 0.0

func _ready():
	start_x = position.x

func _physics_process(delta):
	velocity.x = direction * speed
	move_and_slide()

	if is_on_wall():
		direction *= -1

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(25)
