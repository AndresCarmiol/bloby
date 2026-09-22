extends Area2D

@onready var audioplayer = preload("res://objects/instant_sound.tscn")
@onready var sound_swing = preload("res://audio/pole_1.ogg")
@onready var sound_win = preload("res://audio/win.ogg")

var won: bool = false
var time = 60
var jugador = null

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$sprite.stop()
		$sprite.play("swing")
		play_sound(audioplayer, sound_swing)
		won = true
		if jugador != body:
			jugador = body


func _physics_process(delta: float) -> void:
	if won and time != 100:
		time -= 50 * delta
		if time <= 0:
			play_sound(audioplayer, sound_win)
			time = 100
			jugador.won = true


func play_sound(player, sound):
	var instance = player.instantiate()
	get_tree().get_current_scene().add_child(instance)
	instance.stream = sound
	instance.play()
