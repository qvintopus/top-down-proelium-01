extends KinematicBody2D
class_name Unit


var CONSTANTS = IngameData.defaults # global constants
var ALL_TASKS = IngameLogics.ALL_TASKS # access to global task list


export (bool) var DEBUG_MODE = true
export (float) var speed = 5.0 * 60.0


var targetPosition:Vector2 = Vector2.ZERO # unit's moving location
var path: PoolVector2Array
var Nav: Navigation2D
var TileMap: TileMap
var BuildingGroup:Node
var velocity: = Vector2.ZERO

var curTask:IngameData.Task = null
var isBusy:bool = false
var jobAge:int = 0
var unitName:String = "none"

onready var sm: = $UnitStateMachine
onready var IdleBuffer:Timer = $IdleBuffer





func _ready():
	Nav = get_tree().get_nodes_in_group("Navigation")[0]
	TileMap = get_tree().get_nodes_in_group("TileMap")[0]
	BuildingGroup = get_tree().get_nodes_in_group("Buildings")[0]
#	line2D.set_as_toplevel(true)
	unitName = self.name
	print("unit has 'woken: ", unitName)


func process(delta):
	pass
#	to_live_i_must(!isBusy)


func check_task()->IngameData.Task:
	var simple_task:IngameData.Task = ALL_TASKS.get_task()
	return simple_task


func do_task(the_task:IngameData.Task):
	isBusy = true
	# do the thang
	curTask = the_task
	
	if the_task.type == CONSTANTS.TASK_TYPE.MOVE:
		get_target_path(the_task.location)
	elif the_task.type == CONSTANTS.TASK_TYPE.BUILD_HOUSE:
		get_target_path(the_task.location)
	elif the_task.type == CONSTANTS.TASK_TYPE.CREATE_CHILD:
		get_target_path(the_task.location)


func unit_move(delta: float):
	if path.size() > 0:
		var d: float = position.distance_to(path[0])
		if d > speed * delta:
			var dir: Vector2 = (path[0] - position).normalized()
			velocity = dir * speed
			move_and_slide(velocity)
		else:
			if path.size() == 1:
				velocity = (path[0] - position) / delta
				move_and_slide(velocity)
				path.remove(0)
			else:
				path.remove(0)
	else:
#		print(unitName, curTask.type)
		#should always enter in the below, if doesn't - worth investigating - be honest
		if curTask.type == CONSTANTS.TASK_TYPE.MOVE:
			print(unitName, ": done moving")
			ALL_TASKS.update_task(curTask.name, CONSTANTS.TASK_STATUS.DONE)
			isBusy = false # should not be here
			sm.state.state_check()
		elif curTask.type == CONSTANTS.TASK_TYPE.BUILD_HOUSE:
			self.place_building()
		elif curTask.type == CONSTANTS.TASK_TYPE.CREATE_CHILD:
			self.make_child()


func get_target_path(_targetPos):
	targetPosition = _targetPos
	path = Nav.get_simple_path(global_position, targetPosition, false)


func place_building():
	# use the building from task to place
	# then update building location and task
	var tile_pos = TileMap.world_to_map(position)
#	print(unitName, ": starting build at: ", tile_pos)
	var tile_center = TileMap.map_to_world(tile_pos) + (TileMap.cell_size * 0.5)
	
	curTask.building.place_structure(tile_center)
	BuildingGroup.add_child(curTask.building)
	
	ALL_TASKS.update_task(curTask.name, CONSTANTS.TASK_STATUS.DONE)
	isBusy = false # should not be here
	sm.state.state_check()


func make_child():
	# check if another unit is in this tile with same task ?? for now do simpler
	# spawn new unit
	curTask.building.enter_structure(unitName)
	# wait for signal
	yield(curTask.building, "child_created")
	if curTask != null:
		ALL_TASKS.update_task(curTask.name, CONSTANTS.TASK_STATUS.DONE)
	isBusy = false # should not be here
	sm.state.state_check()


# meant as the moment when introspectively decide on "okay.. but what now?"
func to_live_i_must(really:bool = false):
	if !really:
#		print(self.name, " says - naaa, next time")
		return
	# check if willing to do something again
	# check if something urgent for self to pickup
	# check if something required to be done
	# decide on priorities
	# perform action
	# something else calls this function again
	
	var simple_task:IngameData.Task
	
	# ToDo: create thing where THIS unit can check what self.wants
	simple_task = ALL_TASKS.get_task()
	if simple_task == null:
		# create PATROL type of activity
		var POI:Vector2 = global_position
		var offset = 300
		POI.x += rand_range(-offset,offset)
		POI.y += rand_range(-offset,offset)
		var temp_task = ALL_TASKS.create_task(
			CONSTANTS.TASK_TYPE.MOVE
			,CONSTANTS.UNIT_TYPE.PEON
			,POI)
		ALL_TASKS.add_task(temp_task)
	
	if simple_task != null:
		curTask = simple_task
		do_task(simple_task)
	
	



















