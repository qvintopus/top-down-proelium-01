extends Node

var defaults = {
	BUILDING_TYPE = { NONE = 0, HOUSE = 1, LUMBER_MILL = 2 },
	RESOURCE_TYPE = { NONE = 0, WOOD = 1, STONE = 2, CHILD = 3 },
	NATURELS_TYPE = { NONE = 0, TREE = 1, ROCK = 2 },
	TASK_TYPE = {
		NONE = { NONEXISTANT = 0 }
		,MOVE = { WALKING = 0, RUNNING = 1 }
		,CHOP_WOOD = { CHOP = 0 }
		,BUILD_HOUSE = { BUILD = 0 }
		,CREATE_CHILD = { SMALL_CHILD = 0 }
	},
	TASK_STATUS = { NEW = "NEW", BLOCKED = "BLOCKED", IN_PROGRESS = "IN_PROGRESS", DONE = "DONE", FAILED = "FAILED" },
	UNIT_TYPE = { NONE = 0, PEON = 1 }
}


class Task:
	# what this task should have and not have?
	# task should have the basic information on what's required, whilst task-manager would manage it's status and external managment
	# more?

	var name:String = "none"
	var unit_name:String = "none"

	# IngameData.TASK_TYPE - should be able to compare with the sub-dictionary reference comparisons - make sure only that will happen 
	var type:Dictionary
	
	
	var required_unit:int
	var required_unit_count:int
	var pending_unit_count:int = 0
	var building
	
	# most tasks should be pinpointed to a location
	var location:Vector2 = Vector2.ZERO
	var area_size:int = 100
	var repetitions:int = 1
	
	# ToDo: implement comments / log from units

	func _init(name, type, required_unit, required_unit_count, location, building = null):
		self.name = name
		self.type = type
		self.required_unit = required_unit
		self.required_unit_count = required_unit_count
		self.location = location
		self.building = building
		
	

class Building:
	# IngameData.BUILDING_TYPE
	var type:int
	
	# building texture
	var icon_texture:Texture
	
	# resource the building produces
	var resource_produces:int
	var resource_produces_amount:int
	
	# resource the building needs to be maintained
	var resource_upkeep:int
	var resource_upkeep_amount:int
	
	func _init(type, iconTexture, prodResource, prodResourceAmount, upkeepResource, upkeepResourceAmount):
		self.type = type
		self.icon_texture = iconTexture
		self.resource_produces = prodResource
		self.resource_produces_amount = prodResourceAmount
		self.resource_upkeep = upkeepResource
		self.resource_upkeep_amount = upkeepResourceAmount


