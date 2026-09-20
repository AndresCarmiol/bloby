extends CharacterBody2D


enum States {
	GROUNDBOUND,
	AIRBORNE
}

const SPEED = 200.0
const JUMP_VELOCITY = 300.0
const GRAV = 500.0
const MAX_FALL_SPEED = 250.0

var state: States = States.GROUNDBOUND
var key_dir: Vector2i = Vector2i(0, 0)
var direction: Vector2i = Vector2i(0, -1)
var energy: Vector2 = Vector2(0.0, 0.0)


func _physics_process(delta: float) -> void:
	_start_physics_process(delta)

	_airborne(delta)
	_groundbound(delta)
	_animation()

	_end_physics_process(delta)


func _groundbound(_delta: float):
	if state != States.GROUNDBOUND:
		return
	velocity = Vector2.ZERO
	if Input.is_action_just_pressed("key_jump"):
		velocity = Vector2((JUMP_VELOCITY / (2 + abs(energy.y) / 100)) * direction.x + energy.x, min(JUMP_VELOCITY * direction.y + energy.y, 0.0))
		$sprite.play("airborne")
		$sprite.offset.y = 0.0
		state = States.AIRBORNE
		return
	var key_press = (key_dir.x != 0 and direction.x == 0 or key_dir.y != 0 and direction.y == 0)
	if key_press and $sprite.animation != "charge_1" and $sprite.animation != "charge_2" and $sprite.animation != "charge_3":
		energy = Vector2(100 * -key_dir.x * abs(direction.y), 200 * -key_dir.y * abs(direction.x))
		$sprite.play("charge_1")
	elif key_press and $sprite.animation != "charge_2" and $sprite.animation != "charge_3" and !$sprite.is_playing():
		energy = Vector2(200 * -key_dir.x * abs(direction.y), 300 * -key_dir.y * abs(direction.x))
		$sprite.play("charge_2")
	elif key_press and $sprite.animation != "charge_3" and !$sprite.is_playing():
		energy = Vector2(300 * -key_dir.x * abs(direction.y), 400 * -key_dir.y * abs(direction.x))
		$sprite.play("charge_3")
	if key_dir.x == 0 or direction.y == 0:
		energy.x = 0
	if key_dir.y == 0 or direction.x == 0:
		energy.y = 0


func _airborne(delta: float):
	if state != States.AIRBORNE:
		return
	velocity.y += GRAV * delta
	velocity.x += key_dir.x * SPEED * delta


func _start_physics_process(_delta: float) -> void:
	key_dir = Vector2i(
		int(Input.is_action_pressed("key_right")) - int(Input.is_action_pressed("key_left")),
		int(Input.is_action_pressed("key_down")) - int(Input.is_action_pressed("key_up"))
	)


func _end_physics_process(delta: float) -> void:
	var kinematic_collision = move_and_collide(velocity * delta)
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	_process_collision(kinematic_collision)


func _process_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return
	var collision_normal = collision.get_normal()
	_basic_collision_response(collision_normal)


func _basic_collision_response(coll_normal) -> void:
	if coll_normal.x != 0:
		direction = Vector2(coll_normal.x, 0)
		velocity.x = 0
		if state_is(States.AIRBORNE):
			_set_state(States.GROUNDBOUND)
			$sprite.play("land")
	if coll_normal.y != 0:
		direction = Vector2(0, coll_normal.y)
		velocity.y = 0
		if state_is(States.AIRBORNE):
			_set_state(States.GROUNDBOUND)
			$sprite.play("land")


func state_is(check_state) -> bool:
	return state == check_state


func _set_state(set_state) -> void:
	state = set_state


func _animation() -> void:
	if state_is(States.GROUNDBOUND):
		$sprite.rotation = PI/2 * -direction.x
		$sprite.flip_v = bool(direction.y + 1)
		$sprite.offset.y = -2 + 4 * int($sprite.flip_v)
		if $sprite.animation == "land" and !$sprite.is_playing():
			$sprite.play("idle")
		var key_press = (key_dir.x != 0 and direction.x == 0 or key_dir.y != 0 and direction.y == 0)
		if key_press:
			$sprite.flip_h = bool((key_dir.x + 1) * abs(direction.y) + (key_dir.y - 1 * direction.x) * abs(direction.x))
		elif (key_dir.x == 0 and direction.x == 0 or key_dir.y == 0 and direction.y == 0) and $sprite.animation != "land" and $sprite.animation != "idle":
			if $sprite.animation == "charge_1" or $sprite.animation == "charge_2" or $sprite.animation == "charge_3":
				$sprite.play("idle")
