extends CanvasLayer

# Shared dialog box, autoloaded as DialogBox so any scene can show dialog

@onready var name_label = $DialogBoxTexture/NPCName
@onready var icon = $DialogBoxTexture/NPCIcon
@onready var text_label = $DialogBoxTexture/DialogText

var lines: Array[String] = []
var current_line: int = 0

func _ready() -> void:
	visible = false

func start(speaker_name: String, faceset: Texture2D, dialog_lines: Array[String]) -> void:
	if dialog_lines.is_empty():
		return
	lines = dialog_lines
	current_line = 0
	name_label.text = speaker_name
	icon.texture = faceset
	text_label.text = lines[current_line]
	visible = true

# Shows the next line, closing the dialog after the last one
func advance() -> void:
	current_line += 1
	if current_line < lines.size():
		text_label.text = lines[current_line]
	else:
		close()

func close() -> void:
	visible = false

func is_open() -> bool:
	return visible
