extends State
class_name UnitState

var unit: KinematicBody2D

func _init(_sm).(_sm)->void:	#inheriting script needs to call .(argument) from inherited scripts
	unit = sm.owner			#to make easier referencing later  for player methods and nodes

