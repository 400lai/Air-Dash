extends Node

@onready var audio_player:AudioStreamPlayer=$AudioStreamPlayer

func play(path:String):
	audio_player.stream=load(path)
	audio_player.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
