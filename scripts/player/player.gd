extends CharacterBody2D

class_name Player

signal health_changed(hp: int, max_hp: int)
signal died

@export var move_speed: float = 100
@export var max_hp: int = 10
@export var push_strength: float = 500
@export var attack_damage: int = 1
@export var attack_duration: float = 0.25
@export var invincibility_time: float = 1.0
@export var knockback_strength: float = 200
@export var knockback_decay: float = 1000

@onready var sprite = $AnimatedSprite2D
@onready var interact_area = $Area2D
@onready var sword_sprite = $SwordSprite
@onready var sword_hitbox = $SwordHitbox
@onready var sword_sound = $SwordSound
@onready var hurt_sound = $HurtSound

var interact_target: Node2D = null
var facing: Vector2 = Vector2.DOWN
var is_attacking: bool = false
var is_invincible: bool = false
var knockback: Vector2 = Vector2.ZERO
var hp: int

func _ready() -> void:
	if SceneManager.player_spawn_position != null:
		position = SceneManager.player_spawn_position

	# Carry health over from the last scene
	hp = max_hp if SceneManager.player_hp < 0 else mini(SceneManager.player_hp, max_hp)
	health_changed.emit(hp, max_hp)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_target:
		interact_target.interact()
	elif event.is_action_pressed("attack") and not is_attacking and not is_in_dialog():
		attack()


func _physics_process(delta) -> void:

	if is_in_dialog():
		velocity = Vector2.ZERO
		sprite.stop()
	elif is_attacking:
		velocity = Vector2.ZERO
	else:
		move_player()

	velocity += knockback
	knockback = knockback.move_toward(Vector2.ZERO, knockback_decay * delta)

	push_blocks()

	move_and_slide()

func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = move_vector * move_speed

	if velocity.x > 0:
		facing = Vector2.RIGHT
	elif velocity.x < 0:
		facing = Vector2.LEFT
	elif velocity.y > 0:
		facing = Vector2.DOWN
	elif velocity.y < 0:
		facing = Vector2.UP

	if velocity == Vector2(0,0):
		sprite.stop()
	else:
		sprite.play("walk_" + facing_name())

	interact_area.position = facing_offset()
	sword_hitbox.position = facing_offset()

func facing_name() -> String:
	match facing:
		Vector2.RIGHT:
			return "right"
		Vector2.LEFT:
			return "left"
		Vector2.UP:
			return "up"
	return "down"

# Where the interact area and sword hitbox sit relative to the player
func facing_offset() -> Vector2:
	match facing:
		Vector2.RIGHT:
			return Vector2(11, 1)
		Vector2.LEFT:
			return Vector2(-11, 1)
		Vector2.UP:
			return Vector2(0, -12)
	return Vector2(0, 12)

func push_blocks():
	# Get the last collision, and push the block
	var collision: KinematicCollision2D = get_last_slide_collision()

	if collision:
		var collider_node = collision.get_collider()

		if collider_node.is_in_group("pushable"):
			var collision_normal: Vector2 = collision.get_normal()
			collider_node.apply_central_force(-collision_normal * push_strength)


func attack():
	is_attacking = true
	sprite.play("attack_" + facing_name())
	sword_sound.play()

	# The sword sprite points down, so rotate it to face the attack direction
	sword_sprite.position = facing * 10
	sword_sprite.rotation = facing.angle() - PI / 2
	sword_sprite.visible = true

	for body in sword_hitbox.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.take_damage(attack_damage, global_position)

	await get_tree().create_timer(attack_duration).timeout
	sword_sprite.visible = false
	sprite.animation = "walk_" + facing_name()
	is_attacking = false


func take_damage(amount: int, from_position: Vector2):
	if is_invincible or hp <= 0:
		return

	hp -= amount
	SceneManager.player_hp = hp
	health_changed.emit(hp, max_hp)
	hurt_sound.play()
	knockback = from_position.direction_to(global_position) * knockback_strength

	if hp <= 0:
		die()
	else:
		start_invincibility()

func start_invincibility():
	is_invincible = true
	# Flash the sprite while invincible
	var tween = create_tween().set_loops(5)
	tween.tween_property(sprite, "modulate:a", 0.3, invincibility_time / 10)
	tween.tween_property(sprite, "modulate:a", 1.0, invincibility_time / 10)
	await tween.finished
	is_invincible = false

func die():
	died.emit()
	set_physics_process(false)
	set_process_unhandled_input(false)
	sword_sprite.visible = false
	sprite.stop()
	sprite.modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(1.0).timeout
	# Come back at full health
	SceneManager.player_hp = -1
	get_tree().reload_current_scene()


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
