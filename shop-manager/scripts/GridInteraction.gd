extends Node2D

var player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get the global mouse position
	var mouse_position = get_global_mouse_position()
	
	# Convert the global mouse position to local coordinates relative to the tilemap layer
	var local_mouse_pos = $TileMapLayer3.local_to_map(mouse_position)
	
	if player != null:
		$TileMapLayer3.clear()
		var tile_pos = $TileMapLayer3.map_to_local(local_mouse_pos)
		var distance_player_and_cursor = sqrt(pow(player.position.x-tile_pos.x,2)+pow(player.position.y-tile_pos.y,2))
		if distance_player_and_cursor < 70:
			$TileMapLayer3.set_cell(local_mouse_pos,0, Vector2i(0, 0)) # Replace 0 with appropriate atlas index if needed
		else:
			$TileMapLayer3.set_cell(local_mouse_pos,0, Vector2i(1, 0)) # Replace 0 with appropriate atlas index if needed
