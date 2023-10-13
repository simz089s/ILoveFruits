extends Node2D


var fruit_scene := preload("res://fruit.tscn")

var player: CharacterBody2D
var current_fruit: Sprite2D
#var next_fruit: RigidBody2D
var fruits: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	player = self.get_node("Player")
	current_fruit = self.get_node("Fruit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	current_fruit.position = Vector2(player.position.x - 25, player.position.y + 25)


func _physics_process(_delta):
	pass


func _input(event):
	if event.is_action_released("release_fruit"):
		drop_fruit()


func drop_fruit():
	gen_fruit()


func gen_fruit():
	var fruit := fruit_scene.instantiate()
	add_child(fruit)
	fruit.global_transform.origin = Vector2(player.position.x - 25, player.position.y + 25)
