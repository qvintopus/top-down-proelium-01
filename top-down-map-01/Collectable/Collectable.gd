extends StaticBody2D

class_name Collectable


var maxHitpoints:int = 100
var hitpoints:int = maxHitpoints
var typeResource: = "wood"
var resourceQuantity:int = 1




func _ready():
	Stats.TotalResources += 1
	pass
	

func Damage():
	hitpoints -= 1
	if hitpoints <= 0:
		#kill me
		giveResource()

func giveResource():
	resourceQuantity -= 1
	Stats.get_resource(typeResource, 1)
	if resourceQuantity <= 0:
		queue_free()
