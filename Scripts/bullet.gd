extends CharacterBody2D

signal out_vision()

@onready var sprite:AnimatedSprite2D=$Sprite2D

@export var speed:int=250

var player:Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player=get_tree().root.find_child("player",false,false)
	out_vision.connect(die)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	out_vision_check()
	move_and_slide()

func dash(dash_direction):
	rotation=dash_direction.angle()
	velocity=dash_direction*speed

func die(body: Node2D)->void:
	velocity=Vector2(0,0)
	sprite.play("die")
	await get_tree().create_timer(0.583).timeout
	queue_free()

func out_vision_check():
	if !player:
		player=get_tree().root.find_child("player",false,false)
	else:
		if(player.position-position).length()>=500:
			out_vision.emit()
