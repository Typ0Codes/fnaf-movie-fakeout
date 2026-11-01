extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible == false:
		$BIRDBRAIN.unfocusable = false
		$Minesweeper2.unfocusable = false
		$Snake2.unfocusable = false
		$BIRDBRAIN.visible = false
		$Minesweeper2.visible = false
		$Snake2.visible = false
		$BIRDBRAIN.video.paused = true


func _on_button_pressed() -> void:
	visible = false
