extends Camera3D

@export var player : CharacterBody3D

func _physics_process(delta: float) -> void:
	transform.origin = Vector3(player.transform.origin.x, 5, player.transform.origin.z + 5)
	look_at(player.global_transform.origin, Vector3(0,1,0))
