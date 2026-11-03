extends Node2D

# Where the player appears in the next scene, or null to use where the scene places them
var player_spawn_position = null

# Game state that has to survive scene changes

# The player's health between scenes, -1 means start at full health
var player_hp: int = -1

# Things that have happened, like a single use button being pressed
var flags: Dictionary = {}

func set_flag(flag: String) -> void:
	flags[flag] = true


func has_flag(flag: String) -> bool:
	return flags.has(flag)


# Builds a flag name for a node that stays the same every time its scene loads
func node_flag(node: Node, flag: String) -> String:
	var scene_root = node.owner if node.owner else node
	return "%s:%s:%s" % [scene_root.scene_file_path, scene_root.get_path_to(node), flag]
