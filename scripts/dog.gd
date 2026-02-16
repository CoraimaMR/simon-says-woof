extends CharacterBody2D # DOG

@onready var sprite = $AnimatedSprite2D
@onready var woof_sound = $woof
@onready var pop_sound = $pop
@onready var boing_sound = $boing
@onready var incorrect_sound = $incorrect

var is_busy = false

func _process(_delta: float):
	if is_busy:
		return
	# ANIMATIONS
	if Input.is_action_pressed("move_up"):
		play_anim("jump",boing_sound)
	elif Input.is_action_pressed("move_down"):
		play_anim("sit")
	elif Input.is_action_pressed("move_left"):
		play_anim("bark",woof_sound)
	elif Input.is_action_pressed("move_right"):
		play_anim("poop",pop_sound)
	elif not sprite.is_playing():
		sprite.play("static")

func play_anim(anim_name, sound_node = null):
	is_busy = true
	sprite.play(anim_name)
	if not sound_node == null:
		sound_node.play()
	await sprite.animation_finished
	is_busy = false

func play_confusion():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			child.stop()
	incorrect_sound.play()
	sprite.play("dead")
	await get_tree().create_timer(1.0).timeout
