extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	process_mode = PROCESS_MODE_DISABLED
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_shop_btn_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/main.tscn")
	toggle_shop()

func toggle_shop():
	# Set visibility
	if visible:
		visible = false
	else:
		visible = true
	
	# Set process mode
	if process_mode == PROCESS_MODE_INHERIT:
		process_mode = PROCESS_MODE_DISABLED
	else:
		process_mode = PROCESS_MODE_INHERIT
