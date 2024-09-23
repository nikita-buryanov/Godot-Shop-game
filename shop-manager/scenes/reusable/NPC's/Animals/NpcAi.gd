extends Node2D

@onready var agent = $NavigationAgent2D
@export var SPEED = 1
var target_pos = Vector2()
var state = "wander"
var ground = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "wander":
		_wander()



func _wander() -> void:
	pass 
	
func _set_tile_map(tilemap) -> void:
	pass
