extends StaticBody2D

signal game_over_reached

var timer: Timer
var line: ColorRect
var touching := false
var faded := false
var _visible := false
var time := 0
var sin_time := 0.

func _ready():
	timer = self.get_node("Area2D/Timer")
	line = self.get_node("Area2D/ColorRect")

func _on_area_2d_body_entered(_body):
	touching = true
	faded = true
	timer.start(3)

func _on_area_2d_body_exited(_body):
	touching = false
	timer.stop()

func _on_timer_timeout():
	touching = false
	game_over_reached.emit()

func flash():
	if not faded:
		if sin_time > 0:
			_visible = true
		else:
			_visible = false
	else:
		_visible = true
		line.self_modulate.a = sin_time
	visible = _visible
