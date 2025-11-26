extends Area2D

@onready var sprite = $AnimatedSprite2D

var bodies_on_top: int = 0

signal pressed
signal unpressed

func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	print("bodies on top: " + str(bodies_on_top))
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 1:
			sprite.play("pressed")
			emit_signal("pressed")


func _on_body_exited(body: Node2D) -> void:
	bodies_on_top -= 1
	print("bodies on top: " + str(bodies_on_top))
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 0:
			sprite.play("unpressed")
			emit_signal("unpressed")
