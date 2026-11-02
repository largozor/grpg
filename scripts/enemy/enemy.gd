extends CharacterBody2D

class_name Enemy

@export var move_speed: float = 30
@export var hp: int = 3
@export var contact_damage: int = 1
@export var knockback_strength: float = 150
@export var knockback_decay: float = 600

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var hit_sound = $HitSound

var target: Player = null
var knockback: Vector2 = Vector2.ZERO

func _physics_process(delta) -> void:
	if target:
		velocity = global_position.direction_to(target.global_position) * move_speed
	else:
		velocity = Vector2.ZERO

	velocity += knockback
	knockback = knockback.move_toward(Vector2.ZERO, knockback_decay * delta)

	move_and_slide()

	damage_touching_player()

func damage_touching_player():
	# The player's invincibility frames stop this from hitting every frame
	for body in hurtbox.get_overlapping_bodies():
		if body is Player:
			body.take_damage(contact_damage, global_position)


func take_damage(amount: int, from_position: Vector2):
	if hp <= 0:
		return

	hp -= amount
	hit_sound.play()
	knockback = from_position.direction_to(global_position) * knockback_strength

	if hp <= 0:
		die()
	else:
		sprite.modulate = Color(1, 0.4, 0.4)
		create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.2)

func die():
	# Stop moving and hurting the player, then fade out
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)
	hurtbox.set_deferred("monitoring", false)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	await tween.finished
	if hit_sound.playing:
		await hit_sound.finished
	queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
