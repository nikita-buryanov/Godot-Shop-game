extends Node2D

signal hover_over(text)
signal unhover_over
signal click_on(collectable)
var player = null
var inv_open: bool = false
var refreshing_tiles: Dictionary

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !inv_open:
		# Get the global mouse position
		var mouse_position = get_global_mouse_position()
		
		# Convert the global mouse position to local coordinates relative to the tilemap layer
		var local_mouse_pos = $Cursor.local_to_map(mouse_position)
		var tile_pos = $Cursor.map_to_local(local_mouse_pos)
		if player != null:
			$Cursor.clear()
			var distance_player_and_cursor = sqrt(pow(player.position.x-tile_pos.x,2)+pow(player.position.y-tile_pos.y,2))
			if distance_player_and_cursor < 70:
				$Cursor.set_cell(local_mouse_pos,0, Vector2i(0, 0)) # Replace 0 with appropriate atlas index if needed
				var itemid = $Pickups.get_cell_tile_data($Pickups.local_to_map(to_local(mouse_position)))
				if itemid:
					emit_signal("hover_over",itemid.get_custom_data("action"))
					if Input.is_action_just_pressed("mouse_left_click"):
						if itemid.get_custom_data("action") == "Pick Up":
							emit_signal("click_on",itemid.get_custom_data("collectable"))
							$Pickups.set_cell(local_mouse_pos,4,$Pickups.get_cell_atlas_coords(local_mouse_pos))
							var new_cell = $Pickups.get_cell_tile_data($Pickups.local_to_map(to_local(mouse_position)))
							refreshing_tiles[local_mouse_pos] = randf_range(new_cell.get_custom_data("TimerMin"),new_cell.get_custom_data("TimerMax"))
				else:
					emit_signal("unhover_over")
			else:
				$Cursor.set_cell(local_mouse_pos,0, Vector2i(1, 0)) # Replace 0 with appropriate atlas index if needed
				emit_signal("unhover_over")
		# Refresh gathered resources
		for r_tile in refreshing_tiles:
			var time_left = refreshing_tiles[r_tile]
			if time_left <= 0:
				$Pickups.set_cell(r_tile,3,$Pickups.get_cell_atlas_coords(r_tile))
				refreshing_tiles.erase(r_tile)
			else:
				time_left -= delta
				refreshing_tiles[r_tile] = time_left 
	else:
		$Cursor.clear()
	


func _on_player_inv_toggled() -> void:
	inv_open = !inv_open
