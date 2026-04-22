extends Node3D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _physics_process(delta : float) -> void:
	if animationPlayer.is_playing() == false:
		animationPlayer.play("Taunt_Longer")
