extends Node2D

@export var Animatronic: Node2D
@export var Hallway: Node3D

@onready var HallwayPNG: Sprite3D = Hallway.find_children("*", "Sprite3D", true, false)[0]


func _process(_delta: float) -> void:
	var station: int = Animatronic.station
	$Station1.visible = station == 1
	$Station2.visible = station == 2
	$Station3.visible = station == 3
	$Station4.visible = station == 4

	if $Station4.visible:
		HallwayPNG.visible = true
		HallwayPNG.texture = $Station4.texture
	if station == Animatronic.killstation:
		HallwayPNG.visible = false
