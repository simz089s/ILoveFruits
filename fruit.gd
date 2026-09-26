extends RigidBody2D

enum FruitType {
	PEACH,
	APPLE,
	MOMO,
	PINK,
	YELLOW,
	MELON,
}

signal collided_for_first_time(fruit)
signal request_merge(fruit_1, fruit_2)

var collided_once := false
var fruit_type: FruitType

func _ready():
	pass

func _process(_delta):
	pass

func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if not collided_once:
		collided_once = true
		collided_for_first_time.emit(self)
	
	if is_instance_of(body, RigidBody2D) and self.fruit_type == body.fruit_type and self.fruit_type != FruitType.MELON:
		# Check instance ID here to prevent the second fruit from also requesting a merge
		if self.get_instance_id() < body.get_instance_id():
			request_merge.emit(self, body)
