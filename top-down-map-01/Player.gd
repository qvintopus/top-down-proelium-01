extends Node2D




var direction:Vector2 = Vector2.ZERO
var speed:float = 10 *60




func _process(delta):
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	position += direction * speed * delta


