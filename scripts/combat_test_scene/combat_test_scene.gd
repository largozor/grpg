extends Node2D

# Sandbox arena for trying out combat. Run it with F6, press R to restart

@onready var status_label = $HUD/StatusLabel

func _process(delta):
	var slimes_left = get_tree().get_nodes_in_group("enemies").size()
	status_label.text = "Slimes left: %d\nMove: WASD/Arrows   Attack: Z/J   Talk: X/Space   Restart: R" % slimes_left

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_R:
		SceneManager.player_hp = -1
		get_tree().reload_current_scene()
