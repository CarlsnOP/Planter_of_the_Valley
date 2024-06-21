extends Node

#---MUSIC
const A_NEW_DAY = "new_day"
const AT_THE_SPINE_OF_THE_WORLD = "spire"
const LORE_THE_HANDYMAN: = "lore"
const GOOD_TIMES = "good_times"
const HELLO_TERRY = "hello_terry"
const FOREST_MARCH = "forest_march"

#---FOOTSTEPS
const FOOTSTEP1 = "fs1"
const FOOTSTEP2 = "fs2"
const FOOTSTEP3 = "fs3"
const FOOTSTEP4 = "fs4"
const FOOTSTEP5 = "fs5"

#---SFX
const MENU_SELECT = "MS"
const PLANT = "plant"
const WIN = "win"

var SOUNDS = {
	A_NEW_DAY: preload("res://assets/Music/011 - A New Day.mp3"),
	AT_THE_SPINE_OF_THE_WORLD: preload("res://assets/Music/005 - At the Spine of the World.mp3"),
	LORE_THE_HANDYMAN: preload("res://assets/Music/037 - Lore the Handyman.mp3"),
	GOOD_TIMES: preload("res://assets/Music/066 - Good Times.mp3"),
	HELLO_TERRY: preload("res://assets/Music/070 - Hello Terry.mp3"),
	FOREST_MARCH: preload("res://assets/Music/098 - Forest March.mp3")
}

var FOOTSTEPS = {
	FOOTSTEP1: preload("res://assets/SFX/Walking/footstep_grass_000.mp3"),
	FOOTSTEP2: preload("res://assets/SFX/Walking/footstep_grass_001.mp3"),
	FOOTSTEP3: preload("res://assets/SFX/Walking/footstep_grass_002.mp3"),
	FOOTSTEP4: preload("res://assets/SFX/Walking/footstep_grass_003.mp3"),
	FOOTSTEP5: preload("res://assets/SFX/Walking/footstep_grass_004.mp3")
}

var SFX = {
	MENU_SELECT: preload("res://assets/SFX/Menu/select.wav"),
	PLANT: preload("res://assets/SFX/Plant/plant.wav"),
	WIN: preload("res://assets/SFX/Win/Win.wav")
}

func play_clip(player: AudioStreamPlayer2D, clip_key: String):
	if SOUNDS.has(clip_key) == false:
		return
	player.stream = SOUNDS[clip_key]
	player.play()

func play_footstep(player: AudioStreamPlayer2D, clip_key: String):
	if FOOTSTEPS.has(clip_key) == false:
		return
	player.stream = FOOTSTEPS[clip_key]
	player.play()
	
func play_sfx(player: AudioStreamPlayer2D, clip_key: String):
	if SFX.has(clip_key) == false:
		return
	player.stream = SFX[clip_key]
	player.play()
