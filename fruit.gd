extends RigidBody2D


#const SPEED = 100.0
#const FALL_VELOCITY = -400.0

enum FruitType {
	PEACH,
	APPLE,
	MOMO,
	PINK,
	YELLOW,
	MELON,
}

var level: Node2D

var collided_once := false
var fruit_type: FruitType

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	pass
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle Drop.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = FALL_VELOCITY


func _on_body_entered(body):
	if not collided_once:
		collided_once = true
		level.fruit_collided_once(self)
	
	if is_instance_of(body, RigidBody2D) and self.fruit_type == body.fruit_type and self.fruit_type != FruitType.MELON:
		level.merge_fruits(self, body) # This will happen twice though...
