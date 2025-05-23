class_name MonsterMove extends Object

var resource: MonsterMoveResource

var remaining_usages: int


func get_type() -> String:
	return resource.type

func get_override() -> String:
	return resource.attack_override
