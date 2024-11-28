extends StaticBody2D

@export var damagable_node: Node = null


func _hit(damage: int) -> void:
	damagable_node._take_damage(damage)
