extends StaticBody2D

@onready var dialog_box = $CanvasLayer
@onready var ui_label = $CanvasLayer/TextureRect/Label

@onready var can_interact: bool = false

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if can_interact:
			if dialog_box.visible == true:
				dialog_box.visible = false
			else:
				dialog_box.visible = true

func close_dialog():
	dialog_box.visible = false
