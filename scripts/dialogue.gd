extends Control #dialogue

@onready var label = $Label
@onready var dog_script = $"../dog"
@onready var ui_script = $"../CanvasLayerUI"
@onready var correct_sound = $correct

var current_order := ""
var time_limit = 2.0
var current_time = 0.0
var turn_active = false

var orders = {
	"SIT!": "move_down",
	"JUMP!": "move_up",
	"WOOF!": "move_left",
	"POOP!": "move_right"
}

func _ready():
	randomize()
	new_order()

func _process(delta):
	if not turn_active:
		return
	current_time -= delta
	if current_time <= 0:
		print("Too slow!")
		turn_active = false
		game_punishment()
		return
	if current_order != "":
		var correct_action = orders[current_order]
		if Input.is_action_just_pressed(correct_action):
			print("Just in time!")
			correct_sound.play()
			turn_active = false
			next_order()
		elif Input.is_anything_pressed():
			print("Wrong key!")
			turn_active = false
			game_punishment()

func game_punishment():
	if dog_script:
		dog_script.play_confusion()
	var player_died = false
	if ui_script:
		player_died = ui_script.remove_life()
	if not player_died:
		next_order()

func new_order():
	var names = orders.keys()
	current_order = names[randi() % names.size()]
	label.text = "Simon says: " + current_order
	current_time = time_limit
	turn_active = true

func next_order():
	if not is_inside_tree(): return
	$".".visible = false
	await get_tree().create_timer(3.0).timeout 
	new_order()
	$".".visible = true
