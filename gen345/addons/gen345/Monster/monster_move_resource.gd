class_name MonsterMoveResource extends Resource


enum TargetingType {
	## Targets a single nearby monster, friend or foe
	Single,
	## Targets only enemies
	Enemies,
	## Targets all nearby monsters, friend or foe
	Nearby,
	## Targets the user
	Self,
	## Targets only a friend
	Ally,
	## Targets the team
	Allies
}

## The localized reference for the name of the move
@export
var name: String

## The localized reference for the description of the move
@export
var description: String

## Who the move targets
@export
var target_type: TargetingType

## Determines which stat to use when attacking
@export
var stat_used: String

## If non-null, the name of the an override to attack with
@export
var attack_override: String

## The localizeable name reference to the type of the move
@export
var type: String

## The amount of base usages the move can perform
@export
var usages: int

## The power of the move
@export
var power: int

## The accuracy of the move
@export
var accuracy: int

## User definable attributes for the move
@export
var user_defined: Dictionary

## This is a set
## Describes the user defined effects a move will cause
@export
var effects: Dictionary

## Describes the user define effects that a move may cause.
## Key: Effect Name, Value: Chance to cause
@export
var side_effects: Dictionary

## The animation to load in
@export
var attack_animation: String
