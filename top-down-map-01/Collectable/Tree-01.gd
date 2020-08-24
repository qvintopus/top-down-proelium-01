extends Collectable


func _ready():
	._ready()
	typeResource = "wood"
	Stats.TotalTrees += 1
	

func _exit_tree():
	Stats.TotalTrees -= 1







