extends KinematicBody2D
class_name Unit


var CONSTANTS = IngameData.defaults # global constants
var ALL_TASKS = IngameLogics.ALL_TASKS # access to global task list

export (bool) var DEBUG_MODE = true
export (float) var speed = 5.0 * 60.0


var targetPosition:Vector2 = Vector2.ZERO # unit's moving location
var path: PoolVector2Array
var Nav: Navigation2D
var velocity: = Vector2.ZERO

var curState = CONSTANTS.TASK_TYPE.NONE
var curTask:IngameData.Task = null
var isBusy:bool = false
var jobAge:int = 0

onready var sm: = $UnitStateMachine
onready var IdleBuffer:Timer = $IdleBuffer





func _ready():
	Nav = get_tree().get_nodes_in_group("Navigation")[0]
#	line2D.set_as_toplevel(true)
	print("unit has 'woken: ", self.name)


func process(delta):
	pass
#	to_live_i_must(!isBusy)


#func physics_process(delta):
##	match curState:
##		CONSTANTS.TASK_TYPE.NONE:
##			#do nothing
##			pass
##		CONSTANTS.TASK_TYPE.MOVE:
###			print("click")
##			unit_move(delta)
##	if DEBUG_MODE:
##		update()
#
#func _draw():
#	if DEBUG_MODE:
#		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.black)


func check_task()->IngameData.Task:
	var simple_task:IngameData.Task = ALL_TASKS.get_task()
	return simple_task


func do_task(the_task:IngameData.Task):
	isBusy = true
	# do the thang
	
	if the_task.type == CONSTANTS.TASK_TYPE.MOVE:
#		curState = CONSTANTS.TASK_TYPE.MOVE
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
		ALL_TASKS.update_task(curTask.name, CONSTANTS.TASK_STATUS.DONE)
		isBusy = false # should not be here
		sm.state.state_check()
		


func get_target_path(_targetPos):
	targetPosition = _targetPos
	path = Nav.get_simple_path(global_position, targetPosition, false)



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
#		var perception = get_tree().get_nodes_in_group("Perception")[0]
#		perception.points
		var POI:Vector2 = global_position
		var offset = 300
		POI.x += rand_range(-offset,offset)
		POI.y += rand_range(-offset,offset)
#		state = TASK_TYPE.MOVE.HIGH
#		get_target_path(POI)
		var temp_task = ALL_TASKS.create_task(
			CONSTANTS.TASK_TYPE.MOVE
			,CONSTANTS.UNIT_TYPE.PEON
			,POI)
		ALL_TASKS.add_task(temp_task)
#		isBusy = true
	
	if simple_task != null:
		curTask = simple_task
		do_task(simple_task)
	
	




















