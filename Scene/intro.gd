extends Control

var player_name: String = ""
const banned_list: Array = [
  "shit", "pussy", "dick", "crap", "cunt", "asshole", "whore", "slut", "stupid", 
  "fuck", "gay", "moron", "lasbian", "trans", "crazy", "bitch", "/", "|", "[]", 
  "{}", "!", "@", "#", "$", "%", "^", "&", "*", "()", "-", "_", "+", "=", ":", 
  "'", ">", "<", "?", "~", "`", "bloody", "bastard", "bugger", "homeless", "bollocks", 
  "cyka", "blyat", "piss", "motherfucker", "ass", "breast", "penis", "wanker", 
  "bullshit", "fucker", "cum", "arse", "arsehead", "ass hole", "brotherfucker", 
  "child-fucker", "Christ on a bike", "Christ on a cracker", "cock", "cocksucker", 
  "dammit", "damn", "damned", "damn it", "dick-head", "dickhead", "dumb ass", 
  "dumb-ass", "dumbass", "dyke", "father-fucker", "fatherfucker", "fucking", 
  "god dammit", "god damn", "goddammit", "God damn", "goddamn", "Goddamn", 
  "goddamned", "goddamnit", "godsdamn", "hell", "holy shit", "horseshit", "in shit", 
  "jack-ass", "jackarse", "jackass", "Jesus Christ", "Jesus fuck", "Jesus H. Christ", 
  "Jesus Harold Christ", "Jesus, Mary and Joseph", "Jesus wept", "kike", 
  "mother fucker", "mother-fucker", "nigga", "nigra", "pigfucker", "prick", 
  "shit ass", "shite", "sibling fucker", "sisterfuck", "sisterfucker", "son of a bitch", 
  "son of a whore", "spastic", "sweet Jesus", "twat", "Pedophilia", "pedophile", "necrophilia", "puta"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var line_edit2 = get_node_or_null("LineEdit2")
	if line_edit2:
		line_edit2.text = ""  
		line_edit2.modulate = Color.WHITE  
		line_edit2.placeholder_text = ""  
	var line_edit = get_node_or_null("LineEdit") 
	if line_edit:
		line_edit.placeholder_text = "Type Name:"
		# Connect the focus_entered signal to the _on_line_edit_focus_entered method
		line_edit.connect("focus_entered", Callable(self, "_on_line_edit_focus_entered"))
		var menu_button = get_node_or_null("BoxContainer/MenuButton")
		if menu_button:
			menu_button.disconnect("pressed", Callable(self, "_on_menu_button_pressed"))
			menu_button.connect("pressed", Callable(self, "_on_menu_button_pressed"))

# Store the new name in a variable
func type_name(new_text: String) -> void:
	player_name = new_text
	var line_edit = get_node_or_null("LineEdit")
	if line_edit:
		line_edit.text = player_name
	print(player_name)

# Check for bad words
func is_input_valid(input: String) -> bool:
	if input.is_empty():
			return false
	input = input.to_lower()  # Convert to lowercase
	for word in banned_list:
		if input.find(word) != -1:
			return false
	for num in input:
		if num.is_valid_float():
			return false
		if input.length() <= 1:
			return false
	return true

# Check if player pressed enter key
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			print("Pressed ENTER")
			var line_edit = get_node_or_null("LineEdit")
			if line_edit:
				_on_line_edit_text_submitted(line_edit.text)

# Connects the signal when player enters a valid name
func _on_line_edit_text_submitted(new_text: String) -> void:
	var line_edit = get_node_or_null("LineEdit")
	var line_edit2 = get_node_or_null("LineEdit2")
	if line_edit:
		if is_input_valid(new_text):
			player_name = new_text
			print("Player name is: ", player_name)
			if line_edit2:
				line_edit2.modulate = Color.WHITE  # Reset color to white
				line_edit2.placeholder_text = ""  # Clear placeholder text
				$BoxContainer/MenuButton.disabled = false
		else:  # Invalid names
			if line_edit2:
				line_edit2.modulate = Color.RED  # Set color to red
				line_edit2.placeholder_text = "Please enter a valid name"
				$BoxContainer/MenuButton.disabled = true

# Reset the LineEdit2 appearance when it receives focus
func _on_line_edit_focus_entered() -> void:
	var line_edit2 = get_node_or_null("LineEdit2")
	if line_edit2:
		# Reset to default placeholder text and color
		line_edit2.modulate = Color.WHITE
		line_edit2.placeholder_text = ""  # Clear placeholder text

# switch scenes
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Level.tscn")
