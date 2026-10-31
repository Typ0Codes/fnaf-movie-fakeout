extends Node2D

@export var maxnukes = 5
@onready var nukes = maxnukes
@export var maxshells = 3
@onready var shells = maxshells
@export var maxbreads = 5
@onready var breads = maxbreads
signal nuked
signal nphshot
signal FEED

var currenttime = 12
@export var leavetime = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$Cams/Stats/Nukes.text = str(nukes) + "/" + str(maxnukes) + " Nukes"
	$Cams/Stats/Shells.text = str(shells) + "/" + str(maxshells) + " Shells"
	$Cams/Stats/Breads.text = str(breads) + "/" + str(maxbreads) + " Breads"
	
	
	
		
	$Cams/Stats/Clock.text = str(currenttime) + "am"


func _on_button_pressed() -> void:
	if nukes >= 1 and $"Animatronics/Freddy Fazbears".hiding:
		nukes -= 1
		emit_signal("nuked")


func _on_clock_timeout() -> void:
	currenttime+=1
	if currenttime == leavetime:
		get_tree().change_scene_to_file("res://Main Menu.tscn")


func _NPH_Shot() -> void:
	if shells >= 1 and $"Animatronics/NPH".hiding:
		shells -= 1
		emit_signal("nphshot")

func _on_minesweeper_won() -> void:
	nukes += 1


func _FEED() -> void:
	if breads >= 1 and $Animatronics/Teto.station > 1:
		breads -= 1
		emit_signal("FEED")


func _on_cams_pressed() -> void:
	$Cams.visible = not $Cams.visible
