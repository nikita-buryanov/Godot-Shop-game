extends CharacterBody2D

signal inv_toggled

var equipped_item: item
@export var inventory_script: Node
var mouse_position = Vector2()
@export var speed = 400
@export var inventory_screen: CanvasLayer
var is_inventory_open: bool
var screen_size
var interact: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	if inventory_screen:
		inventory_screen.hide()
	is_inventory_open = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$PlayerSprite.animation == "Interact" or !$PlayerSprite.is_playing():
		velocity = Vector2.ZERO
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_just_pressed("inventory"):
			emit_signal("inv_toggled")
			if is_inventory_open:
				inventory_screen.hide()
				is_inventory_open = false
			else:
				inventory_screen.show()
				is_inventory_open = true
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$PlayerSprite.animation = "Running"
			$PlayerSprite.play()
		else:
			$PlayerSprite.animation = "Idle"
			$PlayerSprite.play()
		
		if velocity.x != 0:
			$PlayerSprite.flip_h = velocity.x < 0
		
		move_and_slide()
		#position += velocity * delta
		if Input.is_action_just_pressed("mouse_left_click"):
			if equipped_item:
				print(equipped_item.item_type)
				if equipped_item.item_type == 1:
					#if not $SwordHitAnimation.is_playing():
					var colliders = $SwordHit.get_all_colliders_in_area()
					for collider in colliders:
						if collider.is_in_group("damagable"):
							collider._hit(1)


func _on_tile_map_click_on(collectable: Variant) -> void:
	$PlayerSprite.animation = "Interact"
	$PlayerSprite.play()


func _on_hotbar_equiped_item(_equiped_item: item) -> void:
	equipped_item = _equiped_item

func _on_hotbar_clear_equiped_item() -> void:
	equipped_item = null
