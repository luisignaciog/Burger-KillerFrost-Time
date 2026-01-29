extends CanvasLayer

@onready var stamina_bar := $StaminaBar
@onready var player := get_parent().get_node("KillerFrost")

func _process(delta):
	stamina_bar.value = player.stamina
