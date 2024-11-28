extends RichTextLabel

var inv_open: bool = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inv_open:
		self.text = ""
	position = get_global_mouse_position()


func _on_tile_map_hover_over(text: Variant) -> void:
	self.text = text



func _on_tile_map_unhover_over() -> void:
	self.text = ""


func _on_player_inv_toggled() -> void:
	inv_open = !inv_open
