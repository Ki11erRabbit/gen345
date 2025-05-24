class_name MonsterStatusEffect extends Object

var name: String

## Called before the move phase of battle
## [param monster_wrapper] is a [MonsterSlot]
func before_move_phase(monster_wrapper) -> void:
	pass

## Called before a monster makes a move
## Returns true if it shouldn't make the move, false if it can make the move
## This is to allow for status effects to alter move behavior
## [param monster_wrapper] is a [MonsterSlot]
func before_move(monster_wrapper) -> bool:
	return false

## Creates a queue item for the status effect queue
## Returns null if there doesn't need to be one
## [param monster_wrapper] is a [MonsterSlot]
func create_queue_item(monster_wrapper) -> QueueItem:
	return null

## Is called at the end of all turns
## This is to allow for effects that only last for short durations
## [param monster_wrapper] is a [MonsterSlot]
func end_round(monster_wrapper) -> void:
	pass

## This is called before a monster is hit
## the boolean determines whether or not the status effect blocks the move
func before_hit(move: MonsterMoveResource) -> bool:
	return false

## This is called after a monster is hit with [param afflicted] being the monster with the status and [param source] being the attacker
## [param afflicted] and [param source] are [MonsterSlot]
func after_hit(afflicted, source, move: MonsterMoveResource) -> void:
	pass

## This indicates whether or not the status effect can transfer along with a special switcho out
func can_transfer() -> bool:
	return false
