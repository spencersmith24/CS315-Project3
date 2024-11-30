extends Node2D

var is_upgraded = false

var size = 1
var num_occupants = 0

func upgrade_room():
	$TopUnupgraded.process_mode = Node.PROCESS_MODE_DISABLED
	$TopUnupgraded.visible = false
	
	$TopUpgraded.process_mode = Node.PROCESS_MODE_DISABLED
	$TopUpgraded.visible = true
	is_upgraded = true
	size = 2
	$"../..".inn_capacity += 1

func is_full():
	if num_occupants == size:
		return true
	else:
		return false
