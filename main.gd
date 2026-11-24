extends Node2D

const LEVEL_SCENE := preload("res://Levels/level.tscn")


func _on_play_pressed() -> void:
	$Menu.hide()
	$Main2D.add_child(LEVEL_SCENE.instantiate())


func _on_quit_pressed() -> void:
	get_tree().quit()
