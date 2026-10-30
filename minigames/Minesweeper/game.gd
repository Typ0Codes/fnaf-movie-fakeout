extends Node2D

signal won  # Emitted when every non-mine tile has been revealed

const TILE_SCENE = preload("res://minigames/Minesweeper/Tile.tscn")

@export var rows: int = 18  # Number of rows
@export var cols: int = 18  # Number of columns
@export var num_mines: int = 40

var tiles = []  # 2D array to store tile instances
var first_click_done = false


func _ready():
	create_grid()


func create_grid():
	for y in range(rows):
		tiles.append([])
		for x in range(cols):
			var tile = TILE_SCENE.instantiate()
			tile.position = Vector2(x, y) * tile.tile_size
			tile.tile_pressed.connect(_on_tile_pressed.bind(x, y))  # Connect signal for clicks
			tiles[y].append(tile)
			$Grid.add_child(tile)


func generate_mine_positions(first_click_position: Vector2i) -> Array:
	# The first click and its neighbours can never be mines
	var first_click_positions = []
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			first_click_positions.append(first_click_position + Vector2i(dx, dy))

	var mine_positions = []
	while mine_positions.size() < num_mines:
		var pos = Vector2i(randi() % cols, randi() % rows)
		if pos not in mine_positions and pos not in first_click_positions:
			mine_positions.append(pos)

	return mine_positions


func calculate_adjacent_mines():
	for y in range(rows):
		for x in range(cols):
			var tile = tiles[y][x]
			if not tile.is_mine:
				tile.adjacent_mines = count_adjacent_mines(x, y)


func count_adjacent_mines(x: int, y: int) -> int:
	var count = 0
	for dy in range(-1, 2):  # Iterate over vertical neighbors (-1 to 1)
		for dx in range(-1, 2):  # Iterate over horizontal neighbors (-1 to 1)
			if dx == 0 and dy == 0:
				continue  # Skip the current tile itself

			var nx = x + dx
			var ny = y + dy

			# Check if the neighbor is within bounds
			if nx >= 0 and ny >= 0 and nx < cols and ny < rows:
				if tiles[ny][nx].is_mine:
					count += 1
	return count


func _on_tile_pressed(x: int, y: int):
	var tile = tiles[y][x]

	if not first_click_done:
		first_click_done = true
		# Add mines, excluding the first click's position
		var mine_positions = generate_mine_positions(Vector2i(x, y))
		for pos in mine_positions:
			tiles[pos.y][pos.x].is_mine = true
		calculate_adjacent_mines()

	if tile.is_mine:
		game_over()
	else:
		reveal_tile_and_neighbors(x, y)
		if check_win_condition():
			game_won()


func reveal_tile_and_neighbors(x: int, y: int):
	if x < 0 or y < 0 or x >= cols or y >= rows:
		return

	var tile = tiles[y][x]
	if tile.is_revealed or tile.is_mine:
		return

	tile.reveal_tile()

	# If no adjacent mines, reveal neighbors
	if tile.adjacent_mines == 0:
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				if dx != 0 or dy != 0:
					reveal_tile_and_neighbors(x + dx, y + dy)


# Reveal all mines and end the game
func game_over():
	for row in tiles:
		for tile in row:
			tile.disabled = true
			if tile.is_mine:
				tile.reveal_tile()
	$ColorRect/Label.text = "Game Over!"
	$ColorRect/Label.visible = true


func check_win_condition():
	for row in tiles:
		for tile in row:
			if not tile.is_revealed and not tile.is_mine:
				# If any non-mine tile is not revealed, the player hasn't won
				return false
	return true  # All non-mine tiles are revealed


func game_won():
	for row in tiles:
		for tile in row:
			tile.disabled = true
	# Replace any "Game Over!" text with the win text
	$ColorRect/Label.text = "You Won!"
	$ColorRect/Label.visible = true
	won.emit()


func restart_game():
	first_click_done = false
	for child in $Grid.get_children():
		child.queue_free()
	tiles.clear()

	$ColorRect/Label.text = ""
	$ColorRect/Label.visible = false

	create_grid()


func _on_restart_button_pressed() -> void:
	restart_game()
