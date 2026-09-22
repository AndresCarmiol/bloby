extends Area2D

@onready var audioplayer = preload("res://objects/instant_sound.tscn")
@onready var sound_corn_1 = preload("res://audio/corn_1.ogg")
@onready var sound_corn_2 = preload("res://audio/corn_2.ogg")
@onready var sound_corn_3 = preload("res://audio/corn_3.ogg")
@onready var sound_bloby_1 = preload("res://audio/bloby_1.ogg")
@onready var sound_bloby_2 = preload("res://audio/bloby_2.ogg")
@onready var sound_bloby_3 = preload("res://audio/bloby_3.ogg")

@export var size: int = 0
var time_max = 60
var time = time_max
var offset = 1

func _ready() -> void:
	$sprite.frame = size

func _physics_process(delta: float) -> void:
	time -= 120 * delta
	if time <= 0:
		time = time_max
		offset = -offset
		$sprite.offset.y = offset

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if $sprite.frame == 0:
			play_sound(audioplayer, sound_corn_2)
			body.points += 10
		elif $sprite.frame == 1:
			play_sound(audioplayer, sound_corn_3)
			body.points += 30
		else:
			play_sound(audioplayer, sound_corn_3)
			body.points += 100
			var voice = [sound_bloby_1, sound_bloby_2, sound_bloby_3].pick_random()
			play_sound(audioplayer, voice)
		self.queue_free()


func play_sound(player, sound):
	var instance = player.instantiate()
	get_tree().get_current_scene().add_child(instance)
	instance.stream = sound
	instance.pitch_scale = randf_range(0.8, 1.2)
	instance.volume_db = 5
	instance.play()
