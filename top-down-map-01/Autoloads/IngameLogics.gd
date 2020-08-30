extends Node2D

signal TASKS_UPDATED

var CONSTANTS = IngameData.defaults



# god's helper tools ???
var godsSelectedBuilding:int = CONSTANTS.BUILDING_TYPE.HOUSE
var godInteractions:int = 0

# god queus tasks
# peons picks tasks up

var GOD_COMMANDS: = {
	WALK = 0,
	BUILD = 1,
	MAKE_CHILD = 2,
}
var god_command = GOD_COMMANDS.WALK

var BUILDINGS = Building_Manager.new(self)

var ALL_TASKS = Task_Manager2.new(self)

### [insert here some functioning joke]

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			var mouse_click = get_global_mouse_position()
			# ToDo:add logic for different click intentions - MOVE / BUILD / ???
			process_god(mouse_click)
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("select_walk"):
		god_command = GOD_COMMANDS.WALK
	elif event.is_action_pressed("select_build"):
		god_command = GOD_COMMANDS.BUILD
	elif event.is_action_pressed("select_make_child"):
		god_command = GOD_COMMANDS.MAKE_CHILD


func process_god(click_pos):
	match god_command:
		GOD_COMMANDS.WALK:
			godInteractions += 1
			var simple_task:IngameData.Task = ALL_TASKS.create_task(
				CONSTANTS.TASK_TYPE.MOVE
				,CONSTANTS.UNIT_TYPE.PEON
				,click_pos)
			ALL_TASKS.add_task(simple_task)
		GOD_COMMANDS.BUILD:
			godInteractions += 1
			# ? get position on the tilemap which tile god chose
			var house = BUILDINGS.get_building(CONSTANTS.BUILDING_TYPE.HOUSE)
			var simple_task:IngameData.Task = ALL_TASKS.create_task(
				CONSTANTS.TASK_TYPE.BUILD_HOUSE
				,CONSTANTS.UNIT_TYPE.PEON
				,click_pos, house)
			ALL_TASKS.add_task(simple_task)
		GOD_COMMANDS.MAKE_CHILD:
			godInteractions += 1
			# ? get position on the tilemap which tile god chose
			var house = BUILDINGS.get_building(CONSTANTS.BUILDING_TYPE.HOUSE, false)
			var simple_task:IngameData.Task = ALL_TASKS.create_task(
				CONSTANTS.TASK_TYPE.CREATE_CHILD
				,CONSTANTS.UNIT_TYPE.PEON
				,click_pos, house)
			ALL_TASKS.add_task(simple_task)
	
	pass




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


	func create_task(type, unit_type, location, building = null)->IngameData.Task:
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
			parent.CONSTANTS.TASK_TYPE.BUILD_HOUSE:
				print(task_id, " created - BUILD")
				
				var temp = parent.BUILDINGS.get_building(parent.CONSTANTS.BUILDING_TYPE.HOUSE)
				
				simple_task = IngameData.Task.new(
					task_id
					,type
					,parent.CONSTANTS.UNIT_TYPE.PEON
					,1
					,location
					,temp.instance()
				)
			parent.CONSTANTS.TASK_TYPE.CREATE_CHILD:
				print(task_id, " created - MAKE CHILD")
				
				if building != null: 
					simple_task = IngameData.Task.new(
						task_id
						,type
						,parent.CONSTANTS.UNIT_TYPE.PEON
						,2
						,building.position
						,building
					)
				else:
					# no building to make love in
					simple_task = null
		
		return simple_task

	
	func add_task(unit_task):
		manager[parent.CONSTANTS.TASK_STATUS.NEW].push_back(unit_task)
		#should change how this is done - meant to lessen future operations
		tasks[unit_task.name] = unit_task
		parent.emit_signal("TASKS_UPDATED")

	
	func get_task():
		# add get on unit type and quantity
		# should add lock?
		# ToDo: make sure task is always reffered
		
		var unit_task = manager[parent.CONSTANTS.TASK_STATUS.BLOCKED].pop_front()
		if unit_task == null: # no blocked tasks
			unit_task = manager[parent.CONSTANTS.TASK_STATUS.NEW].pop_front()
			if unit_task == null:
				return unit_task
				
			# check task requirements
			if unit_task.required_unit_count <= 1:
				manager[parent.CONSTANTS.TASK_STATUS.IN_PROGRESS].push_back(unit_task)
			else: # requires multiple units
				unit_task.pending_unit_count += 1
				manager[parent.CONSTANTS.TASK_STATUS.BLOCKED].push_back(unit_task)
		elif unit_task.required_unit_count - unit_task.pending_unit_count <= 1:
			# there's a blocker that needs to be prioritized
			unit_task.pending_unit_count += 1
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
		
		# additional actions for managing buildings
		if unit_task.type == parent.CONSTANTS.TASK_TYPE.BUILD_HOUSE:
			parent.BUILDINGS.add_building(unit_task.building)

	
	func _init(parent):
		self.parent = parent



# built for the purpose of handling all things building related - maybe later will be more general
class Building_Manager:
	var parent
	var house_01:IngameData.Building
	var house_02
	var lumber_01:IngameData.Building
	
	var ALL_BUILDINGS:Dictionary = {}
	
	# returns building of type BUILDING_TYPE
	func get_building(type, fetchNew:bool = true):
		if fetchNew:
			match type:
				parent.CONSTANTS.BUILDING_TYPE.HOUSE:
					return house_02
				parent.CONSTANTS.BUILDING_TYPE.LUMBER_MILL:
					return lumber_01
		else:
			return ALL_BUILDINGS.values().front()
#			var temp = ALL_BUILDINGS.keys().front()
#			if temp != null:
#				return ALL_BUILDINGS[temp]
#			else:
#				return null

	func add_building(_structure):
		ALL_BUILDINGS[_structure.name] = _structure

	func _init(parent):
		self.parent = parent
		
		house_02 = preload("res://Buildings/House-01.tscn")
		
#		house_01 = IngameData.Building.new(
#			parent.CONSTANTS.BUILDING_TYPE.HOUSE
#			,preload("res://Assets/Structures/medievalStructure_18.png")
#			,parent.CONSTANTS.RESOURCE_TYPE.CHILD
#			,1
#			,parent.CONSTANTS.RESOURCE_TYPE.NONE
#			,0
#		)
#		lumber_01 = IngameData.Building.new(
#			parent.CONSTANTS.BUILDING_TYPE.LUMBER_MILL
#			,preload("res://Assets/Structures/medievalStructure_17.png")
#			,parent.CONSTANTS.RESOURCE_TYPE.WOOD
#			,1
#			,parent.CONSTANTS.RESOURCE_TYPE.NONE
#			,0
#		)
	

