extends Node2D

const FRUIT_SCENE := preload("res://fruit.tscn")
const FRUIT_DATA := {
	Fruit.FruitType.PEACH: {"texture": preload("res://Arts/peach.png"), "scale": 0.10, "radius": 16.0, "mass": 1.0},
	Fruit.FruitType.APPLE: {"texture": preload("res://Arts/apple.png"), "scale": 0.15, "radius": 24.0, "mass": 1.5},
	Fruit.FruitType.MOMO: {"texture": preload("res://Arts/momo.png"), "scale": 0.20, "radius": 32.0, "mass": 2.0},
	Fruit.FruitType.PINK: {"texture": preload("res://Arts/pink.png"), "scale": 0.25, "radius": 40.0, "mass": 2.5},
	Fruit.FruitType.YELLOW: {"texture": preload("res://Arts/yellow.png"), "scale": 0.30, "radius": 48.0, "mass": 3.0},
	Fruit.FruitType.MELON: {"texture": preload("res://Arts/watermelon.png"), "scale": 0.35, "radius": 56.0, "mass": 3.5},
}

var current_type: Fruit.FruitType
var next_type: Fruit.FruitType
var can_drop := true
var score := 0

@onready var player: DropPlayer = $Player
@onready var preview: Sprite2D = $Player/FruitPreview
@onready var next_preview: TextureRect = $Panel/NextFruit
@onready var score_label: Label = $Score
@onready var container: FruitContainer = $FruitContainer
@onready var fruits: Node2D = $Fruits


func _ready() -> void:
	container.game_over_reached.connect(game_over)
	score_label.text = str(score)
	current_type = roll_fruit_type()
	next_type = roll_fruit_type()
	update_previews()


func _physics_process(_delta: float) -> void:
	container.check_height(fruits)


func _unhandled_input(event: InputEvent) -> void:
	if can_drop and event.is_action_released("release_fruit"):
		drop_fruit()


func drop_fruit() -> void:
	can_drop = false
	var fruit := create_fruit(current_type, preview.global_position)
	fruit.first_contact.connect(unlock_drop, CONNECT_ONE_SHOT)

	current_type = next_type
	next_type = roll_fruit_type()
	preview.hide()


func unlock_drop() -> void:
	update_previews()
	preview.show()
	can_drop = true


func create_fruit(type: Fruit.FruitType, spawn_position: Vector2) -> Fruit:
	var fruit := FRUIT_SCENE.instantiate() as Fruit
	var data: Dictionary = FRUIT_DATA[type]
	var sprite: Sprite2D = fruit.get_node("Sprite2D")
	var collision: CollisionShape2D = fruit.get_node("CollisionShape2D")
	var shape := CircleShape2D.new()
	shape.radius = data.radius
	collision.shape = shape
	sprite.texture = data.texture
	sprite.scale = Vector2.ONE * data.scale
	fruit.mass = data.mass
	fruit.fruit_type = type
	fruit.position = fruits.to_local(spawn_position)
	fruit.merge_requested.connect(request_merge)
	fruits.add_child(fruit)
	return fruit


func request_merge(first: Fruit, second: Fruit) -> void:
	if first.merge_pending or second.merge_pending:
		return

	# Reserve both fruits now. Change the physics bodies after contact callbacks finish.
	first.merge_pending = true
	second.merge_pending = true
	finish_merge.call_deferred(first, second)


func finish_merge(first: Fruit, second: Fruit) -> void:
	if not can_process():
		return

	var bigger_type := (first.fruit_type + 1) as Fruit.FruitType
	var midpoint := first.global_position.lerp(second.global_position, 0.5)
	first.queue_free()
	second.queue_free()
	var bigger := create_fruit(bigger_type, midpoint)
	bigger.has_landed = true
	score += 1
	score_label.text = str(score)


func roll_fruit_type() -> Fruit.FruitType:
	return randi_range(Fruit.FruitType.PEACH, Fruit.FruitType.PINK) as Fruit.FruitType


func update_previews() -> void:
	var data: Dictionary = FRUIT_DATA[current_type]
	preview.texture = data.texture
	preview.scale = Vector2.ONE * data.scale
	next_preview.texture = FRUIT_DATA[next_type].texture

	# The ends of the limit line mark the inside edges of the box.
	var radius: float = data.radius
	var line := container.limit_line
	player.set_drop_bounds(line.global_position.x + radius,
		line.global_position.x + line.size.x - radius)


func game_over() -> void:
	preview.hide()
	$GameOver.show()
	process_mode = Node.PROCESS_MODE_DISABLED
