extends UnitState
class_name UnitBuild

# helper to disabled state_check on every frame
var check_enabled:bool = true

func _init(_sm).(_sm)->void:
	name = "Build"

func enter(_msg:Dictionary = {})->void:
	unit.do_task(unit.curTask)

func exit()->void:
	pass

func unhandled_input(event:InputEvent)->void:
	pass

func physics_process(delta:float)->void:
	unit.unit_move(delta)

func process(delta:float)->void:
#	state_check()
	pass

func state_check()->void:
	unit.curTask = unit.check_task()
	if unit.curTask == null:
		#transition goes here
		sm.transition_to("Idle")
	else:
		unit.do_task(unit.curTask)
	
	check_enabled = false
	yield(sm.get_tree().create_timer(1.0), "timeout")
	check_enabled = true
	
