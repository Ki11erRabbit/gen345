class_name Monster extends Object

## The link back to the resource for the monster
var resource: MonsterResource

## A custom name for the monster if it exists
var custom_name: String

## the current health of the monster
var current_health: int

## the current level of the monster
var current_level: int

## The current exp of the monster
var current_exp: int

## A list of all currently active status effects
var status_effects: ArrayList

## A list of all currently available moves for battle
var current_moves: Array[MonsterMoveSlot]

## A dictionary that represents the items, armor, weapons a monster could be using
## The key is the slot name and the value is the thing
var gear: Dictionary

## A dictionary holding the user defined attributes that are specific to this monster
var user_defined: Dictionary
