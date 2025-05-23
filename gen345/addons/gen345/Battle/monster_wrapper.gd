class_name MonsterWrapper extends Object

## The concrete Monster being wrapped
var monster: Monster

## The change in the monster's stat
## It is up to the user to determine what this means
var attack_stat_changes: int = 0

## The change in the monster's stat
## It is up to the user to determine what this means
var defense_stat_changes: int = 0

## The change in the monster's stat
## It is up to the user to determine what this means
var special_attack_stat_changes: int = 0

## The change in the monster's stat
## It is up to the user to determine what this means
var special_defense_stat_changes: int = 0

## The change in the monster's stat
## It is up to the user to determine what this means
var speed_stat_changes: int = 0

## The change in the monster's stat
## It is up to the user to determine what this means
var accuracy_stat_changes: int = 0

## The change in the monster's stat
## It is up to the user to determine what this means
var evasion_stat_changes: int = 0

## The change in the monster's user defined stats
## It is up to the user to determine what this means
var user_stat_changes: Dictionary = {}

## The current battle only status effects aflicting the monster
## It is up to the user to determine what this means
var user_status_effects: Array[MonsterStatusEffect] = []

func get_types() -> Array[String]:
	return monster.resource.types

func get_status_effect_queue_items() -> Array[QueueItem]:
	var list: ArrayList = ArrayList.new()
	for effect: MonsterStatusEffect in monster.status_effects:
		var item = effect.create_queue_item(monster)
		if item != null:
			list.push_back(item)
	for effect: MonsterStatusEffect in user_status_effects:
		var item = effect.create_queue_item(monster)
		if item != null:
			list.push_back(item)
	
	return list.get_array()

## Goes through every status effect on the monster
func status_effects_before_move() -> bool:
	var return_value = false
	for effect: MonsterStatusEffect in monster.status_effects:
		if effect.before_move(monster):
			return_value = true
	for effect: MonsterStatusEffect in user_status_effects:
		if effect.before_move(monster):
			return_value = true
	return return_value

func status_effects_before_move_phase(logic: Variant) -> void:
	for effect: MonsterStatusEffect in monster.status_effects:
		effect.before_move_phase(self, logic)
	for effect: MonsterStatusEffect in user_status_effects:
		effect.before_move_phase(self, logic)
