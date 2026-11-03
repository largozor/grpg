extends Area2D

@export var next_scene: String
# Leave this off to spawn wherever the player is placed in the next scene
@export var use_spawn_position: bool = false
@export var player_spawn_position: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if use_spawn_position:
			SceneManager.player_spawn_position = player_spawn_position
		else:
			SceneManager.player_spawn_position = null
		get_tree().change_scene_to_file.call_deferred(next_scene)
