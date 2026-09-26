extends Node2D

@onready var hud: Control = $HUD
@onready var menu: Control = $Menu
@onready var main_2d: Node2D = $Main2D
@onready var camera: Camera2D = $Main2D/Camera

var level_instance: Node2D

func _ready():
	pass

func _process(_delta):
	pass

func _on_play_pressed():
	menu.hide()
	load_level()

func _on_quit_pressed():
	get_tree().quit()

func unload_level():
	if is_instance_valid(level_instance):
		level_instance.queue_free()
	level_instance = null

func load_level():
	unload_level()
	var level_path := "res://Levels/level.tscn"
	var level_resource := load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		main_2d.add_child(level_instance)
