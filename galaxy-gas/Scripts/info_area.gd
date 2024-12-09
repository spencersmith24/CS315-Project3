extends Area2D

@export var info_box: Node
@onready var anim_player = info_box.get_node("AnimationPlayer")


func _on_mouse_entered() -> void:
	anim_player.play("slide_in")


func _on_mouse_exited() -> void:
	anim_player.play("slide_out")
