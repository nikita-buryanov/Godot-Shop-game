extends State

var wander_destination_reached: bool = false
var velocity: Vector2 = Vector2.ZERO
var border: Node
var target_pos: Vector2 = Vector2.ZERO
@export var main_body: Node
@export var agent: Node
var SPEED: int = 1
@export var wander_max_wait: int = 3
@export var timer: Timer


func Update(delta: float):
	border = main_body.border
	SPEED = main_body.speed
	if wander_destination_reached == false: 
		if velocity == Vector2.ZERO:
			target_pos = _get_random_position_in_border()
		if main_body.position.distance_to(target_pos) > 5:
			agent.target_position = target_pos
			velocity =  main_body.position.direction_to(agent.get_next_path_position()) * SPEED
			main_body.position += velocity * delta
		else:
			_start_timer(1,wander_max_wait)
			wander_destination_reached = true
			velocity = Vector2.ZERO
	else:
		if timer.time_left <= 0:
			wander_destination_reached = false
	_animate_movement()

func _get_random_position_in_border() -> Vector2:
	if border != null:
		var new_pos = border.get_random_point()
		return new_pos
	else:
		return Vector2.ZERO

func _start_timer(min_time, max_time):
	timer.wait_time = randf_range(min_time,max_time)
	timer.start()
	timer.one_shot = true

func _animate_movement():
	if velocity.length() > 0:
		main_body._animate_movement_start()
	else:
		main_body._animate_movement_stop()
	if velocity.x != 0:
		main_body.flip_movement(velocity.x < 0)
