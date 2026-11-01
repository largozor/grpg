extends Area2D

@onready var sprite = $AnimatedSprite2D

@export var is_single_use: bool

var bodies_on_top: int = 0

signal pressed
signal unpressed

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("pushable") or body is Player:
		bodies_on_top += 1
		if bodies_on_top == 1:
			sprite.play("pressed")
			emit_signal("pressed")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("pushable") or body is Player:
		bodies_on_top -= 1
		if bodies_on_top == 0 and not is_single_use:
			sprite.play("unpressed")
			emit_signal("unpressed")
