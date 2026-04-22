extends Area3D

@export var damage : int = 1

func increase_damage(increment: int) -> void:
	damage += increment	
func _on_body_entered(body: Node3D) -> void:
	print("collided with ", body.name)
	if body.has_method("hit"):
		body.hit(damage)
