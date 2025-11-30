extends Node2D

@onready var player_spawner:Spawner=$Spawner
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = player_spawner.spawn() as Player
	player.died.connect(_on_player_died)
	#在ready中需要延迟添加节点，是因为如果不这样话，子节点的ready都先于父节点调用完毕了，而新加入节点还没有ready
	(func():get_tree().current_scene.add_child(player)).call_deferred()
	#上一行等同于call_deferred("add_child",player)
	
func _on_player_died():
	#await get_tree().create_timer(0.5).timeout
	var new_player = player_spawner.spawn() as Player
	new_player.died.connect(_on_player_died)
	get_tree().current_scene.add_child(new_player)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
