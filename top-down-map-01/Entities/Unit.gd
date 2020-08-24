extends KinematicBody2D

class_name Unit

# moves to target
# job list of actions with priorities
# 

const DEBUG_MODE:bool = true

const TASK_TYPE = IngameData.TASK_TYPE
var UNIT_TASKS = IngameLogics.UNIT_TASKS
var GOD_TASKS = IngameLogics.GOD_TASKS

enum {IDLE, MOVE, HARVEST_WOOD, GATHER, PATROL}

var targetPosition:Vector2 = Vector2.ZERO
var speed:float = 5 *60
var path: PoolVector2Array
var state = TASK_TYPE.NONE
var Nav: Navigation2D
var velocity: = Vector2.ZERO
var line2D:Line2D

var isBusy:bool = false
var jobAge:int = 0
var isAlive:bool = true
var curTask:String = "none"


func _ready():
	Nav = get_tree().get_nodes_in_group("Navigation")[0]
	line2D = $Line2D
	line2D.set_as_toplevel(true)
#	check_tasks()
	# would be nice to also store unit names somewhere - like if ants had names..
	print("unit has 'woken: ", self.name)
#	the_endless_loop()
#	set_process(true)

func _process(delta):
	#check available tasks
	#prep appropriate actions
	#init prepped actions
	if !isBusy:
		to_live_i_must(!isBusy)
#		check_tasks()
	pass

func _physics_process(delta):
	match state:
		TASK_TYPE.MOVE.HIGH:
#			print("click")
			state_move(delta)
	if DEBUG_MODE:
		update()

func _draw():
	if DEBUG_MODE:
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.black)
		

func perform(the_task:IngameData.Unit_Task):
	isBusy = true
	# do the thang
	
	if the_task.type == TASK_TYPE.MOVE.HIGH:
		state = TASK_TYPE.MOVE.HIGH
		get_target_path(the_task.location)
		
		
#	isBusy = false
	


func state_move(delta: float):
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
				state = TASK_TYPE.NONE
				isBusy = false # should not be here
				GOD_TASKS.close_task(curTask)
			else:
				path.remove(0)
	

func get_target_path(_targetPos):
	targetPosition = _targetPos
	path = Nav.get_simple_path(global_position, targetPosition, false)
	if DEBUG_MODE:
		line2D.points = path


func check_tasks():
	var task = IngameLogics.GOD_TASKS.get_task()
	print("task: ", task)
	if task == null:
		print("disabling task")
		yield(IngameLogics, "TASKS_UPDATED")
		print("task: ", task)
		task = IngameLogics.GOD_TASKS.get_task()
		
		# ToDo: process task appropriatly
		state = TASK_TYPE.MOVE.HIGH
		get_target_path(task.location)
		isBusy = true


func the_endless_loop():
	jobAge += 1
	
	# ToDo: think of a way to get rid of the while loop
	while isAlive:
		to_live_i_must(isBusy)
	
	# here goes the dying process - "do the flop"
	

# meant as the moment when introspectively decide on "okay.. but what now?"
func to_live_i_must(really:bool = true):
	if !really:
		print(self.name, " says - naaa, next time")
		return
	# check if willing to do something again
	# check if something urgent for self to pickup
	# check if something required to be done
	# decide on priorities
	# perform action
	# something else calls this function again
	
	var simple_task:IngameData.Unit_Task
	
	# ToDo: create thing where THIS unit can check what self.wants
	simple_task = IngameLogics.GOD_TASKS.get_task()
	if simple_task == null:
		simple_task = IngameLogics.UNIT_TASKS.get_task()
		
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
		curTask = GOD_TASKS.create_task(IngameData.TASK_TYPE.MOVE.HIGH, POI)
#		isBusy = true
	
	simple_task = IngameLogics.GOD_TASKS.get_task()
#	print("isBusy: ", isBusy)
	
	perform(simple_task)




















