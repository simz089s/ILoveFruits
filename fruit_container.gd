extends StaticBody2D


var timer: Timer
var line: ColorRect
var touching := false
var faded := false
var _visible := false
var time := 0
var sin_time := 0.


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = self.get_node("Area2D/Timer")
	line = self.get_node("Area2D/ColorRect")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	time += delta
#	sin_time = sin(time * 5)
#	flash()


func _on_area_2d_body_entered(_body):
	touching = true
	faded = true
	timer.start(3)


func _on_area_2d_body_exited(_body):
	touching = false
	timer.stop()


func _on_timer_timeout():
	touching = false
	get_parent().get_parent().game_over()


func flash():
	if not faded:
		if sin_time > 0:
			_visible = true
		else:
			_visible = false
	else:
		_visible = true
		line.self_modulate.a = sin_time
#			self_modulate = Color(1, 0.5, 0, 0)
	visible = _visible
