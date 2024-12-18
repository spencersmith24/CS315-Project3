extends Area2D

@export var label: Resource

@export var click_value = 1

func _on_input_event(_viewport, event, _shape_idx):
	
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			play_arcade()
			get_parent().get_parent().get_node("Camera2D/sfx/play_arcade").play()

func play_arcade():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("jiggle")
	
	Globals.money_amt += click_value
	
	var new_label = label.instantiate()
	new_label.position = self.global_position
	new_label.get_node("Label").text = "$" + str(click_value)
	get_parent().add_child(new_label)
	
	await get_tree().create_timer(6).timeout
	new_label.queue_free()

func automate():
	$AutoTimer.start()

func _on_auto_timer_timeout() -> void:
	play_arcade()
