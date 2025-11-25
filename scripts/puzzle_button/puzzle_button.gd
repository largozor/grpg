extends Area2D

@onready var sprite = $AnimatedSprite2D

var bodies_on_top: int = 0

func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 1:
			print ("I have been pushed onto the button")
			sprite.play("pressed")


func _on_body_exited(body: Node2D) -> void:
	bodies_on_top -= 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 0:
			print ("I have been pushed off the bottom")
			sprite.play("unpressed")
