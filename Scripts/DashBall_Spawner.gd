extends Node
@onready var DashBall_spawner:Spawner=$Spawner
@onready var sprite:Sprite2D=$Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dashball = DashBall_spawner.spawn() as DashBall
	dashball.died.connect(_on_dashball_died)
	(func():get_tree().current_scene.add_child(dashball)).call_deferred()

func _on_dashball_died():
	await get_tree().create_timer(0.5).timeout
	var new_dashball = DashBall_spawner.spawn() as DashBall
	new_dashball.died.connect(_on_dashball_died)
	get_tree().current_scene.add_child(new_dashball)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
