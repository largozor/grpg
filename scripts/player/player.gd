extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var hp: int = 10
@export var push_strength: float = 500

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position
	


func _physics_process(delta) -> void:
	
	move_player()
	
	push_blocks()
	
	move_and_slide()

func move_player():
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

func push_blocks():
		# Get the last collision, and push the block
	var collision: KinematicCollision2D = get_last_slide_collision()
	
	if collision:
		var collider_node = collision.get_collider()
		
		if collider_node.is_in_group("pushable"):
			var collision_normal: Vector2 = collision.get_normal()
			collider_node.apply_central_force(-collision_normal * push_strength)
