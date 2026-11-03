extends RigidBody2D

class_name Block

# Remembers where the block started so a puzzle reset switch can put it back

var start_position: Vector2
var is_resetting: bool = false

func _ready() -> void:
	start_position = global_position


func reset():
	is_resetting = true
	# A sleeping body skips _integrate_forces, so wake it up
	sleeping = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Teleporting a rigid body has to go through the physics state
	if is_resetting:
		state.transform = Transform2D(0, start_position)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		is_resetting = false
