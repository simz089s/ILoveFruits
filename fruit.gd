class_name Fruit
extends RigidBody2D

enum FruitType { PEACH, APPLE, MOMO, PINK, YELLOW, MELON }

signal first_contact
signal merge_requested(first: Fruit, second: Fruit)

var fruit_type: FruitType = FruitType.PEACH
var has_landed := false
var merge_pending := false

@onready var circle: CircleShape2D = $CollisionShape2D.shape


func _on_body_entered(body: Node) -> void:
	if not has_landed:
		has_landed = true
		first_contact.emit()

	var other := body as Fruit
	if other == null or fruit_type == FruitType.MELON:
		return
	if fruit_type == other.fruit_type:
		merge_requested.emit(self, other)
