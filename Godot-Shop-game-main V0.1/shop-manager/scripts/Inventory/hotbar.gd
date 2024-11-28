extends GridContainer

signal equiped_item(equiped_item: item)
signal clear_equiped_item()

@export var hotbar_slots: Array[Node]
var selected_slot: int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in hotbar_slots.size():
		if i == selected_slot:
			hotbar_slots[i].color_slot("a3a3a3")
		else:
			hotbar_slots[i].color_slot("ffffff")
	if Input.is_action_just_released("scroll_hot_bar_up"):
		if selected_slot == 0:
			selected_slot = 5
		else:
			selected_slot-=1
		if hotbar_slots[selected_slot].has_item:
			emit_signal("equiped_item",hotbar_slots[selected_slot].slot_item)
		else:
			emit_signal("clear_equiped_item")
	if Input.is_action_just_released("scroll_hot_bar_down"):
		if selected_slot == 5:
			selected_slot = 0
		else:
			selected_slot+=1
		if hotbar_slots[selected_slot].has_item:
			emit_signal("equiped_item",hotbar_slots[selected_slot].slot_item)
		else:
			emit_signal("clear_equiped_item")
	if selected_slot == 6:
		selected_slot = 0
	elif selected_slot == -1:
		selected_slot = 5
