extends StaticBody2D

class_name NPC

@onready var dialog_box = $CanvasLayer
@onready var ui_label = $CanvasLayer/DialogBoxTexture/DialogText

func interact():
	dialog_box.visible = not dialog_box.visible

func is_dialog_open() -> bool:
	return dialog_box.visible

func close_dialog():
	dialog_box.visible = false
