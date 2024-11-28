extends Node

@export var drop_preset: PackedScene
var main_parent: Node
@export var health: int = 10
@export var speed: int = 10
@export var movement_animation: Node
@export var shadow: Node
var flipped_movement: bool  = false
@export var border: Node
@export var collectible: collectable_re


func _ready() -> void:
	movement_animation.animation = "walk"
	shadow.animation = "shadow"
	movement_animation.stop()
	shadow.stop()


func _animate_movement_start() -> void:
	if movement_animation:
		movement_animation.play()
	if shadow:
		shadow.play()

func _animate_movement_stop() -> void:
	if movement_animation:
		movement_animation.stop()
	if shadow:
		shadow.stop()
		
func flip_movement(dir):
	movement_animation.flip_h = dir
	shadow.flip_h = dir

func _take_damage(damage : int) -> void:
	health -= damage
	if health <= 0:
		_die()
	else:
		_damage_animation()
		
		
func _die() -> void:
	for i in collectible.drops.size():
		print("i = " + str(i))
		if collectible.chance[i] >= randf_range(0,100):
			print("chance passed")
			for col in randi_range(collectible.min_amount[i],collectible.max_amount[i]):
				var drop = drop_preset.instantiate()
				drop.position = self.position
				print(drop.position)
				drop.dropped_item = collectible.drops[i]
				border.add_child(drop)
	queue_free()
	
	
func _damage_animation() -> void:
	if movement_animation:
		var original_color = movement_animation.modulate
		movement_animation.modulate = Color(255,0,0,255)
		await get_tree().create_timer(0.1).timeout
		movement_animation.modulate = original_color
	
