extends Resource

class_name item



@export var name: String
@export_enum("Foraging","Weapon","Tool","Food") var item_type
@export_enum("Sword","Bow","Magic") var weapon_type
@export var id: int
@export var max_stack_size: int
@export var description: String
@export var inv_icon: Texture2D
