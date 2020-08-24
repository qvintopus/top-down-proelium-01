extends Node


# Worldy Things
const BUILDING_TYPE = {NONE = 0, HOUSE = 1, LUMBER_MILL = 2}
const RESOURCE_TYPE = {NONE = 0, WOOD = 1, STONE = 2, CHILD = 3}
const NATURELS_TYPE = {NONE = 0, TREE = 1, ROCK = 2}

# InWorldy Things
const TASK_TYPE = {
	NONE = 0
	,MOVE = { HIGH = 0, MIDDLE = 1, LOW = 2}
	,CHOP_WOOD = { HIGH = 0, MIDDLE = 1, LOW = 2}
	,BUILD_HOUSE = { HIGH = 0, MIDDLE = 1, LOW = 2}
}
const UNIT_TYPE = {NONE = 0, PEON = 1}

class Unit_Task:
	# IngameData.UNIT_TYPE
	var type:int
	# ToDo: validate if doable
	var isDoable:bool = true
	# task icon ?
	
	var required_unit:int
	var required_unit_count:int
	
	var location:Vector2 = Vector2.ZERO
	
	func _init(type, required_unit, required_unit_count, location):
		self.type = type
		self.required_unit = required_unit
		self.required_unit_count = required_unit_count
		self.location = location
		
	


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


