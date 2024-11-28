extends Control

signal slot_selected(slot_id)
signal slot_selected_right_click(slot_id)
signal slot_hovered(slot_id)
signal slot_unhovered()


@export var is_temp_slot: bool = false
var has_item: bool = false
var is_selected: bool = false
@export var slot_id: int = 0
@export var slot_sprite: Sprite2D
@export var slot_item_id: int = 0
@export var item_amount: int = 0
@export var item_sprite_node: Sprite2D
@export var amount_text: RichTextLabel
@export var slot_item: item
var item_sprite_orig_position: Vector2
var hovered_over: bool = false

func _ready() -> void:
	if slot_item:
		if item_amount == 0:
			item_amount = 1
		set_item(slot_item,item_amount)
	item_sprite_orig_position = item_sprite_node.position

func _process(delta: float) -> void:
	if is_selected or is_temp_slot:
		item_sprite_node.position = get_local_mouse_position()
	if Input.is_action_just_pressed("mouse_right_click") and hovered_over:
		emit_signal("slot_selected_right_click", slot_id)

func _add_item(_item: item, amount):
	#  if slot has item
	if has_item:
		#  if slot item is not the same as new item 
		if slot_item.id != _item.id:
			return amount
		else:
			item_amount += amount
			if item_amount > _item.max_stack_size:
				var left_over = item_amount - _item.max_stack_size
				set_item(_item,_item.max_stack_size)
				return left_over
			else:
				set_item(_item, item_amount)
				return 0
	else:
		set_item(_item,amount)

func _replace_item(_item: item, _amount: int, _slot):
	var old_item = slot_item
	var old_amount = item_amount
	set_item(_item,_amount)
	_slot.set_item(old_item,old_amount)


func remove_amount(amount_to_remove: int) -> int:
	var left_over = 0
	item_amount -= amount_to_remove
	if item_amount <= 0:
		left_over = abs(item_amount)
		item_amount = 0
		_remove_item()
	set_item(slot_item, item_amount)
	return left_over

func _remove_item():
	slot_item = null
	has_item = false
	slot_item_id = 0
	item_amount = 0
	amount_text.text = ""
	item_sprite_node.texture = null

func set_item(_item: item,amount):
	if _item and amount > 0:
		slot_item = _item
		has_item = true
		slot_item_id = _item.id
		item_amount = amount
		if item_amount > 1:
			amount_text.text = str(item_amount)
		else:
			amount_text.text = ""
		item_sprite_node.texture = _item.inv_icon
	else: 
		slot_item = null
		has_item = false
		slot_item_id = 0
		item_amount = 0
		amount_text.text = ""
		item_sprite_node.texture = null

func _on_button_mouse_entered() -> void:
	hovered_over = true
	if has_item:
		emit_signal("slot_hovered",slot_id)
	if slot_sprite:
		color_slot("a3a3a3")

func color_slot(color: String):
	slot_sprite.modulate = Color(color)

func _on_button_mouse_exited() -> void:
	hovered_over = false
	emit_signal("slot_unhovered")
	if slot_sprite:
		color_slot("ffffff")

func _on_button_pressed() -> void:
	emit_signal("slot_selected", slot_id)
