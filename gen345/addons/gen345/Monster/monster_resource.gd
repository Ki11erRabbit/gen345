class_name MonsterResource extends Resource

## This should the lookup name for localization purposess
@export
var name: String

## This should be the base stat
@export
var health_points: int

## This should be the base stat
@export
var attack: int

## This should be the base stat
@export
var defense: int

## This should be the base stat
@export
var special_attack: int

## This should be the base stat
@export
var special_defense: int

## This should be the base stat
@export
var speed: int

## This should be the base stat
## This should be used to provide additional stats for construction of monsters
@export
var user_defined: Dictionary

## This should be the category that determines a number of things:
## Needed xp for each level
## Stat Changes for each level
@export
var level_up_category: String

## The types for the monster
## This should be a localizable reference
@export
var types: Array[String]

## The moves that the monster can learn by leveling up
## This should be keyed by integers and values should be localizable references
@export
var level_up_moveset: Dictionary

## The front sprite to load.
## This should retrieve it from a singleton
@export
var front_sprite: String

## The back sprite to load.
## This should retrieve it from a singleton
@export
var back_sprite: String
