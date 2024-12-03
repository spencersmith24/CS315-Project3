extends Area2D

@export var is_taken = false
var customer_at_chair


func _on_body_entered(body):
	if body.is_in_group("Customers") and body == customer_at_chair:
		body.sit_in_chair()
