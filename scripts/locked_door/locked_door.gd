extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _on_puzzle_button_pressed() -> void:
	sprite.play("unlocked")
	collision_shape.set_deferred("disabled", true)


func _on_puzzle_button_unpressed() -> void:
	sprite.play("locked")
	collision_shape.set_deferred("disabled", false)
