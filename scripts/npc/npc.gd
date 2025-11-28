extends StaticBody2D

@onready var dialog_box = $CanvasLayer
@onready var ui_label = $CanvasLayer/TextureRect/Label

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		#print("Hello there!")
		if dialog_box.visible == true:
			dialog_box.visible = false;
		else:
			dialog_box.visible = true
