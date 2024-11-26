extends Node2D

var is_upgraded = false

func upgrade_room():
	$TopUnupgraded.process_mode = Node.PROCESS_MODE_DISABLED
	$TopUnupgraded.visible = false
	
	$TopUpgraded.process_mode = Node.PROCESS_MODE_DISABLED
	$TopUpgraded.visible = true
	is_upgraded = true
	$"../..".inn_capacity += 1
