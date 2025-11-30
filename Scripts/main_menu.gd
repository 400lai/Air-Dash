extends Node2D

var level: int = 1  # 当前关卡变量
@export var game_over_label : Label

@onready var check:AudioStreamPlayer=$check
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 自动聚焦在"play"按钮上
	$CenterContainer/MainButtons/play.grab_focus()
	
	# 根据当前窗口模式设置全屏开关状态
	$CenterContainer/SettingsMenu/fullscreen.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN else false
	
	# 设置音量滑块的值，音量以分贝为单位
	$CenterContainer/SettingsMenu/mainvolslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/SettingsMenu/musicvolslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))
	$CenterContainer/SettingsMenu/musicvolslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# 点击"Play"按钮时切换到当前关卡场景
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(str("res://Scenes/Playable/Show_Scene.tscn"))	# 当前关卡

# 点击"Settings"按钮时显示设置菜单
func _on_settings_pressed() -> void:
	$CenterContainer/MainButtons.visible = false  # 隐藏主按钮
	$CenterContainer/SettingsMenu.visible = true  # 显示设置菜单


# 点击"Credits"按钮时显示制作人员信息
func _on_credits_pressed() -> void:
	$CenterContainer/MainButtons.visible = false  # 隐藏主按钮
	$CenterContainer/CreditsMenu.visible = true  # 显示制作人员信息


# 点击"Quit"按钮时退出游戏
func _on_quit_pressed() -> void:
	get_tree().quit()


# 点击"Back"按钮时返回主菜单
func _on_back_pressed() -> void:
	$CenterContainer/MainButtons.visible = true  # 显示主按钮
	if $CenterContainer/SettingsMenu.visible:
		$CenterContainer/SettingsMenu.visible = false  # 隐藏设置菜单
		$CenterContainer/MainButtons/settings.grab_focus()  # 聚焦"Settings"按钮
	if $CenterContainer/CreditsMenu.visible:
		$CenterContainer/CreditsMenu.visible = false  # 隐藏制作人员信息
		$CenterContainer/MainButtons/credits.grab_focus()  # 聚焦"Credits"按钮


# 切换全屏模式
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)  # 设置为全屏
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)  # 设置为最大化窗口


# 主音量滑块值变化时更新音量
func _on_mainvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)

# 背景音乐音量滑块值变化时更新音量
func _on_musicvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("BGM"), value)

# 音效音量滑块值变化时更新音量 (包括枪声、爆炸声、脚步声等)
func _on_sfxvolslider_value_changed(value: float) -> void: # SFX:Sound Effects,包括枪声、爆炸声、脚步声等游戏音效
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)
	
func show_game_over():
	game_over_label.visible = true

func play_check():
	check.play()
