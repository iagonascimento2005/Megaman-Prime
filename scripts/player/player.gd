extends CharacterBody2D

# Parâmetros de movimentação configuráveis no Inspector
@export var speed: float = 250.0
@export var jump_velocity: float = -460.0

# Obtém a gravidade padrão configurada no projeto
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Referência cacheada para otimização de desempenho
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_horizontal_movement()
	handle_jump()
	handle_animations()
	move_and_slide()

# Aplica a força da gravidade quando o personagem não estiver no chão
func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

# Gerencia a entrada de direção horizontal e o espelhamento do sprite
func handle_horizontal_movement() -> void:
	var direction: float = Input.get_axis("esquerda", "direita")
	
	if direction > 0:
		anim.flip_h = false
	elif direction < 0:
		anim.flip_h = true
		
	velocity.x = direction * speed

# Executa o salto caso o comando seja acionado e o personagem esteja no chão
func handle_jump() -> void:
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = jump_velocity

# Controla a máquina de estados das animações com base no estado físico
func handle_animations() -> void:
	if not is_on_floor():
		# Garante que a animação base de pulo esteja ativa
		if anim.animation != "jump":
			anim.play("jump")
			
		# Define o frame do pulo dividindo apenas entre subida e queda
		if velocity.y < 0:
			anim.set_frame(1) # Fase de subida
		else:
			anim.set_frame(3) # Fase de queda
	else:
		# Comportamento para quando o personagem estiver no solo
		if velocity.x != 0:
			if anim.animation != "run":
				anim.play("run")
		else:
			if anim.animation != "idle":
				anim.play("idle")
