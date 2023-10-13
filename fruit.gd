extends RigidBody2D


const SPEED = 100.0
const FALL_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("ui_accept"):
		gravity_scale = 1.


func _physics_process(delta):
	pass
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle Drop.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = FALL_VELOCITY
