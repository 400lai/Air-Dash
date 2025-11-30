extends Node2D

@onready var bullet_spawner:Spawner=$Spawner
@onready var sprite:AnimatedSprite2D=$AnimatedSprite2D
@onready var Death_SFX:AudioStreamPlayer=$Death_SFX

@export var filp:bool=false

enum State {
	LIVE,
	DEAD,
}

var state:State=State.LIVE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if filp==true:
		sprite.flip_h=true
		bullet_spawner.position=-bullet_spawner.position
		bullet_spawner.init_speed_x=-bullet_spawner.init_speed_x
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state==State.LIVE:
		sprite.play("live")
	if state==State.DEAD:
		sprite.play("died")

func _on_timeout():
	get_tree().current_scene.add_child(bullet_spawner.spawn())

func dash(dash_direction):
	pass
	
func die(body: Node2D)->void:
	state=State.DEAD
	Death_SFX.play()
	await get_tree().create_timer(0.583).timeout
	queue_free()
