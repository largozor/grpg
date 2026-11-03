extends Area2D

@onready var sprite = $AnimatedSprite2D

@export var is_single_use: bool

var bodies_on_top: int = 0
var has_been_pressed: bool = false

signal pressed
signal unpressed

func _ready() -> void:
	# Single use buttons stay pressed after leaving the scene and coming back
	if is_single_use and SceneManager.has_flag(pressed_flag()):
		has_been_pressed = true
		sprite.play("pressed")
		# Wait until the door is ready before telling it
		call_deferred("emit_signal", "pressed")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("pushable") or body is Player:
		bodies_on_top += 1
		# A single use button stays pressed, so it only tells the door once
		if bodies_on_top == 1 and not (is_single_use and has_been_pressed):
			has_been_pressed = true
			if is_single_use:
				SceneManager.set_flag(pressed_flag())
			sprite.play("pressed")
			emit_signal("pressed")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("pushable") or body is Player:
		bodies_on_top -= 1
		if bodies_on_top == 0 and not is_single_use:
			sprite.play("unpressed")
			emit_signal("unpressed")


func pressed_flag() -> String:
	return SceneManager.node_flag(self, "pressed")
