extends Area2D

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			$AnimationPlayer.play("RESET")
			$AnimationPlayer.play("jiggle")
			
			Globals.root_node.money_amt += 1
