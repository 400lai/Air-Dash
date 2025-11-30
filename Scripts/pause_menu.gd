extends CanvasLayer

@export var pause_panel: Panel
# @export var bgm_player: AudioStreamPlayer
@export var pause_sound: AudioStreamPlayer # 暂停音效播放器
var paused_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#	var volume_linear = db_to_linear(bgm_player.volume_db)
#	var target_volume = 0.0 if get_tree().paused else 1.0
#	volume_linear = lerp(volume_linear, target_volume, delta * 15.0)
#	bgm_player.volume_db = linear_to_db(volume_linear)
	
#	bgm_player.stream_paused = get_tree().paused and Time.get_ticks_msec() > paused_time + 300

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:  # 检测是否按下了 ESC 键
			if not get_tree().paused:
				pause()  # 执行暂停操作
			else:
				unpause()  # 执行恢复操作

# 暂停游戏
func pause():
	get_tree().paused = true  # 暂停游戏树
	pause_panel.visible = true
	paused_time = Time.get_ticks_msec()  # 记录暂停的时间
	pause_sound.play()  # 播放暂停音效

# 恢复游戏
func unpause():
	get_tree().paused = false  # 恢复游戏树
	pause_panel.visible = false  # 隐藏暂停面板
	pause_sound.play()  # 播放恢复音效

func back_main_menu():
	get_tree().paused = false  # 恢复游戏树
	pause_sound.play()  # 播放恢复音效
	get_tree().change_scene_to_file(str("res://Scenes/UI/main_menu.tscn"))

# 退出游戏
func quit_game():
	get_tree().quit()
	
