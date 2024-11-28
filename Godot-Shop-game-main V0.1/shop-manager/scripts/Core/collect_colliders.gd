extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_monitoring(true)


func get_all_colliders_in_area():
	var colliders = get_overlapping_bodies()
	return colliders
