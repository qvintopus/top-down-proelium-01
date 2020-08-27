extends Node2D

signal TASKS_UPDATED

var CONSTANTS = IngameData.defaults



# god's helper tools ???
var godsSelectedBuilding:int = CONSTANTS.BUILDING_TYPE.HOUSE
var godInteractions:int = 0

# god queus tasks
# peons picks tasks up



var BUILDINGS = Building_Manager.new(self)

var ALL_TASKS = Task_Manager2.new(self)

### [insert here some functioning joke]

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			var mouse_click = get_global_mouse_position()
			# ToDo:add logic for different click intentions - MOVE / BUILD / ???
			godInteractions += 1
			var simple_task:IngameData.Task = ALL_TASKS.create_task(
				CONSTANTS.TASK_TYPE.MOVE
				,CONSTANTS.UNIT_TYPE.PEON
				,mouse_click)
			ALL_TASKS.add_task(simple_task)
			
			



### CLASSIC LOGIC, phhh..

# built for the purpose managing overall task flow within unit groups and god-to-units
class Task_Manager2:
	# what task manager should do?
	# hold all tasks
	# manage task statuses
	# gather task statistics
	# 
	
	var parent

	var task_amount:int = 0
	var completed_tasks_amount:int = 0
	# task-id : task
	var tasks:Dictionary = {} #setget add_task, get_task
	# manage task statuses (status : [task_id, task_id, task_id ] ???)
	var manager:Dictionary = {"NEW" : [], "BLOCKED" : [], "IN_PROGRESS" : [], "DONE" : [], "FAILED" : [] }


	func create_task(type, unit_type, location)->IngameData.Task:
		# create name
		# get task type
		# get required unit type
		# set location
		# ??? what else for other types

		task_amount += 1
		var task_id = "task-" + str(task_amount)
		var simple_task:IngameData.Task

		match type:
			parent.CONSTANTS.TASK_TYPE.MOVE:
				print(task_id, " created - MOVE")
				simple_task = IngameData.Task.new(
					task_id
					,type
					,parent.CONSTANTS.UNIT_TYPE.PEON
					,1
					,location
				)
		
		return simple_task

	
	func add_task(unit_task):
		manager[parent.CONSTANTS.TASK_STATUS.NEW].push_back(unit_task)
		parent.emit_signal("TASKS_UPDATED")
		#should change how this is done - meant to lessen future operations
		tasks[unit_task.name] = unit_task

	
	func get_task():
		# add get on unit type and quantity
		# should add lock?
		# ToDo: make sure task is always reffered
		var unit_task = manager[parent.CONSTANTS.TASK_STATUS.NEW].pop_front()
		manager[parent.CONSTANTS.TASK_STATUS.NEW].erase(unit_task)
		manager[parent.CONSTANTS.TASK_STATUS.IN_PROGRESS].push_back(unit_task)
		return unit_task
		


	func update_task(task_id, status):
		var unit_task = tasks[task_id]
		match status:
			parent.CONSTANTS.TASK_STATUS.DONE:
				manager[parent.CONSTANTS.TASK_STATUS.IN_PROGRESS].erase(unit_task)
				manager[parent.CONSTANTS.TASK_STATUS.DONE].push_back(unit_task)

			parent.CONSTANTS.TASK_STATUS.FAILED:
				manager[parent.CONSTANTS.TASK_STATUS.IN_PROGRESS].erase(unit_task)
				manager[parent.CONSTANTS.TASK_STATUS.FAILED].push_back(unit_task)

	
	func _init(parent):
		self.parent = parent



# built for the purpose of handling all things building related - maybe later will be more general
class Building_Manager:
	var parent
	var house_01:IngameData.Building
	var lumber_01:IngameData.Building
	
	# returns building of type BUILDING_TYPE
	func get_building(type):
		match type:
			parent.CONSTANTS.BUILDING_TYPE.HOUSE:
				return house_01
			parent.CONSTANTS.BUILDING_TYPE.LUMBER_MILL:
				return lumber_01

	func _init(parent):
		self.parent = parent
		house_01 = IngameData.Building.new(
			parent.CONSTANTS.BUILDING_TYPE.HOUSE
			,preload("res://Assets/Structures/medievalStructure_18.png")
			,parent.CONSTANTS.RESOURCE_TYPE.CHILD
			,1
			,parent.CONSTANTS.RESOURCE_TYPE.NONE
			,0
		)
		lumber_01 = IngameData.Building.new(
			parent.CONSTANTS.BUILDING_TYPE.LUMBER_MILL
			,preload("res://Assets/Structures/medievalStructure_17.png")
			,parent.CONSTANTS.RESOURCE_TYPE.WOOD
			,1
			,parent.CONSTANTS.RESOURCE_TYPE.NONE
			,0
		)
	

