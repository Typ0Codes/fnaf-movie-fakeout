extends Window

@export var tetogain: int = 10
var score: int = 0

@onready var label: Label = $SubViewportContainer/SubViewport/Birdbrain/Label
@onready var video: VideoStreamPlayer = $SubViewportContainer/SubViewport/Birdbrain/SubViewportContainer/SubViewport/VideoStreamPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	video.paused = true


func _process(_delta: float) -> void:
	timer.paused = video.paused


func _on_timer_timeout() -> void:
	score += 1
	label.text = str(score)
	if tetogain > 0 and score % tetogain == 0:
		owner.breads -= 1


func _on_close_requested() -> void:
	visible = false
	unfocusable = true
	video.paused = true
