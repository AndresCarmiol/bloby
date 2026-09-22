extends Sprite2D

var speed_y = 100
var speed_x = 100
var time = 600


func _ready() -> void:
	speed_x = randi_range(40, 80)
	speed_x *= [1, -1].pick_random()
	speed_y = randi_range(40, 80)
	z_index = [-100, 100].pick_random()


func _process(delta: float) -> void:
	position.y -= speed_y * delta
	position.x += speed_x * delta
	speed_x -= 10 * delta * sign(speed_x)
	time -= 30 * delta
	if time <= 0:
		self.queue_free()
