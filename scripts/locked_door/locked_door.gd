extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

@onready var buttons_pushed: int = 0
@export var buttons_needed: int = 1

func _on_puzzle_button_pressed() -> void:
	buttons_pushed += 1
	if buttons_pushed >= buttons_needed:
		sprite.play("unlocked")
		collision_shape.set_deferred("disabled", true)


func _on_puzzle_button_unpressed() -> void:
	buttons_pushed -= 1
	if buttons_pushed <= buttons_needed:
		sprite.play("locked")
		collision_shape.set_deferred("disabled", false)
