extends Node2D

func upgrade_table():
	$Small.process_mode = Node.PROCESS_MODE_DISABLED
	$Small.visible = false
	
	$Large.process_mode = Node.PROCESS_MODE_DISABLED
	$Large.visible = true
	
	$"..".max_customers += 2
