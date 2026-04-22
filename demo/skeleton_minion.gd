extends RigidBody3D

@export var item_scene : PackedScene
@export var player : CharacterBody3D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape3D = $CollisionShape3D

@onready var hp: int = 2

var dir = Vector3(0,0,0)
var alive = true

func _process(delta : float) -> void:
#	if animationPlayer.is_playing() == false:
#		animationPlayer.play("Taunt_Longer")
#		animationPlayer.play("Death_A")
	if alive && (animationPlayer.is_playing() == false):
		animationPlayer.play("Walking_A")

	look_at(player.global_position,Vector3.UP,true)

	move_and_collide(global_position.direction_to(player.global_position),delta*20000)
	
	print((global_position.direction_to(player.global_position)))	
		
func hit(damage: int) -> void:
	hp -= damage
	print(name + " hp left: " + str(hp))
	if hp <= 0 && alive:
		die()
		
func spawn_item(item: PackedScene) -> void:
	var spawned_item = item.instantiate()
	print(name + " is spawning " + spawned_item.name)
	spawned_item.transform.origin = transform.origin
	get_tree().get_root().add_child(spawned_item)

func die() -> void:
	alive = false
	collider.disabled = true
	animationPlayer.stop()
	animationPlayer.play("Death_A")
	await animationPlayer.animation_finished
	freeze = true
	spawn_item(item_scene)
	await get_tree().create_timer(3).timeout
	queue_free()
