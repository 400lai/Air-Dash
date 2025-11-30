extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).die()
	if body is DashBall:
		(body as DashBall).die()
	#因为body只限制了Node2D类型，用as转换类型
	return
