extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const SLIDE_GRAVITY = 50.0
const WALL_JUMP_FORCE_X = 250.0
const WALL_JUMP_FORCE_Y = -350.0

func _physics_process(delta: float) -> void:
	# Додаємо гравітацію
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0:
			# Повільне сповзання по стіні
			velocity.y += SLIDE_GRAVITY * delta
		else:
			velocity += get_gravity() * delta

	# Стрибок з підлоги
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			# Відскок від стіни
			# Визначаємо сторону відскоку (протилежно стіні)
			var wall_dir = get_wall_normal().x
			velocity.y = WALL_JUMP_FORCE_Y
			velocity.x = wall_dir * WALL_JUMP_FORCE_X
			print("Відскок від стіни")

	# Рух ліво/право (тільки якщо не в стрибку від стіни)
	if not Input.is_action_just_pressed("Jump") or is_on_floor():
		var direction := Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Рух тіла
	move_and_slide()
