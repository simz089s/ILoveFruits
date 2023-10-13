extends Node2D


var fruit_scene := preload("res://fruit.tscn")

var player: CharacterBody2D
var fruit: RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = self.get_node("Player")
	fruit = fruit_scene.instantiate()
	add_child(fruit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fruit.position = Vector2(player.position.x, player.position.y + 25)
	if Input.is_action_just_released("ui_accept"):
		# Drop current fruit
		fruit.gravity_scale = 1.
		
		# Generate new fruit
		fruit = fruit_scene.instantiate()
		add_child(fruit)
		fruit.position = Vector2(player.position.x, player.position.y + 25)
