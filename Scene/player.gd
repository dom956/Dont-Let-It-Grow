extends CharacterBody2D

@export var speed = 50
var gravity = 1000  # Adjust gravity as needed for better fall speed
var is_attacking = false
@onready var bush = $"../tree"

func _ready() -> void:
	# Disconnect and reconnect signals to avoid duplicates
	if $AnimatedSprite2D.is_connected("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished")):
		$AnimatedSprite2D.disconnect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))

	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))

func _physics_process(delta: float) -> void:
	# Reset horizontal movement
	velocity.x = 0  # Stop horizontal movement initially

	# Handle gravity
	if not is_on_floor():
		velocity.y += gravity * delta  # Apply gravity to the vertical velocity
	else:
		velocity.y = 0  # Reset vertical velocity when on the ground

	# Handle movement and attack
	if not is_attacking:
		player_move()  # Handle movement
		player_attack()  # Handle attacking

	# Move the player using move_and_slide
	move_and_slide()  # Apply movement

func player_move() -> void:
	# Handle horizontal movement
	if Input.is_action_pressed("left"):
		velocity.x = -speed  # Move left
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
	elif Input.is_action_pressed("right"):
		velocity.x = speed  # Move right
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

func player_attack() -> void:
	if Input.is_action_pressed("attacking") and not is_attacking:
		$AnimatedSprite2D.play("attack")  # Play attack animation
		is_attacking = true  # Set attacking state

		# Check if bush exists and is alive to deal damage
		if bush and bush.health > 0:
			bush.take_damage(1)  # Deal damage to the bush
		velocity.x = 0  # Stop horizontal movement during attack

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
