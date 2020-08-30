extends Node2D




var direction:Vector2 = Vector2.ZERO
var speed:float = 10 *60
onready var tileset = $"../TileMap"


func _process(delta):
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	position += direction * speed * delta








#
#func _on_TileMap_ready():
#
##	set_process_input(true)
##	start()
#	pass # Replace with function body.
#
#func _input(event):
#
#	var tile_pos = tileset.world_to_map(event.position)
#	print("tile: ", tile_pos)
