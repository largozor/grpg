extends StaticBody2D

class_name NPC

@export var npc_name: String = "NPC"
@export var faceset: Texture2D
@export var dialog_lines: Array[String] = []

func interact():
	if DialogBox.is_open():
		DialogBox.advance()
	else:
		DialogBox.start(npc_name, faceset, dialog_lines)

func close_dialog():
	DialogBox.close()
