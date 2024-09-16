extends Sprite2D

var speed = 50
var is_moving = false
var is_attacking = false

func _ready() -> void:
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))
	

func _process(_delta: float) -> void:
	if not is_attacking:
		player_move()
		player_attack()

# move player on X axis left and right
func player_move():
	is_moving = false

	if Input.is_action_pressed("left"):
		position.x -= speed
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		is_moving = true
	elif Input.is_action_pressed("right"):
		position.x += speed
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		is_moving = true

	# play idle when player not moving
	if not is_moving and not is_attacking:
		$AnimatedSprite2D.play("idle")

# player attack input
func player_attack():
	if Input.is_action_pressed("attack") and not is_attacking:
		$AnimatedSprite2D.play("attack")
		is_attacking = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false;
