extends Node2D

@onready var tile_map = $TileMap
@onready var player = %Player
@onready var hud = $CanvasLayer/HUD
@onready var game_over_ui = $CanvasLayer/GameOverUi
@onready var exit_menu = $ExitMenu
@onready var flame = %Flame
@onready var light_on = %LightOn
@onready var music_player = $MusicPlayer
@onready var footsteps_player = $FootstepsPlayer
@onready var sfx_player = $SFXPlayer
@onready var camera_2d = $Player/Camera2D

const DUST_PARTICLES = preload("res://scenes/particles/dust.tscn")
const DIRT_PARTICLES: PackedScene = preload("res://scenes/particles/dirt.tscn")
const LIGHT_ON = preload("res://scenes/light_on/light_on.tscn")

const FLOOR_LAYER = 0
const WALL_LAYER = 1
const TARGET_LAYER = 2
const BOX_LAYER = 3

const SOURCE_ID = 0

const LAYER_KEY_FLOOR = "Floor"
const LAYER_KEY_WALLS = "Walls"
const LAYER_KEY_TARGETS = "Targets"
const LAYER_KEY_TARGET_BOXES = "TargetBoxes"
const LAYER_KEY_BOXES = "Boxes"

const LAYER_MAP = {
	LAYER_KEY_FLOOR: FLOOR_LAYER,
	LAYER_KEY_WALLS: WALL_LAYER,
	LAYER_KEY_TARGETS: TARGET_LAYER,
	LAYER_KEY_TARGET_BOXES: BOX_LAYER,
	LAYER_KEY_BOXES: BOX_LAYER
}


var _moving: bool = false
var _total_moves: int = 0
var torch_right := Vector2(30, 15)
var torch_left := Vector2(7, 15)

func _ready():
	setup_level()
	
func _process(_delta):
		
	if Input.is_action_just_pressed("exit"):
		exit_menu.show()
		
	else:
		if Input.is_action_just_pressed("reload"):
			setup_level()
		
		hud.set_moves_label(_total_moves)
		
		if _moving:
			return

		var move_direction = Vector2i.ZERO
		
		if Input.is_action_just_pressed("right"):
			move_direction = Vector2i.RIGHT
			player_right()
		if Input.is_action_just_pressed("left"):
			move_direction = Vector2i.LEFT
			player_left()
		if Input.is_action_just_pressed("up"):
			move_direction = Vector2i.UP
			player_up()
		if Input.is_action_just_pressed("down"):
			move_direction = Vector2i.DOWN
			player_down()
		
		if move_direction != Vector2i.ZERO:
			player_move(move_direction)
			var pos = get_player_tile()
			spawn_dust_particles(pos, move_direction)

# PLAYER MOVEMENT
func place_player_on_tile(tile_coord: Vector2i) -> void:
	var new_pos: Vector2 = Vector2(
		tile_coord.x * GameData.TILE_SIZE,
		tile_coord.y * GameData.TILE_SIZE)
	player.global_position = new_pos

func move_player(tile_coord: Vector2i) -> void:
	var tween = get_tree().create_tween()
	var new_pos: Vector2 = Vector2(
		tile_coord.x * GameData.TILE_SIZE,
		tile_coord.y * GameData.TILE_SIZE)
	SoundManager.play_footstep(footsteps_player, SoundManager.FOOTSTEPS.keys().pick_random())
	tween.tween_property(player, "position", Vector2(new_pos.x, new_pos.y), 0.1)

#PARTICLES
func spawn_dirt_particles(pos: Vector2i) -> void:
	var instance = DIRT_PARTICLES.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = Vector2(pos.x + 16, pos.y + 16)
	
func spawn_dust_particles(pos: Vector2i, normal: Vector2) -> void:
	var instance = DUST_PARTICLES.instantiate()
	var new_pos = Vector2(pos.x * GameData.TILE_SIZE, pos.y * GameData.TILE_SIZE)
	get_tree().current_scene.add_child(instance)
	instance.global_position = Vector2(new_pos.x + 16, new_pos.y + 28)
	instance.rotation = -normal.angle()

# GAME LOGIC
func player_up() -> void:
	player.set_animation("walk_up")
	flame.position = torch_right
	light_on.position = torch_right
	await get_tree().create_timer(0.1).timeout
	player.set_animation("idle_up")

func player_right() -> void:
	player.set_animation("walk_right")
	flame.position = torch_right
	light_on.position = torch_right
	await get_tree().create_timer(0.1).timeout
	player.set_animation("idle_right")


func player_left() -> void:
	player.set_animation("walk_left")
	flame.position = torch_left
	light_on.position = torch_left
	await get_tree().create_timer(0.1).timeout
	player.set_animation("idle_left")

func player_down() -> void:
	player.set_animation("walk_down")
	flame.position = torch_right
	light_on.position = torch_right
	await get_tree().create_timer(0.1).timeout
	player.set_animation("idle")

func check_game_state() -> void:
	for t in tile_map.get_used_cells(TARGET_LAYER):
		if !cell_is_box(t):
			return
	SoundManager.play_sfx(footsteps_player, SoundManager.WIN)
	game_over_ui.game_over(GameManager.get_level_selected(), _total_moves)
	hud.hide()
	ScoreSync.level_completed(GameManager.get_level_selected(), _total_moves)

func move_box(box_tile: Vector2i, direction: Vector2i) -> void:
	var dest = box_tile + direction
	var particle_pos: Vector2 = Vector2(dest * GameData.TILE_SIZE)
	
	tile_map.erase_cell(BOX_LAYER, box_tile)
	
	if dest in tile_map.get_used_cells(TARGET_LAYER):
		SoundManager.play_sfx(sfx_player, SoundManager.PLANT)
		spawn_dirt_particles(particle_pos)
		camera_2d.apply_shake(2, 8)
		tile_map.set_cell(BOX_LAYER, dest, SOURCE_ID, get_atlas_coord_for_layer_name(LAYER_KEY_TARGET_BOXES))
	else:
		tile_map.set_cell(BOX_LAYER, dest, SOURCE_ID, get_atlas_coord_for_layer_name(LAYER_KEY_BOXES))

func get_player_tile() -> Vector2i:
	var player_offset = player.global_position - tile_map.global_position
	return Vector2i(player_offset / GameData.TILE_SIZE)

func cell_is_wall(cell: Vector2i) -> bool:
	return cell in tile_map.get_used_cells(WALL_LAYER)

func cell_is_box(cell: Vector2i) -> bool:
	return cell in tile_map.get_used_cells(BOX_LAYER)

func cell_is_empty(cell: Vector2i) -> bool:
	return cell_is_wall(cell) == false and cell_is_box(cell) == false

func box_can_move(box_tile: Vector2i, direction: Vector2i) -> bool:
	var new_tile = box_tile + direction
	return cell_is_empty(new_tile)

func player_move(direction: Vector2i):
	_moving = true
	var player_tile = get_player_tile()
	var new_tile = player_tile + direction
	var can_move = true
	var box_seen = false
	
	if cell_is_wall(new_tile):
		can_move = false
	if cell_is_box(new_tile):
		box_seen = true
		can_move = box_can_move(new_tile, direction)
	
	if can_move:
		
		_total_moves += 1
		if box_seen:
			move_box(new_tile, direction)
		move_player(new_tile)
		check_game_state()
		
	_moving = false

# LEVEL SETUP

func get_atlas_coord_for_layer_name(layer_name: String) -> Vector2i:
	match layer_name:
		LAYER_KEY_FLOOR:
			return Vector2i(randi_range(3,8),0)
		LAYER_KEY_WALLS:
			return Vector2i(2,0)
		LAYER_KEY_TARGETS:
			return Vector2i(9,0)
		LAYER_KEY_TARGET_BOXES:
			return Vector2i(0,0)
		LAYER_KEY_BOXES:
			return Vector2i(1,0)
	return Vector2i.ZERO

func add_tile(tile_coord: Dictionary, layer_name: String) -> void:
	var layer_number = LAYER_MAP[layer_name]
	var coord_vec: Vector2i = Vector2i(tile_coord.x, tile_coord.y)
	var atlas_vec = get_atlas_coord_for_layer_name(layer_name)
	
	tile_map.set_cell(layer_number, coord_vec, SOURCE_ID, atlas_vec)

func add_layer_tiles(layer_tiles, layer_name: String) -> void:
	for tile_coord in layer_tiles:
		add_tile(tile_coord.coord, layer_name)

func setup_level() -> void:
	SoundManager.play_sfx(sfx_player, SoundManager.MENU_SELECT)
	tile_map.clear()
	var ln = GameManager.get_level_selected()
	var level_data = GameData.get_data_for_level(ln)
	var level_tiles = level_data.tiles
	var player_start = level_data.player_start
	
	_total_moves = 0
	
	for layer_name in LAYER_MAP.keys():
		add_layer_tiles(level_tiles[layer_name], layer_name)
	
	place_player_on_tile(Vector2i(player_start.x, player_start.y))
	hud.new_game(ln)
	game_over_ui.new_game()
	SoundManager.play_clip(music_player, SoundManager.SOUNDS.keys().pick_random())
