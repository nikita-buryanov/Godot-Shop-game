extends Sprite2D

@export var main_node: Node
@export var player: Node
@export var hotbar: Node
var hotbar_slots: Array[Node]
@export var slots: Array[Node]
var selected_slot = null
@export var name_text: RichTextLabel
@export var description_text: RichTextLabel
@export var item_preview: Sprite2D
@export var temp_slot: Node
@export var drop_preset: PackedScene
var hand_item: item = null
var hand_item_amount: int = 0

func _ready() -> void:
	hotbar_slots = hotbar.hotbar_slots
	for i in slots.size():
		slots[i].slot_id = i
		slots[i].connect("slot_selected",slot_select)
		slots[i].connect("slot_selected_right_click",slot_selected_right_click)
		slots[i].connect("slot_hovered",slot_hovered)
		slots[i].connect("slot_unhovered",slot_unhovered)
	for i in hotbar_slots.size():
		hotbar_slots[i].slot_id = i + slots.size()
		hotbar_slots[i].connect("slot_selected",slot_select)
		hotbar_slots[i].connect("slot_selected_right_click",slot_selected_right_click)
		hotbar_slots[i].connect("slot_hovered",slot_hovered)
		hotbar_slots[i].connect("slot_unhovered",slot_unhovered)
	slots += hotbar_slots

func slot_hovered(slot_id: int):
	name_text.text = slots[slot_id].slot_item.name
	item_preview.texture = slots[slot_id].slot_item.inv_icon
	description_text.text = slots[slot_id].slot_item.description

func slot_unhovered():
	name_text.text = ""
	item_preview.texture = null
	description_text.text = "'"

func slot_select(slot_id: int, right_click: bool = false):
	# if there is no slot selected select new slot
	if !temp_slot.has_item and slots[slot_id].has_item:
		if Input.is_action_pressed("shift"):
			#  move from hotbar to inv
			if slot_id >= slots.size()-hotbar_slots.size():
				for i in slots.size()-hotbar_slots.size():
					if slots[i].has_item:
						if slots[i].slot_item.id == slots[slot_id].slot_item.id:
							var left_over = slots[i]._add_item(slots[slot_id].slot_item,slots[slot_id].item_amount)
							slots[slot_id].set_item(slots[slot_id].slot_item,left_over)
							if !left_over:
								return
				for i in slots.size()-hotbar_slots.size():
					if !slots[i].has_item:
						slots[i].set_item(slots[slot_id].slot_item,slots[slot_id].item_amount)
						slots[slot_id].set_item(null,0)
						return
			else:
				#  move from inv to hotbar
				print(slot_id)
				for i in range(slots.size()-hotbar_slots.size(),slots.size()):
					print(i)
					if slots[i].has_item:
						if slots[i].slot_item.id == slots[slot_id].slot_item.id:
							var left_over = slots[i]._add_item(slots[slot_id].slot_item,slots[slot_id].item_amount)
							slots[slot_id].set_item(slots[slot_id].slot_item,left_over)
							if !left_over:
								return
				for i in range(slots.size()-hotbar_slots.size(),slots.size()):
					print(i)
					if !slots[i].has_item:
						slots[i].set_item(slots[slot_id].slot_item,slots[slot_id].item_amount)
						slots[slot_id].set_item(null,0)
						return
						
				pass
		elif right_click and slots[slot_id].item_amount > 1:
			temp_slot.set_item(slots[slot_id].slot_item,slots[slot_id].item_amount/2)
			slots[slot_id].remove_amount(slots[slot_id].item_amount/2)
			selected_slot = slot_id
		else:
			temp_slot.set_item(slots[slot_id].slot_item,slots[slot_id].item_amount)
			slots[slot_id].set_item(null,0)
			selected_slot = slot_id
	# if a slot is already selected
	elif temp_slot.has_item:
		if right_click:
			if slots[slot_id].slot_item:
				if slots[slot_id].slot_item.id == temp_slot.slot_item.id:
					var left_over = slots[slot_id]._add_item(temp_slot.slot_item,1)
					if !left_over:
						temp_slot.remove_amount(1)
				else:
					slots[slot_id]._replace_item(temp_slot.slot_item,temp_slot.item_amount,temp_slot)
			else:
				slots[slot_id].set_item(temp_slot.slot_item,1)
				temp_slot.remove_amount(1)
		else:
			if slots[slot_id].slot_item:
				if slots[slot_id].slot_item.id == temp_slot.slot_item.id:
					var left_over = slots[slot_id]._add_item(temp_slot.slot_item,temp_slot.item_amount)
					temp_slot.set_item(temp_slot.slot_item,left_over)
				else:
					slots[slot_id]._replace_item(temp_slot.slot_item,temp_slot.item_amount,temp_slot)
			else:
				slots[slot_id]._replace_item(temp_slot.slot_item,temp_slot.item_amount,temp_slot)


func _add_to_inv(_item: item, amount: int):
	var left_over = amount
	for slot in slots:
		if slot.has_item:
			if slot.slot_item.id == _item.id:
				left_over = slot._add_item(_item,left_over)
				if !left_over:
					return
	for slot in slots:
		left_over = slot._add_item(_item,left_over)
		if !left_over:
			return
		else:
			amount = left_over

func _check_if_can_store_item(new_item: item) -> bool:
	for slot in slots:
		if !slot.has_item:
			return true
		elif slot.slot_item.id == new_item.id:
			if slot.item_amount < slot.slot_item.max_stack_size:
				return true
	return false

func _on_tile_map_click_on(collectable: Variant) -> void:
	if collectable:
		for i in collectable.drops.size():
			if randi_range(0,100) < collectable.chance[i]:
				_add_to_inv(collectable.drops[i],randi_range(collectable.min_amount[i],collectable.max_amount[i]))

func drop_item(_item: item):
	var drop = drop_preset.instantiate()
	drop.position = player.position
	print(drop.position)
	drop.dropped_item = _item
	main_node.add_child(drop)

func slot_selected_right_click(slot_id: int):
	slot_select(slot_id, true)

func _on_player_inv_toggled() -> void:
	print(selected_slot)
	if temp_slot.has_item:
		for i in temp_slot.item_amount:
			drop_item(temp_slot.slot_item)
		temp_slot._remove_item()
	selected_slot = null
