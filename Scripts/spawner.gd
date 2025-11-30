extends Node2D
class_name Spawner

@export var scene_to_spawn:PackedScene
@export var init_speed_x:int=0
@export var init_speed_y:int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn()-> Node2D:
	if scene_to_spawn==null:
		return
	var instance = scene_to_spawn.instantiate()
	instance.position=global_position
	if instance is CharacterBody2D:
		instance.velocity=Vector2(init_speed_x,init_speed_y)
	return instance
