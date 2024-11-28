extends RigidBody2D

@export var dropped_item :item 
@export var sprite: Sprite2D
@export var collider: CollisionShape2D
var can_track_player: bool = false
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dropped_item:
		sprite.texture = dropped_item.inv_icon
		linear_velocity = Vector2i(randi_range(-100,100),randi_range(-100,100))
		
	else:
		print("no item assigned")


func _process(delta: float) -> void:
	if player && can_track_player and player.inventory_script._check_if_can_store_item(dropped_item):
		collider.disabled = true
		apply_force(position.direction_to(player.position)*1000)
		print(position.distance_to(player.position))
		if position.distance_to(player.position) < 10:
			player.inventory_script._add_to_inv(dropped_item,1)
			queue_free()
	if linear_velocity.length() <= 3:
		can_track_player = true
	
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
