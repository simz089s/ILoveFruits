extends Node2D


@onready var hud: Control = $HUD
@onready var menu: Control = $Menu
@onready var main_2d: Node2D = $Main2D
@onready var camera: Camera2D = $Main2D/Camera

var level_instance: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_pressed():
	#load("res://Levels/level.tscn")
	get_tree().change_scene_to_file("res://Levels/level.tscn")


func _on_quit_pressed():
	unload_level()
	get_tree().quit()


func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null


func load_level():
	unload_level()
	var level_path := "res://Levels/level.tscn"
	var level_resource := load(level_path)
	if (level_resource):
		level_instance = level_resource.instantiate()
		main_2d.add_child(level_instance)

