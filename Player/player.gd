class_name DropPlayer
extends CharacterBody2D

const SPEED := 200.0

var left_edge := -INF
var right_edge := INF


func _physics_process(_delta: float) -> void:
	velocity.x = Input.get_axis("move_left", "move_right") * SPEED
	move_and_slide()
	clamp_to_box()


func set_drop_bounds(left: float, right: float) -> void:
	left_edge = left
	right_edge = right
	clamp_to_box()


func clamp_to_box() -> void:
	global_position.x = clampf(global_position.x, left_edge, right_edge)
