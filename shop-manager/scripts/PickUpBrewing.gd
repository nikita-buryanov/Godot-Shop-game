extends Area2D

var mouse_held = false
@export var pin_joint : PinJoint2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Input.is_mouse_button_pressed(1): 
		mouse_held = false
		
	if mouse_held:
		var mouse_position = get_global_mouse_position()
		var parent = get_parent()
		
		# move pin node and update the position
		pin_joint.position = mouse_position
		pin_joint.node_a = parent.get_path()
		
	else:
		pin_joint.node_a = NodePath()
	
	

# This function will be triggered when the mouse interacts with the collision shape
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_held = true
