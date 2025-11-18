extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var hp: int = 10

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	position = SceneManager.player_spawn_position
	pass


func _process(delta) -> void:
	
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * move_speed
	
	if velocity.x > 0:
		sprite.play("walk_right")
	elif velocity.x < 0:
		sprite.play("walk_left")
	elif velocity.y > 0:
		sprite.play("walk_down")
	elif velocity.y < 0:
		sprite.play("walk_up")
	if velocity == Vector2(0,0):
		sprite.stop()
	
	move_and_slide()
