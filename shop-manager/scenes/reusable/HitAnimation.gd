extends AnimatedSprite2D

var mouse_position = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left_click"):
		mouse_position = get_global_mouse_position()
		print(get_angle_to(mouse_position))
		rotate(get_angle_to(mouse_position))
		play("Sword Hit")
