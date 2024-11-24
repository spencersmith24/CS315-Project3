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


# upgrade tables
func _on_table_1_button_pressed() -> void:
	$"../Table1".upgrade_table()
	$Control/Table1Button.process_mode = Node.PROCESS_MODE_DISABLED


func _on_table_2_button_pressed() -> void:
	$"../Table2".upgrade_table()
	$Control/Table2Button.process_mode = Node.PROCESS_MODE_DISABLED


func _on_table_3_button_pressed() -> void:
	$"../Table3".upgrade_table()
	$Control/Table3Button.process_mode = Node.PROCESS_MODE_DISABLED


func _on_table_4_button_pressed() -> void:
	$"../Table4".upgrade_table()
	$Control/Table4Button.process_mode = Node.PROCESS_MODE_DISABLED
