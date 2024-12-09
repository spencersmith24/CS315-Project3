extends Control

@export_multiline var label_text: String

func _ready() -> void:
	$TextureRect.size = $".".size

func _process(delta: float) -> void:
	$Label.text = label_text
