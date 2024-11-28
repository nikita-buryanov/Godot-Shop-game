extends Node2D

var inv = []
@export var inv_width = 10
@export var inv_height = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in inv_height:
		inv.append([])
		for j in inv_width:
			inv[i].append(0)
	
	for i in inv:
		print(i)
