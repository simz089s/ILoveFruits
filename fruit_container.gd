class_name FruitContainer
extends Node2D

signal game_over_reached

@onready var limit_line: ColorRect = $LimitLine
@onready var overflow_timer: Timer = $OverflowTimer


func check_height(fruits: Node2D) -> void:
	var limit_y := limit_line.global_position.y + limit_line.size.y / 2.0
	for child in fruits.get_children():
		var fruit := child as Fruit
		if not fruit.has_landed or fruit.merge_pending:
			continue
		var fruit_top := fruit.global_position.y - fruit.circle.radius
		if fruit_top <= limit_y:
			if overflow_timer.is_stopped():
				overflow_timer.start()
			return

	overflow_timer.stop()


func _on_overflow_timer_timeout() -> void:
	game_over_reached.emit()
