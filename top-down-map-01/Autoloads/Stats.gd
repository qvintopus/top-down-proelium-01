extends Node


var TotalResources:int = 0
var TotalRocks:int = 0
#var TotalStone:int = 0
var TotalTrees:int = 0
#var TotalWood:int = 0
var TotalHouses:int = 0
var TotalPopulation:int = 0

var resources: = {
	wood = 0,
	rock = 0
}



func get_resource(typeResource:String, amount):
	resources[typeResource] += amount




