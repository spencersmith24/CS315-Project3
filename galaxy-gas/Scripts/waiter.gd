extends CharacterBody2D

@onready var root_node = get_parent()

@export var accel = 5
@export var speed = 200

@onready var anim_tree = $AnimationTree
@onready var anim_player = $AnimationPlayer

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var coins = []
var searching = true
var current_coin
var rng = RandomNumberGenerator.new()

func _process(_delta: float) -> void:
	if not coins.is_empty():
		find_coin()

# move characters around to find table to sit at
func _physics_process(delta: float) -> void:
	var direction = Vector2()
	var target_position
	
	if current_coin and not current_coin == null :
		print(current_coin)
		target_position = current_coin.global_position
	else:
		target_position = $"../Kitchen".global_position
	nav.set_target_position(target_position)
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	# flip sprite
	$Sprite2D.scale.x = 5 if velocity.x > 0 else -5 if velocity.x < 0 else $Sprite2D.scale.x
	
	if abs(velocity.x) > 0 and abs(velocity.x) > abs(velocity.y):
		anim_tree['parameters/conditions/walk_up'] = false
		anim_tree['parameters/conditions/walk_down'] = false
		anim_tree['parameters/conditions/walk_sideways'] = true
	elif velocity.y > 100 and abs(velocity.y) > abs(velocity.x):
		anim_tree['parameters/conditions/walk_sideways'] = false
		anim_tree['parameters/conditions/walk_up'] = false
		anim_tree['parameters/conditions/walk_down'] = true
	elif velocity.y < -100 and abs(velocity.y) > abs(velocity.x):
		anim_tree['parameters/conditions/walk_sideways'] = false
		anim_tree['parameters/conditions/walk_down'] = false
		anim_tree['parameters/conditions/walk_up'] = true
	
	move_and_slide()

func _ready() -> void:
	pass

func stand_still():
	speed = 0
	velocity = Vector2(0,0)

func reset_anim():
		anim_tree['parameters/conditions/walk_up'] = false
		anim_tree['parameters/conditions/walk_down'] = false
		anim_tree['parameters/conditions/walk_sideways'] = false

func find_coin():
	while searching:
		for coin in coins:
			searching = false
			current_coin = coin
