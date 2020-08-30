extends StaticBody2D
class_name Structure

signal child_created


var location:Vector2 = Vector2.ZERO
var TileMap:TileMap
# all maps should have a node where to add all of the buildings
var BuildingGroup:Node
var UnitGroup:Node

var structure_name:String = "none"

var occupants:Array = []
var child_unit

func _ready():
	TileMap = get_tree().get_nodes_in_group("TileMap")[0]
	BuildingGroup = get_tree().get_nodes_in_group("Buildings")[0]
	UnitGroup = get_tree().get_nodes_in_group("Units")[0]
	structure_name = self.name
	print("building has been placed: ", structure_name)
	child_unit = preload("res://Entities/Peon-02.tscn")

func place_structure(_location):
#	self.location = TileMap.world_to_map(position)
	self.position = _location

func enter_structure(unit_name):
	if !occupants.has(unit_name):
		occupants.append(unit_name)
		spawn_child()

func spawn_child():
	if occupants.size() > 1:
		var newborn = child_unit.instance()
		newborn.position = position
		UnitGroup.add_child(newborn)
		emit_signal("child_created")


