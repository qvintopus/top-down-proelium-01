extends UnitState
class_name UnitIdle

# helper to disabled state_check on every frame
var check_enabled:bool = true


func _init(_sm).(_sm)->void:					#inheriting script needs to call .(argument) from inherited scripts
	name = "Idle"

func enter(_msg:Dictionary = {})->void:			#Called by StateMachine when transition_to("State")
	pass

func exit()->void:
	pass

func unhandled_input(event:InputEvent)->void:
	pass

func physics_process(delta:float)->void:
	pass

func process(delta:float)->void:
	if check_enabled:
		state_check()								#call check method if state need to be changed

func state_check()->void:
	unit.curTask = unit.check_task()
	if unit.curTask != null:
		#transition goes here
		sm.transition_to("Walk")
		pass
	
	check_enabled = false
	yield(sm.get_tree().create_timer(1.0), "timeout")
	check_enabled = true

