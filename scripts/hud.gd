extends CanvasLayer

@onready var stamina_bar := $StaminaBar
@onready var health_bar := $HealthBar
@onready var player := get_parent().get_node("KillerFrost")

func _process(delta):
	if player:
		stamina_bar.value = player.stamina
		health_bar.value = player.health
