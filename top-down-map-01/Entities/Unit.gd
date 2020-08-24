extends KinematicBody2D

class_name Unit

# moves to target
# job list of actions with priorities
# 

const DEBUG_MODE:bool = true

enum {IDLE, MOVE, HARVEST_WOOD, GATHER, PATROL}

var targetPosition:Vector2 = Vector2.ZERO
var speed:float = 5 *60
var path: PoolVector2Array
var state: = IDLE
var Nav: Navigation2D
var velocity: = Vector2.ZERO
var line2D:Line2D

var inTheBusiness:bool = false




func _ready():
	Nav = get_tree().get_nodes_in_group("Navigation")[0]
	line2D = $Line2D
	line2D.set_as_toplevel(true)
#	check_tasks()
	

func _process(delta):
	#check available tasks
	#prep appropriate actions
	#init prepped actions
	if !inTheBusiness:
		check_tasks()
	pass

func _physics_process(delta):
	# find target
	# move to target
	match state:
		MOVE:
#			print("click")
			state_move(delta)
	if DEBUG_MODE:
		update()

func _draw():
	if DEBUG_MODE:
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.black)
		

func check_tasks():
	var task = IngameLogics.GOD_TASKS.get_task()
	print("task: ", task)
	if task == null:
		print("disabling task")
		yield(IngameLogics, "TASKS_UPDATED")
		print("task: ", task)
		task = IngameLogics.GOD_TASKS.get_task()
		
		# ToDo: process task appropriatly
		state = MOVE
		get_target_path(task.location)
		inTheBusiness = true
		

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
				state = IDLE
			else:
				path.remove(0)
	

func get_target_path(_targetPos):
	targetPosition = _targetPos
	path = Nav.get_simple_path(global_position, targetPosition, false)
	if DEBUG_MODE:
		line2D.points = path


#func _unhandled_input(event):
#	if event is InputEventMouseButton and event.is_pressed():
#		if event.button_index == 1:
#			state = MOVE
#			get_target_path(get_global_mouse_position())



func to_live_i_must():
	pass
	# check if willing to do something again
	# check if something urgent for self to pickup
	# check if something required to be done
	# 




















