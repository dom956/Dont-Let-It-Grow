extends AnimatedSprite2D

# Health and healing variables
var max_health: int = 10
var health: float = max_health / 2.0  # Start with half health
var heal_rate: float = 1.0  
var heal_cooldown: float = 2.0  # Time without damage before healing starts
var time_since_last_hit: float = 0.0  # Timer for healing starts at 0
var is_regenerating: bool = false  

# Position offsets
var tree_offset_y: float = -1224
var bush_offset_y: float = 711

@onready var collision_shape = $Area2D/CollisionShape2D

# bush State tracking
var is_visible: bool = true  

func _ready():
	update_animation()
	print("Initial Health: ", health)

func _process(delta: float):
	time_since_last_hit += delta

	# Start regeneration if cooldown has passed
	if time_since_last_hit >= heal_cooldown and health < max_health:
		regenerate_health(delta)

	update_animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.connect("attack", self, "_on_player_attack")

func _on_player_attack(damage: int):
	take_damage(damage)

func take_damage(damage: int):
	# Prevent glitches by stopping regeneration on damage
	if is_regenerating:
		is_regenerating = false  # Ensure regen stops during damage
	
	health -= damage
	health = max(health, 0)
	print("Health after damage: ", health)

	time_since_last_hit = 0.0  # Reset the regen timer

	if health <= 0:
		hide_bush()  

func regenerate_health(delta: float):
	if not is_regenerating:
		print("Starting health regeneration...")
		is_regenerating = true  

	health += heal_rate * delta
	health = min(health, max_health)
	print("Bush regenerating health: ", health)

	if health >= 1 and not is_visible:
		show_bush()  

	if health >= max_health:
		transform_to_tree()

func hide_bush():
	print("Bush destroyed")
	is_visible = false
	visible = false  

func show_bush():
	print("Bush regenerating")
	is_visible = true
	visible = true  

func transform_to_tree():
	print("Transformed to Tree! Health: ", max_health)
	health = max_health 
	is_visible = true  
	is_regenerating = false  
	update_animation()

func update_animation():
	if health >= 1 and health < max_health:
		play("bush")
		position.y = bush_offset_y
	elif health >= max_health:
		play("tree")
		position.y = tree_offset_y
