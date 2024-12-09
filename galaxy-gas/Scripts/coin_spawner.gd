extends Node2D

@export var coin: Resource
@export var value_label: Resource

func spawn_coin(customer, amount):
	var new_coin = coin.instantiate()
	new_coin.worth = amount
	new_coin.position = customer.global_position
	#new_coin.make_label(int(amount * new_coin.multiplier + 0.5))
	if customer.staying:
		new_coin.upstairs = true
		Globals.upstairs_coins.append(new_coin)
	else:
		Globals.downstairs_coins.append(new_coin)
	
	$Coins.add_child(new_coin)
	
func show_label(label):
	
	$Labels.add_child(label)
	
	await get_tree().create_timer(6).timeout
	label.queue_free()
