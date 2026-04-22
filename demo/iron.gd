extends Node3D

var item = name

func _process(delta) -> void:
	rotate_y(deg_to_rad(2))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("pick_up"):
		body.pick_up(item)
		queue_free()
