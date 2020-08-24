extends Node2D

signal TASKS_UPDATED

# god's helper tools ???
var godsSelectedBuilding:int = IngameData.BUILDING_TYPE.HOUSE

# god queus tasks
# peons picks tasks up
const TASK_TYPE = IngameData.TASK_TYPE

var GOD_TASKS = Task_Manager.new(self)
var UNIT_TASKS = Task_Manager.new(self)
var BUILDINGS = Building_Manager.new()



### [insert here some functioning joke]

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			var mouse_click = get_global_mouse_position()
			# ToDo:add logic for different click intentions - MOVE / BUILD / ???
			var simple_task:IngameData.Unit_Task = IngameData.Unit_Task.new(IngameData.TASK_TYPE.MOVE.HIGH, IngameData.UNIT_TYPE.PEON, 1, mouse_click)
			GOD_TASKS.add_task(simple_task)
			
			





### CLASSIC LOGIC, phhh..

# built for the purpose managing overall task flow within unit groups and god-to-units
class Task_Manager:
	var parent
	var completed_tasks:Dictionary = {}
	var completed_tasks_amount:int = 0
	var queued_tasks:Dictionary = {} setget add_task, get_task
	
	func add_task(unit_task)->String:
		completed_tasks_amount += 1
		var task_id = "task-" + str(completed_tasks_amount)
		if completed_tasks.has(task_id) || queued_tasks.has(task_id):
			return "failed to add"
		else:
#			var unit_task:IngameData.Unit_Task = IngameData.Unit_Task.new(type, required_unit, required_unit_count, location)
			queued_tasks[task_id] = unit_task
		
		# send signal "task updated"
		parent.emit_signal("TASKS_UPDATED")
		print(task_id, " type: ", unit_task.type)
		return task_id
		
		
	func create_task(type, location)->String:
		if type == parent.TASK_TYPE.MOVE.HIGH:
			var simple_task:IngameData.Unit_Task = IngameData.Unit_Task.new(type, IngameData.UNIT_TYPE.PEON, 1, location)
			return self.add_task(simple_task)
		return "failed to create"
	
	func get_task():
		#should add lock
		if queued_tasks.size() > 0:
			print("get task: ", queued_tasks.keys()[0])
			return queued_tasks[queued_tasks.keys()[0]]
		return null
		
	func close_task(task_id:String):
		completed_tasks[task_id] = queued_tasks[task_id]
		completed_tasks_amount += 1
		queued_tasks.erase(task_id)
		
	
	func _init(parent):
		self.parent = parent

# built for the purpose of handling all things building related - maybe later will be more general
class Building_Manager:
	var house_01:IngameData.Building = IngameData.Building.new(IngameData.BUILDING_TYPE.HOUSE, preload("res://Assets/Structures/medievalStructure_18.png"), IngameData.RESOURCE_TYPE.CHILD, 1, IngameData.RESOURCE_TYPE.NONE, 0) setget get_building
	var lumber_01:IngameData.Building = IngameData.Building.new(IngameData.BUILDING_TYPE.LUMBER_MILL, preload("res://Assets/Structures/medievalStructure_17.png"), IngameData.RESOURCE_TYPE.WOOD, 1, IngameData.RESOURCE_TYPE.NONE, 0) setget get_building
	
	# returns building of type BUILDING_TYPE
	func get_building(type):
		match type:
			IngameData.BUILDING_TYPE.HOUSE:
				return house_01
			IngameData.BUILDING_TYPE.LUMBER_MILL:
				return lumber_01


