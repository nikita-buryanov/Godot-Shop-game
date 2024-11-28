extends AnimatedSprite2D

var inv_open: bool = false
var mouse_position = Vector2()
@export var player: Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !inv_open:
		if Input.is_action_just_pressed("mouse_left_click"):
			if player.equipped_item:
				if player.equipped_item.item_type == 1:
					if player.equipped_item.weapon_type == 0:
						mouse_position = get_global_mouse_position()
						get_parent().rotate(get_angle_to(mouse_position))
						play("Hit")


func _on_player_inv_toggled() -> void:
	inv_open = !inv_open
