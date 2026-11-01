extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var hp: int = 10
@export var push_strength: float = 500

@onready var sprite = $AnimatedSprite2D
@onready var interact_area = $Area2D

var interact_target: Node2D = null

func _ready() -> void:
	if SceneManager.player_spawn_position != Vector2(0,0):
		position = SceneManager.player_spawn_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_target:
		interact_target.interact()


func _physics_process(delta) -> void:

	if is_in_dialog():
		velocity = Vector2.ZERO
		sprite.stop()
	else:
		move_player()
	
	push_blocks()
	
	move_and_slide()

func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * move_speed
	
	if velocity.x > 0:
		sprite.play("walk_right")
		interact_area.position = Vector2(11, 1)
	elif velocity.x < 0:
		sprite.play("walk_left")
		interact_area.position = Vector2(-11, 1)
	elif velocity.y > 0:
		sprite.play("walk_down")
		interact_area.position = Vector2(0, 12)
	elif velocity.y < 0:
		sprite.play("walk_up")
		interact_area.position = Vector2(0, -12)
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


func is_in_dialog() -> bool:
	return DialogBox.is_open()


func _on_interact_area_body_entered(body: Node2D) -> void:
	# Only one thing can be interacted with at a time, so the latest one wins
	if body.is_in_group("interactable"):
		interact_target = body


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		if body is NPC:
			body.close_dialog()
		if body == interact_target:
			interact_target = null
			# Fall back to anything else still in range
			for other in interact_area.get_overlapping_bodies():
				if other != body and other.is_in_group("interactable"):
					interact_target = other
					break
