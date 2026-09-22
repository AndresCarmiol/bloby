extends Node2D

@onready var bubble = preload("res://objects/bubble.tscn")

var time = 60

func _ready() -> void:
	time = randi_range(10, 40)

func _process(delta: float) -> void:
	time -= 60 * delta
	if time <= 0:
		time = randi_range(120, 200)
		var instance = bubble.instantiate()
		get_tree().get_current_scene().add_child(instance)
		instance.position = self.position
