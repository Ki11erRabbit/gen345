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
var user_status_effects: Array = []

func get_types() -> Array[String]:
	return monster.resource.types
