extends Node2D

var is_upgraded = false
var is_bought = false

@onready var small_chairs = $Small/Chairs.get_children()
@onready var big_chairs = $Large/topChairs.get_children() + ($Large/botChairs.get_children())
@onready var root = $"../.."

func _process(_delta: float) -> void:
	check_ambience()

func buy_table():
	self.process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	is_bought = true
	$"../..".max_customers += 2
	check_ambience()

func upgrade_table():
	for chair in small_chairs:
		if chair.is_taken:
			chair.customer_at_chair.leave()
	
	$Small.process_mode = Node.PROCESS_MODE_DISABLED
	$Small.visible = false
	$Large.process_mode = Node.PROCESS_MODE_INHERIT
	$Large.visible = true
	
	is_upgraded = true
	root.max_customers += 2
	check_ambience()
	
	await get_tree().create_timer(2).timeout

func is_full():
	var chairs = small_chairs if not is_upgraded else big_chairs
	
	for chair in chairs:
		if not chair.is_taken:
			return false
	
	return true


func check_ambience():
	if root.ambience_level > 0:
		$Decorations/Plant1.visible = true
	elif root.ambience_level > 2:
		$Decorations/Plant1.visible = false
		$Decorations/Plant2.visible = true
