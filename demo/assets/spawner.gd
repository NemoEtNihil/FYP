extends Node

@export var minion : PackedScene

var random : RandomNumberGenerator

func _process(delta: float) -> void:
	await get_tree().create_timer(3).timeout
	
	
func spawn(item: PackedScene) -> void:
	var spawned_item = item.instantiate()
	print(name + " is spawning " + spawned_item.name)
	random = RandomNumberGenerator.new()
	random.randomize()
	var randNum = 10 - random.randi() % 20
	var randNum2 = 10 - random.randi() % 20
	spawned_item.transform.origin = Vector3(randNum,0,randNum2)
	get_tree().get_root().add_child(spawned_item)
