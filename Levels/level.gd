extends Node2D

var fruit_scene := preload("res://fruit.tscn")

# Store your custom textures directly in the dictionary
var FRUIT_DATA = {
	0: {"tex": preload("res://Arts/peach.png"), "sprite_scale": 0.10, "phys_scale": 1.0, "mass": 1.0}, # PEACH
	1: {"tex": preload("res://Arts/apple.png"), "sprite_scale": 0.15, "phys_scale": 1.5, "mass": 1.5}, # APPLE
	2: {"tex": preload("res://Arts/momo.png"), "sprite_scale": 0.20, "phys_scale": 2.0, "mass": 2.0},  # MOMO
	3: {"tex": preload("res://Arts/pink.png"), "sprite_scale": 0.25, "phys_scale": 2.5, "mass": 2.5},  # PINK
	4: {"tex": preload("res://Arts/yellow.png"), "sprite_scale": 0.30, "phys_scale": 3.0, "mass": 3.0},# YELLOW
	5: {"tex": preload("res://Arts/watermelon.png"), "sprite_scale": 0.35, "phys_scale": 3.5, "mass": 3.5} # MELON
}

var placeholder_fruit: RigidBody2D
var player: CharacterBody2D
var current_fruit: Sprite2D
var last_fruit: RigidBody2D
var next_fruit: RigidBody2D
var fruits: Array
var score: Label
var score_counter := 0
var next_fruit_panel: TextureRect

func _ready():
	randomize()
	$FruitContainer/StaticBody2D.game_over_reached.connect(game_over)
	
	score = self.get_node("Score")
	score.text = "%d" % score_counter
	player = self.get_node("Player")
	current_fruit = self.get_node("Fruit")
	next_fruit_panel = self.get_node("Panel/NextFruit")
	
	next_fruit = fruit_scene.instantiate()
	placeholder_fruit = fruit_scene.instantiate()
	
	# Roll the initial fruits
	roll_next_fruit()
	
	placeholder_fruit.fruit_type = randi_range(0, 3)
	apply_fruit_visuals(current_fruit, placeholder_fruit.fruit_type)
	
	placeholder_fruit.collided_once = true
	last_fruit = placeholder_fruit

func _process(_delta):
	current_fruit.position = Vector2(player.position.x, player.position.y + 25)

func _input(event):
	if event.is_action_released("release_fruit") and last_fruit.collided_once:
		current_fruit.hide()
		drop_fruit()

func drop_fruit():
	gen_new_fruit(placeholder_fruit.fruit_type)
	placeholder_fruit.fruit_type = next_fruit.fruit_type
	apply_fruit_visuals(current_fruit, placeholder_fruit.fruit_type)

func gen_new_fruit(fruit_type):
	var fruit := fruit_scene.instantiate()
	fruit.fruit_type = fruit_type
	
	var data = FRUIT_DATA[fruit_type]
	var sprite = fruit.get_node("Sprite2D")
	var collision = fruit.get_node("CollisionShape2D")
	
	# Apply visuals and physics from dictionary
	sprite.texture = data.tex
	sprite.scale = Vector2(data.sprite_scale, data.sprite_scale)
	collision.scale = Vector2(data.phys_scale, data.phys_scale)
	fruit.mass = data.mass
			
	fruit.collided_for_first_time.connect(fruit_collided_once)
	fruit.request_merge.connect(merge_fruits)
	
	add_child(fruit)
	fruit.global_position = Vector2(player.position.x, player.position.y + 25)
	fruits.append(fruit)
	last_fruit = fruit

func gen_bigger_fruit_than(fruit_1, fruit_2):
	var new_fruit := fruit_scene.instantiate()
	
	# Upgrade the fruit type by adding 1
	var next_type_int = fruit_1.fruit_type + 1
	new_fruit.fruit_type = next_type_int
	
	var data = FRUIT_DATA[next_type_int]
	var sprite = new_fruit.get_node("Sprite2D")
	var collision = new_fruit.get_node("CollisionShape2D")
	
	# Apply visuals and physics from dictionary
	sprite.texture = data.tex
	sprite.scale = Vector2(data.sprite_scale, data.sprite_scale)
	collision.scale = Vector2(data.phys_scale, data.phys_scale)
	new_fruit.mass = data.mass
			
	new_fruit.global_position = fruit_1.position.lerp(fruit_2.position, 0.5)
	
	new_fruit.collided_for_first_time.connect(fruit_collided_once)
	new_fruit.request_merge.connect(merge_fruits)
	
	fruits.append(new_fruit)
	last_fruit = placeholder_fruit
	
	fruit_1.queue_free()
	fruit_2.queue_free()
	self.call_deferred("add_child", new_fruit)

func merge_fruits(fruit_1, fruit_2):
	score_counter += 1
	score.text = "%d" % score_counter
	gen_bigger_fruit_than(fruit_1, fruit_2)

func fruit_collided_once(_fruit):
	current_fruit.show()
	roll_next_fruit()

# --- Helper Functions ---

func roll_next_fruit():
	# Randomize next fruit between PEACH (0) and PINK (3)
	next_fruit.fruit_type = randi_range(0, 3) 
	next_fruit_panel.texture = FRUIT_DATA[next_fruit.fruit_type].tex

func apply_fruit_visuals(sprite_node: Sprite2D, f_type: int):
	sprite_node.texture = FRUIT_DATA[f_type].tex
	sprite_node.scale = Vector2(FRUIT_DATA[f_type].sprite_scale, FRUIT_DATA[f_type].sprite_scale)

func game_over():
	print("GAME OVER")
