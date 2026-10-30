extends Node2D

const CELL := 20
const GRID := Vector2i(30, 20)
const START_SPEED := 0.12
const MIN_SPEED := 0.05

# Edit these in the Inspector (select the Main node) and they apply on play.
@export_group("Colors")
@export var bg_color := Color(0.1, 0.1, 0.12)
@export var food_color := Color.RED
@export var head_color := Color.GREEN_YELLOW
@export var body_color := Color.LIME_GREEN


var snake: Array[Vector2i] = []
var dir := Vector2i.RIGHT
var next_dir := Vector2i.RIGHT
var food := Vector2i.ZERO
var score := 0
var alive := true

@onready var timer: Timer = $Timer
@onready var label: Label = $Label


func _ready() -> void:
	randomize()
	timer.timeout.connect(_step)
	reset()


func reset() -> void:
	snake = [Vector2i(10, 10), Vector2i(9, 10), Vector2i(8, 10)]
	dir = Vector2i.RIGHT
	next_dir = Vector2i.RIGHT
	score = 0
	alive = true
	timer.wait_time = START_SPEED
	timer.start()
	spawn_food()
	update_label()
	queue_redraw()


func spawn_food() -> void:
	while true:
		food = Vector2i(randi() % GRID.x, randi() % GRID.y)
		if food not in snake:
			return


func _process(_delta: float) -> void:
	# Buffer the direction here; apply it on the next tick.
	# The "!= opposite" checks stop you reversing into yourself.
	if Input.is_action_just_pressed("ui_up") and dir != Vector2i.DOWN:
		next_dir = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down") and dir != Vector2i.UP:
		next_dir = Vector2i.DOWN
	elif Input.is_action_just_pressed("ui_left") and dir != Vector2i.RIGHT:
		next_dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right") and dir != Vector2i.LEFT:
		next_dir = Vector2i.RIGHT

	if not alive and Input.is_action_just_pressed("ui_accept"):
		reset()


func _step() -> void:
	dir = next_dir
	var head := snake[0] + dir

	# Wrap around the edges instead of dying
	head.x = posmod(head.x, GRID.x)
	head.y = posmod(head.y, GRID.y)

	# Self collision only
	if head in snake:
		game_over()
		return

	snake.push_front(head)

	if head == food:
		score += 1
		timer.wait_time = max(MIN_SPEED, timer.wait_time - 0.003)
		spawn_food()
	else:
		snake.pop_back()  # No food eaten: tail follows, length unchanged

	update_label()
	queue_redraw()


func game_over() -> void:
	alive = false
	timer.stop()
	label.text = "Game over! Score: %d  (Enter to restart)" % score


func update_label() -> void:
	label.text = "Score: %d" % score


func _draw() -> void:
	# Background
	draw_rect(Rect2(Vector2.ZERO, Vector2(GRID * CELL)), bg_color)

	# Food
	draw_rect(Rect2(Vector2(food * CELL), Vector2(CELL, CELL)), food_color)

	# Snake (head is a different color)
	for i in snake.size():
		var color := head_color if i == 0 else body_color
		var pos := Vector2(snake[i] * CELL) + Vector2.ONE
		draw_rect(Rect2(pos, Vector2(CELL - 2, CELL - 2)), color)
