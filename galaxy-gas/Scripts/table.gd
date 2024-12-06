extends Node2D

var is_upgraded = false
var is_bought = false

@onready var small_chairs = $Small/Chairs.get_children()
@onready var big_chairs = $Large/topChairs.get_children() + ($Large/botChairs.get_children())
@onready var root = $"../.."

func _process(delta: float) -> void:
	check_ambience()

func buy_table():
	self.process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	is_bought = true
	$"../..".max_customers += 2

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
	
	await get_tree().create_timer(2).timeout

func is_full():
	if not is_upgraded:
		for chair in small_chairs:
			if not chair.is_taken:
				return false
		return true
	else:
		for chair in big_chairs:
			if not chair.is_taken:
				return false
		return true

func check_ambience():
	if root.ambience_level == 1:
		$Decorations/Plant1.visible = true
	elif root.ambience_level == 3:
		$Decorations/Plant1.visible = false
		$Decorations/Plant2.visible = true
