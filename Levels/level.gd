extends Node2D


var fruit_scene := preload("res://fruit.tscn")
var fruit_tex_peach := preload("res://Arts/peach.png")
var fruit_tex_apple := preload("res://Arts/apple.png")
var fruit_tex_momo := preload("res://Arts/momo.png")
var fruit_tex_pink := preload("res://Arts/pink.png")
var fruit_tex_yellow := preload("res://Arts/yellow.png")
var fruit_tex_melon := preload("res://Arts/watermelon.png")

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
	placeholder_fruit.fruit_type = placeholder_fruit.FruitType.values()[randi_range(0, placeholder_fruit.FruitType.size() - 3)]
	match placeholder_fruit.fruit_type:
		placeholder_fruit.FruitType.PEACH:
			current_fruit.set_texture(fruit_tex_peach)
			current_fruit.scale = Vector2(0.1, 0.1)
		placeholder_fruit.FruitType.APPLE:
			current_fruit.set_texture(fruit_tex_apple)
			current_fruit.scale = Vector2(0.15, 0.15)
		placeholder_fruit.FruitType.MOMO:
			current_fruit.set_texture(fruit_tex_momo)
			current_fruit.scale = Vector2(0.2, 0.2)
		placeholder_fruit.FruitType.PINK:
			current_fruit.set_texture(fruit_tex_pink)
			current_fruit.scale = Vector2(0.25, 0.25)
#		placeholder_fruit.FruitType.YELLOW:
#			current_fruit.set_texture(fruit_tex_yellow)
#			current_fruit.scale = Vector2(0.3, 0.3)
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
	placeholder_fruit.fruit_type = placeholder_fruit.FruitType.values()[randi_range(0, placeholder_fruit.FruitType.size() - 3)]
	match placeholder_fruit.fruit_type:
		placeholder_fruit.FruitType.PEACH:
			current_fruit.set_texture(fruit_tex_peach)
			current_fruit.scale = Vector2(0.1, 0.1)
		placeholder_fruit.FruitType.APPLE:
			current_fruit.set_texture(fruit_tex_apple)
			current_fruit.scale = Vector2(0.15, 0.15)
		placeholder_fruit.FruitType.MOMO:
			current_fruit.set_texture(fruit_tex_momo)
			current_fruit.scale = Vector2(0.2, 0.2)
		placeholder_fruit.FruitType.PINK:
			current_fruit.set_texture(fruit_tex_pink)
			current_fruit.scale = Vector2(0.25, 0.25)
#		placeholder_fruit.FruitType.YELLOW:
#			current_fruit.set_texture(fruit_tex_yellow)
#			current_fruit.scale = Vector2(0.3, 0.3)
#		placeholder_fruit.FruitType.MELON:
#			current_fruit.set_texture(fruit_tex_melon)
#			current_fruit.scale = Vector2(0.35, 0.35)


func gen_new_fruit(fruit_type):
	var fruit := fruit_scene.instantiate()
	fruit.fruit_type = fruit_type
	match fruit.fruit_type:
		fruit.FruitType.PEACH:
			fruit.get_child(0).set_texture(fruit_tex_peach)
			fruit.get_child(0).scale = Vector2(0.1, 0.1)
			fruit.get_child(1).scale = Vector2(1, 1)
			fruit.mass = 1
		fruit.FruitType.APPLE:
			fruit.get_child(0).set_texture(fruit_tex_apple)
			fruit.get_child(0).scale = Vector2(0.15, 0.15)
			fruit.get_child(1).scale = Vector2(1.5, 1.5)
			fruit.mass = 1.5
		fruit.FruitType.MOMO:
			fruit.get_child(0).set_texture(fruit_tex_momo)
			fruit.get_child(0).scale = Vector2(0.2, 0.2)
			fruit.get_child(1).scale = Vector2(2, 2)
			fruit.mass = 2
		fruit.FruitType.PINK:
			fruit.get_child(0).set_texture(fruit_tex_pink)
			fruit.get_child(0).scale = Vector2(0.25, 0.25)
			fruit.get_child(1).scale = Vector2(2.5, 2.5)
			fruit.mass = 2.5
#		fruit.FruitType.YELLOW:
#			fruit.get_child(0).set_texture(fruit_tex_yellow)
#			fruit.get_child(0).scale = Vector2(0.3, 0.3)
#			fruit.get_child(1).scale = Vector2(3, 3)
#		fruit.FruitType.MELON:
#			fruit.get_child(0).set_texture(fruit_tex_melon)
#			fruit.get_child(0).scale = Vector2(0.35, 0.35)
#			fruit.get_child(1).scale = Vector2(3.5, 3.5)
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
			new_fruit.get_child(0).scale = Vector2(0.15, 0.15)
			new_fruit.get_child(1).scale = Vector2(1.5, 1.5)
			new_fruit.mass = 1
		new_fruit.FruitType.APPLE:
			new_fruit.fruit_type = new_fruit.FruitType.MOMO
			new_fruit.get_child(0).set_texture(fruit_tex_momo)
			new_fruit.get_child(0).scale = Vector2(0.2, 0.2)
			new_fruit.get_child(1).scale = Vector2(2, 2)
			new_fruit.mass = 1.5
		new_fruit.FruitType.MOMO:
			new_fruit.fruit_type = new_fruit.FruitType.PINK
			new_fruit.get_child(0).set_texture(fruit_tex_pink)
			new_fruit.get_child(0).scale = Vector2(0.25, 0.25)
			new_fruit.get_child(1).scale = Vector2(2.5, 2.5)
			new_fruit.mass = 2
		new_fruit.FruitType.PINK:
			new_fruit.fruit_type = new_fruit.FruitType.YELLOW
			new_fruit.get_child(0).set_texture(fruit_tex_yellow)
			new_fruit.get_child(0).scale = Vector2(0.3, 0.3)
			new_fruit.get_child(1).scale = Vector2(3, 3)
			new_fruit.mass = 2.5
		new_fruit.FruitType.YELLOW:
			new_fruit.fruit_type = new_fruit.FruitType.MELON
			new_fruit.get_child(0).set_texture(fruit_tex_melon)
			new_fruit.get_child(0).scale = Vector2(0.35, 0.35)
			new_fruit.get_child(1).scale = Vector2(3.5, 3.5)
			new_fruit.mass = 3
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
