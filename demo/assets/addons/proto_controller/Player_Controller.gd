# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true

@export_group("Speeds")
## Normal speed.
@export var base_speed : float = 250

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var attack : String = "attack"
@export var interact : String = "interact"

var look_rotation : Vector2
var move_speed : float = 0.0
var randNum : int
var animation : String
var random : RandomNumberGenerator
var is_attacking : bool = false

## IMPORTANT REFERENCES
@onready var collider: CollisionShape3D = $Collider
@onready var animationPlayer: AnimationPlayer = $Knight/AnimationPlayer
@onready var swordHitbox: CollisionShape3D = $"Knight/Rig/Skeleton3D/2H_Sword/2H_Sword/SwordCollider/CollisionShape3D"

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = rotation.x
	swordHitbox.disabled = true

func _physics_process(delta: float) -> void:
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = Vector3(input_dir.x * base_speed * delta, 0, input_dir.y * base_speed * delta)
		
		if abs(input_dir.x) > 0.0001 || abs(input_dir.y) > 0.0001:
			rotation.y = atan2(velocity.x, velocity.z)
			animationPlayer.play("Walking_A")
		elif animationPlayer.current_animation == "Walking_A":
			animationPlayer.stop()
			
	if Input.is_action_just_pressed(attack):
		if !is_attacking:
			is_attacking = true
			swordHitbox.disabled = false
			random = RandomNumberGenerator.new()
			random.randomize()
			randNum = random.randi() % 3
			
			animationPlayer.speed_scale = 2.2
			
			match randNum:
				0:
					animation = "2H_Melee_Attack_Chop"
				1:
					animation = "2H_Melee_Attack_Slice"
				2:
					animation = "2H_Melee_Attack_Spin"
					
			print("Animation " + animation)
			animationPlayer.play(animation)
			await animationPlayer.animation_finished
			is_attacking = false
			swordHitbox.disabled = true
		
	if Input.is_action_just_pressed(interact):
		animationPlayer.speed_scale = 1
		animationPlayer.play("Cheer")
		
	if animationPlayer.is_playing() == false:
		animationPlayer.speed_scale = 1
		animationPlayer.play("2H_Melee_Idle")
	
	# Use velocity to actually move
	move_and_slide()
	
func pick_up(item: String):
	print("Picked up " + item)
