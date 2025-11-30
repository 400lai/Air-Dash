extends CharacterBody2D
class_name DashBall

@export var deceleration=900
@export var g=700
@export var dash_speed:int =400
@export var max_fall_speed:int=360

signal died()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if velocity.y<max_fall_speed:
		velocity.y+=g*delta
	move(delta)
	#两秒钟内从150到250，线性插值
	#position.x=lerp(150,250,clamp(Time.get_ticks_msec()/2000.0,0,1))
	move_and_slide()

func move(delta):
	if is_on_floor():
		if abs(velocity.x)<=deceleration*delta:
			velocity.x=0
		if velocity.x>0:
			velocity.x-=deceleration*delta
		if velocity.x<0:
			velocity.x+=deceleration*delta

func dash(dash_direction):
	velocity=dash_direction * dash_speed

func die():
	died.emit()
	queue_free()
	
