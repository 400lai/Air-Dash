extends CharacterBody2D
class_name Player

@export var acceleration:int=1800
@export var deceleration:int=3600
@export var max_speed:int=180
@export var max_fall_speed:int=360
@export var jump_speed:int=600
@export var dash_speed:int=200
@export var is_game_over:bool = false

@onready var sprite:AnimatedSprite2D= %Sprite
@onready var DashArea:Area2D= $DashArea
@onready var DashArrow:Control= $DashArrow
@onready var GameOver_SFX:AudioStreamPlayer=$GameOver_SFX
@onready var Dash_SFX:AudioStreamPlayer=$Dash_SFX

static var RIGHT=Vector2(1,0)
static var LEFT=Vector2(-1,0)
static var UP=Vector2(0,-1)
static var DOWN=Vector2(0,1)

signal died()
signal end()

enum State {
	IDLE,
	RUN,
	JUMP,
	DEAD,
}

var dash_target:Node2D=null #dash目标
var g=980
var state:State=State.IDLE
var dash_flag:bool=0
var right_pressed:bool=0
var dash_direction
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	play_animation()

func _physics_process(delta: float) -> void:
	if state==State.DEAD:
		return
	if velocity.y<max_fall_speed:
		velocity.y+=g*delta
	Player_move(delta)
	move_and_slide()
	
#Player_move控制人物状态改变
func Player_move(delta: float):
	if Input.is_action_just_pressed("right"):
		right_pressed=1
	if Input.is_action_pressed("right"):
		if Input.is_action_just_released("left"):
			right_pressed=1
		if right_pressed:
			if is_on_floor():
				state=State.RUN
			if velocity.x>=0 && abs(velocity.x)<max_speed:
				velocity.x+=acceleration*delta
			if velocity.x<0:
				velocity.x+=deceleration*delta
			sprite.flip_h=false
	if Input.is_action_just_pressed("left"):
		right_pressed=0
	if Input.is_action_pressed("left"):
		if Input.is_action_just_released("right"):
			right_pressed=0
		if !right_pressed:
			if is_on_floor():
				state=State.RUN
			if velocity.x<=0 && abs(velocity.x)<max_speed:
				velocity.x-=acceleration*delta
			if velocity.x>0:
				velocity.x-=deceleration*delta
			sprite.flip_h=true
	if Input.is_action_just_pressed("jump"):
		if not is_on_floor():
			return
		state=State.JUMP
		velocity.y=-jump_speed
	if Input.is_action_pressed("dash"):
		dash_target=find_dash_target()
		if dash_target:
			dash_flag=1
			Engine.time_scale=0.03
			dash_direction=(get_global_mouse_position()-dash_target.global_position).normalized()
			DashArrow.rotation=dash_direction.angle()
			DashArrow.global_position=dash_target.global_position+dash_direction*50
			DashArrow.visible=1
		else:
			dash_flag=0
			end_dash()
	if Input.is_action_just_released("dash") && dash_flag:
		Dash_SFX.play()
		end_dash()
		velocity=dash_direction * dash_speed
		dash_target.dash(-dash_direction)
		dash_flag=0
	#
	if not Input.is_action_pressed("right") && not Input.is_action_pressed("left"):
		if is_on_floor():
			state=State.IDLE
		if abs(velocity.x)<=deceleration*delta:
			velocity.x=0
		else:
			if velocity.x>0:
				if is_on_floor():
					velocity.x-=deceleration*delta
				#else:
					#velocity.x-=deceleration/2*delta
			if velocity.x<0:
				if is_on_floor():
					velocity.x+=deceleration*delta
				#else:
					#velocity.x+=deceleration/2*delta
	
		
#基于state播放动画
func play_animation():
	if not is_on_floor() and state!=State.DEAD:
		if velocity.y>0:
			sprite.play("fall")
		else:
			sprite.play("jump")
	else:
		match state:
			State.IDLE:
				sprite.play("idle")
			State.RUN:
				sprite.play("run")
			State.DEAD:
				sprite.play("dead")

func die():
	state=State.DEAD
	end_dash()
	GameOver_SFX.play()
	await get_tree().create_timer(2).timeout
	queue_free()
	died.emit()

#dash相关函数

#选择dash目标
func find_dash_target():
	var closest_target=null
	var min_distance=INF
	var targets=DashArea.get_overlapping_bodies()
	if targets.size()>0:
		for target in targets:
			if target.is_in_group("dashable"):
				var distance=target.position.distance_to(position)
				if distance<min_distance:
					closest_target=target
					min_distance=distance
	return closest_target

#结束dash瞄准状态
func end_dash():
	Engine.time_scale=1
	DashArrow.visible=0
