extends Node2D

@export var min_zoom_in = 2.4
@export var max_zoom_in = 5.4
var zoom_level = max_zoom_in

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("zoom_in"):
		zoom_level += 0.1
	if Input.is_action_pressed("zoom_out"):
		zoom_level -= 0.1
	
	zoom_level = clamp(zoom_level, min_zoom_in,max_zoom_in)
	$Camera2D.zoom.x = zoom_level
	$Camera2D.zoom.y = zoom_level
