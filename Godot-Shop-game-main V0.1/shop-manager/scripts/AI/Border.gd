extends Node2D

@export var is_spawner: bool
@export var border_option: String
@export var rect_top_right: Node
@export var rect_bottom_left: Node
@export var entity_to_spawn: PackedScene
var entities: Array
@export var parent_node: Node
@export var max_entities: int
@export var timer: Timer
var ready_to_spawn: bool = true

@export var circ_center: Node
@export var radius: int
@export var min_spawn_rate: float = 5
@export var max_spawn_rate: float = 10

func _ready() -> void:
	entities.resize(max_entities)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_spawner:
		if check_if_array_has_empty_space(entities):
			if(ready_to_spawn):
				spawn_entity()
				ready_to_spawn = false
				_start_timer(min_spawn_rate,max_spawn_rate)
	if timer.time_left <= 0:
		ready_to_spawn = true
	
func spawn_entity():
	var new_entity = entity_to_spawn.instantiate()
	entities[get_next_empty_space_in_array(entities)] = new_entity
	parent_node.add_child(new_entity)
	new_entity.position = get_random_point()
	new_entity.border = self

func get_next_empty_space_in_array(array: Array) -> int:
	var count: int = 0
	for i in array:
		if !i:
			return count
		count += 1
	return -1

func check_if_array_has_empty_space(array: Array) -> bool:
	var empty: bool = false
	for i in array:
		if !i:
			empty = true
	return empty

func get_random_point() -> Vector2:
	var random_position: Vector2
	if border_option == "rect":
		random_position = Vector2i(randf_range(rect_bottom_left.position.x,rect_top_right.position.x),randf_range(rect_bottom_left.position.y,rect_top_right.position.y))
	return random_position

func _start_timer(min_time, max_time):
	timer.wait_time = randf_range(min_time,max_time)
	timer.start()
	timer.one_shot = true
