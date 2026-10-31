extends TextureRect


@export_dir var glitch_folder: String = "res://tigerthawk"


@export var min_delay: float = 1.0
@export var max_delay: float = 5.0


@export var min_flashes: int = 1
@export var max_flashes: int = 4


@export var min_flash_time: float = 0.03
@export var max_flash_time: float = 0.12

var base_texture: Texture2D
var glitch_textures: Array[Texture2D] = []


func _ready() -> void:
	randomize()
	base_texture = texture
	_load_glitch_textures()

	if glitch_textures.is_empty():
		push_warning("No glitch textures found in %s" % glitch_folder)
		return

	_glitch_loop()


func _load_glitch_textures() -> void:
	var dir := DirAccess.open(glitch_folder)
	if dir == null:
		push_error("Can't open folder: %s" % glitch_folder)
		return

	for file_name in dir.get_files():

		var clean := file_name.trim_suffix(".remap").trim_suffix(".import")
		if clean.get_extension().to_lower() not in ["png", "jpg", "jpeg", "webp"]:
			continue

		var tex := load(glitch_folder.path_join(clean)) as Texture2D
		if tex == null or tex == base_texture or glitch_textures.has(tex):
			continue
		glitch_textures.append(tex)


func _glitch_loop() -> void:
	while is_inside_tree():

		texture = base_texture
		await get_tree().create_timer(randf_range(min_delay, max_delay)).timeout
		if not is_inside_tree():
			return


		var flashes := randi_range(min_flashes, max_flashes)
		var last: Texture2D = null
		for i in flashes:
			var pick: Texture2D = glitch_textures.pick_random()

			while pick == last and glitch_textures.size() > 1:
				pick = glitch_textures.pick_random()
			last = pick

			texture = pick
			await get_tree().create_timer(randf_range(min_flash_time, max_flash_time)).timeout
			if not is_inside_tree():
				return
