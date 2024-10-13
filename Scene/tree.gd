extends AnimatedSprite2D

# Variables for health and healing
var max_health: int = 10
var health: float = max_health / 2.0  # Start with half health

# Healing settings
var heal_rate: float = 1.0  # Health regeneration per second
var heal_cooldown: float = 2.0  # Time without damage before healing starts
var time_since_last_hit: float = 0.0  # Timer to manage healing

# Position offsets for alignment
var tree_offset_y: float = -16  # Adjust this based on the size difference
var bush_offset_y: float = 0

@onready var collision_shape = $Area2D/CollisionShape2D

func _ready():
	update_animation()
	print("Initial Health: ", health)  # Print initial health

func _process(delta: float):
	time_since_last_hit += delta  # Increment the timer

	# Health regeneration logic
	if time_since_last_hit >= heal_cooldown:
		if health < max_health:
			health += heal_rate * delta  # Regenerate health
			health = min(health, max_health)  # Clamp health

			if health > max_health / 2.0:  # Only print if health is growing
				print("Health increasing: ", health)

			# Transform to tree if health reaches max
			if health >= max_health:
				transform_to_tree()
		
		# Separate logic for bush regeneration
		if health < 1:
			# If health is below 1, the bush is considered destroyed but can still regenerate
			health += heal_rate * delta  # Continue to regenerate health
			print("Bush regenerating health: ", health)
			if health >= 1:  # Check for health reaching or exceeding 1
				transform_to_bush()  # Transform back to bush when health is above 0

	update_animation()

# Detect damage from the player
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):  # Check if the body is the player
		body.connect("attack", self, "_on_player_attack")  # Connect player's attack signal

func _on_player_attack(damage: int):
	take_damage(damage)

func take_damage(damage: int):
	health -= damage
	health = max(health, 0)
	print("Health after damage: ", health)  # Print health after taking damage

	# Reset the healing timer whenever the bush takes damage
	time_since_last_hit = 0.0  

	if health <= 0:
		print("Bush destroyed!")  # Print when destroyed
		health = 0  # Set health to 0 to indicate it's destroyed
		visible = false  # Hide the bush when destroyed
	else:
		update_animation()  # Update animation after taking damage

func update_animation():
	if health < max_health and health > 0:
		play("bush")
		position.y = bush_offset_y  # Align bush on the ground
	elif health >= max_health:
		play("tree")
		position.y = tree_offset_y  # Align tree on the ground

func transform_to_tree():
	health = max_health  # Ensure health is full
	visible = true  # Ensure the tree is visible
	update_animation()
	print("Transformed to Tree! Health: ", health)  # Print when transformed

func transform_to_bush():
	health = 1  # Set health to 1 to indicate it's alive again
	visible = true  # Ensure the bush is visible again
	update_animation()
	print("Transformed back to Bush! Health: ", health)  # Print when transformed back
