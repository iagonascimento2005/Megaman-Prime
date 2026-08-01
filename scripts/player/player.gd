extends CharacterBody2D

#=========================
# CONFIGURAÇÕES
#=========================

@export var speed: float = 250.0
@export var jump_velocity: float = -500.0

@export var slide_speed: float = 400.0
@export var slide_duration: float = 0.45

@export var shoot_duration: float = 0.12

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

#=========================
# VARIÁVEIS
#=========================

var direction: float = 0.0
var facing: int = 1

var sliding := false
var slide_timer := 0.0

var shooting := false
var shoot_timer := 0.0

#=========================
# LOOP PRINCIPAL
#=========================

func _physics_process(delta):

	handle_gravity(delta)

	if sliding:
		handle_slide(delta)
	else:
		handle_horizontal_movement()

		if !check_start_slide():
			handle_jump()

	handle_shoot(delta)

	handle_animations()

	move_and_slide()

#=========================
# GRAVIDADE
#=========================

func handle_gravity(delta):

	if !is_on_floor():
		velocity.y += gravity * delta

#=========================
# MOVIMENTO
#=========================

func handle_horizontal_movement():

	direction = Input.get_axis("esquerda","direita")

	if direction > 0:
		facing = 1
		$AnimatedSprite2D.flip_h = false

	elif direction < 0:
		facing = -1
		$AnimatedSprite2D.flip_h = true

	velocity.x = direction * speed

#=========================
# PULO
#=========================

func handle_jump():

	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = jump_velocity

#=========================
# SLIDE
#=========================

func check_start_slide() -> bool:

	if Input.is_action_pressed("baixo") \
	and Input.is_action_just_pressed("pulo") \
	and is_on_floor():

		sliding = true
		slide_timer = slide_duration

		return true

	return false

func handle_slide(delta):

	slide_timer -= delta

	velocity.x = facing * slide_speed
	velocity.y = 0

	if slide_timer <= 0:
		sliding = false

#=========================
# TIRO
#=========================

func handle_shoot(delta):

	if Input.is_action_pressed("tiro"):

		shooting = true
		shoot_timer = shoot_duration

		#====================
		# CRIAR BALA AQUI
		#====================
		# shoot()

	if shooting:

		shoot_timer -= delta

		if shoot_timer <= 0:
			shooting = false

#=========================
# ANIMAÇÕES
#=========================

func handle_animations():

	#-------------------------
	# SLIDE
	#-------------------------

	if sliding:

		if $AnimatedSprite2D.animation != "slide":
			$AnimatedSprite2D.play("slide")

		return

	#-------------------------
	# PULO
	#-------------------------

	if !is_on_floor():

		if shooting:

			if $AnimatedSprite2D.animation != "jump_shoot":
				$AnimatedSprite2D.play("jump_shoot")

		else:

			if $AnimatedSprite2D.animation != "jump":
				$AnimatedSprite2D.play("jump")

		if velocity.y < 0:
			$AnimatedSprite2D.frame = 1
		else:
			$AnimatedSprite2D.frame = 3

		return

	#-------------------------
	# CHÃO
	#-------------------------

	if abs(velocity.x) > 0:

		if shooting:

			if $AnimatedSprite2D.animation != "run_shoot":
				$AnimatedSprite2D.play("run_shoot")

		else:

			if $AnimatedSprite2D.animation != "run":
				$AnimatedSprite2D.play("run")

	else:

		if shooting:

			if $AnimatedSprite2D.animation != "idle_shoot":
				$AnimatedSprite2D.play("idle_shoot")

		else:

			if $AnimatedSprite2D.animation != "idle":
				$AnimatedSprite2D.play("idle")
