extends Node2D

@export var killstation = 5
var station = 1
@onready var MoveTimer = $MoveTimer
@export var MoveMin = 2.0
@export var MoveMax = 25.0

var hiding = false
var in_sequence = false
var run_id = 0  




func _ready() -> void:
	MoveTimer.wait_time = randf_range(MoveMin, MoveMax)
	MoveTimer.start()


func _process(_delta: float) -> void:
	
	
	if station == killstation:
		if not in_sequence:
			_run_jumpscare()
	elif not in_sequence:
		$AudioStreamPlayer.stop()


func _run_jumpscare() -> void:
	in_sequence = true
	var my_id = run_id

	self.visible = true
	self.scale = Vector2(0.25, 0.25)
	hiding = true

	await get_tree().create_timer(2.0).timeout
	if my_id != run_id: return 
	self.position = Vector2(1152/2,648/2)
	hiding = false
	self.scale = Vector2(0.5, 0.5)
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	$AnimationPlayer.play("Jumpscare")

	await get_tree().create_timer(3.0).timeout
	if my_id != run_id: return  
	get_tree().change_scene_to_file("res://thecuckshow.tscn")
	_reset_state()


func _reset_state() -> void:
	MoveTimer.stop()
	hiding = false
	in_sequence = false
	self.scale = Vector2(0.5, 0.5)
	self.visible = false
	$AudioStreamPlayer.stop()
	$AnimationPlayer.play("RESET")
	station = 0
	MoveTimer.wait_time = MoveMax * 1.5
	MoveTimer.start()

func _on_move_timer_timeout() -> void:
	if not in_sequence:
		station += 1
		print(self.name + str(station))
	MoveTimer.wait_time = randf_range(MoveMin, MoveMax)
	MoveTimer.start()
	print(MoveTimer.wait_time)


func FEED() -> void:
	if station > 1:
		run_id += 1  
		station -= 1
		$AudioStreamPlayer2.play()
		MoveTimer.wait_time += (5 - station)
		MoveTimer.start()
