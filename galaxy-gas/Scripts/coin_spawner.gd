extends Node2D

@export var coin: Resource
@export var value_label: Resource

func spawn_coin(customer, amount):
	var new_coin = coin.instantiate()
	new_coin.worth = amount
	new_coin.position = customer.global_position
	new_coin.make_label(amount)
	
	$Coins.add_child(new_coin)
	
	# send the coin list data to the waiter
	Globals.coins = $Coins.get_children()
	
func show_label(label):
	
	$Labels.add_child(label)
	
	await get_tree().create_timer(6).timeout
	label.queue_free()
