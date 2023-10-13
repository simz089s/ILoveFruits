extends Node2D


var fruit_tex_peach := preload("res://Arts/peach.png")
var fruit_tex_apple := preload("res://Arts/apple.png")
var fruit_tex_melon := preload("res://Arts/watermelon.png")
var fruit_scene := preload("res://fruit.tscn")

var placeholder_fruit: RigidBody2D

var player: CharacterBody2D
var current_fruit: Sprite2D
var last_fruit: RigidBody2D
var next_fruit: RigidBody2D
var fruits: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player = self.get_node("Player")
	current_fruit = self.get_node("Fruit")
	placeholder_fruit = fruit_scene.instantiate()
	placeholder_fruit.fruit_type = placeholder_fruit.FruitType.values()[randi_range(0, placeholder_fruit.FruitType.size() - 2)]
	match placeholder_fruit.fruit_type:
		placeholder_fruit.FruitType.PEACH:
			current_fruit.set_texture(fruit_tex_peach)
		placeholder_fruit.FruitType.APPLE:
			current_fruit.set_texture(fruit_tex_apple)
		placeholder_fruit.FruitType.MELON:
			current_fruit.set_texture(fruit_tex_melon)
	placeholder_fruit.collided_once = true
	last_fruit = placeholder_fruit


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	current_fruit.position = Vector2(player.position.x, player.position.y + 25)


func _physics_process(_delta):
	pass


func _input(event):
	if event.is_action_released("release_fruit") and last_fruit.collided_once:
		current_fruit.hide()
		drop_fruit()


func drop_fruit():
	gen_new_fruit(placeholder_fruit.fruit_type)
	placeholder_fruit.fruit_type = placeholder_fruit.FruitType.values()[randi_range(0, placeholder_fruit.FruitType.size() - 2)]
	match placeholder_fruit.fruit_type:
		placeholder_fruit.FruitType.PEACH:
			current_fruit.set_texture(fruit_tex_peach)
		placeholder_fruit.FruitType.APPLE:
			current_fruit.set_texture(fruit_tex_apple)
		placeholder_fruit.FruitType.MELON:
			current_fruit.set_texture(fruit_tex_melon)


func gen_new_fruit(fruit_type):
	var fruit := fruit_scene.instantiate()
	fruit.fruit_type = fruit_type
	match fruit.fruit_type:
		fruit.FruitType.PEACH:
			fruit.get_child(0).set_texture(fruit_tex_peach)
		fruit.FruitType.APPLE:
			fruit.get_child(0).set_texture(fruit_tex_apple)
		fruit.FruitType.MELON:
			fruit.get_child(0).set_texture(fruit_tex_melon)
	add_child(fruit)
	fruit.global_transform.origin = Vector2(player.position.x, player.position.y + 25)
	fruits.append(fruit)
	last_fruit = fruit


func gen_bigger_fruit_than(fruit_1, fruit_2):
	var new_fruit := fruit_scene.instantiate()
	match fruit_1.fruit_type:
		new_fruit.FruitType.PEACH:
			new_fruit.fruit_type = new_fruit.FruitType.APPLE
			new_fruit.get_child(0).set_texture(fruit_tex_apple)
		new_fruit.FruitType.APPLE:
			new_fruit.fruit_type = new_fruit.FruitType.MELON
			new_fruit.get_child(0).set_texture(fruit_tex_melon)
	new_fruit.global_transform.origin = fruit_1.position.lerp(fruit_2.position, 0.5)
	fruits.append(new_fruit)
	last_fruit = placeholder_fruit
	fruit_1.queue_free()
	fruit_2.queue_free()
	self.call_deferred("add_child", new_fruit)


func merge_fruits(fruit_1, fruit_2):
	# This will get called twice by each fruit on collision 🤔
	if fruit_1.get_instance_id() < fruit_2.get_instance_id():
		gen_bigger_fruit_than(fruit_1, fruit_2)


func fruit_collided(_fruit):
	current_fruit.show()
