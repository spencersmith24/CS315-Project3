extends Node2D

var is_upgraded = false

func upgrade_table():
	$Small.process_mode = Node.PROCESS_MODE_DISABLED
	$Small.visible = false
	
	$Large.process_mode = Node.PROCESS_MODE_DISABLED
	$Large.visible = true
	is_upgraded = true
	$"../..".max_customers += 2
