extends Node

@onready var player = $".."
@onready var animated_sprite_2d = $"../AnimatedSprite2D"

func _process(_delta):
	if (
		not animated_sprite_2d.animation in ["attack_1", "attack_2", "attack_3", "attack_4"]
	):
		if Input.is_action_just_pressed("attack"):
			match player.attack_state:
				0: animated_sprite_2d.play("attack_1")
				1: animated_sprite_2d.play("attack_2")
				2: animated_sprite_2d.play("attack_3")
				3: animated_sprite_2d.play("attack_4")

		if not player.is_falling:
			if Input.is_action_pressed(player.input_left):
				if player.is_on_floor():
					animated_sprite_2d.play("run")
				animated_sprite_2d.set("flip_h", true)
			
			if Input.is_action_pressed(player.input_right):
				if player.is_on_floor():
					animated_sprite_2d.play("run")
				animated_sprite_2d.set("flip_h", false)

			if Input.is_action_just_pressed("jump"):
				play_and_pause("jump", 0, 3)

		if (
			(animated_sprite_2d.get_animation() == "jump"
			and animated_sprite_2d.animation_finished)
			or player.velocity.y > 0
		):
			animated_sprite_2d.play("fall")
			
		if (
				player.is_on_floor()
				and (animated_sprite_2d.get_animation() == "fall"
				or animated_sprite_2d.get_animation() == "jump")
		):
			animated_sprite_2d.play("land")
			
		if (
				not Input.is_action_pressed(player.input_left)
				and not Input.is_action_pressed(player.input_right)
				and player.is_on_floor()
		):
			animated_sprite_2d.play("idle")
		
		if not player._was_on_ground and player.is_feet_on_ground(): 
			animated_sprite_2d.play("land")

func play_and_pause(animation: String, start_frame: int, end_frame: int):
	animated_sprite_2d.animation = animation
	animated_sprite_2d.set_frame(start_frame)
	if not start_frame == end_frame:
		play_and_pause(animation, start_frame + 1, end_frame)
