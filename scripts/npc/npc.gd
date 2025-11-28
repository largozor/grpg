extends StaticBody2D

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		print("Hello there!")
