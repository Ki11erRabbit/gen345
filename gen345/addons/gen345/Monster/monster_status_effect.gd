class_name MonsterStatusEffect extends Object

## Called before the move phase of battle
## [param monster_wrapper] is a [MonsterWrapper]
## [param logic] is used to provide the logic for what should happen when this method is called.
## TODO: change logic to be an abstract class
func before_move_phase(monster_wrapper, logic: Variant) -> void:
	pass

## Called before a monster makes a move
## Returns true if it shouldn't make the move, false if it can make the move
## This is to allow for status effects to alter
func before_move(monster: Monster) -> bool:
	return false

## Creates a queue item for the status effect queue
## Returns null if there doesn't need to be one
func create_queue_item(monster: Monster) -> QueueItem:
	return null
