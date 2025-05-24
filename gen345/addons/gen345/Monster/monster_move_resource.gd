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

enum MoveType {
	Attack,
	Healing,
	StatusAfflict,
	StatusClear,
	StatChange
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

## Determines what the move should do
@export
var move_type: MoveType

## When [member move_type] is set to Attack, this is used to look up the stat to use or the override if set
## This dictionary should contain the keys StatUsed and Override which should have string values
@export
var attack_data: Dictionary

## When [member move_type] is set to Heal, this is used to determine how to heal
## When the float is less than 1.0 then the healing will be calculated as a percentage of max health
## When the float is 1.0 or greater, healing is calculated upto the percentage of max health
@export
var heal_data: float

## When [member move_type] is set to StatusAfflict, this is used to determine what status effects to afflict onto the target.
## This is different from [member effects].
@export
var status_afflict_data: Array[String]

## When [member move_type] is set to StatusClear, this is used to determine what status effects should be cleared from the target.
@export
var status_clear_data: Array[String]

## When [member move_type] is set to StatChange, this is used to determine what stats are raised and lowered and by how much
## The structure should be like this:
##[codeblock]
##{
##    "Raise": { "attack": 1 },
##    "Lower": { "defense": 1 },
##}
##[/codeblock]
@export
var stat_change_data: Dictionary

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


## Describes the user defined effects a move will cause
@export
var effects: Array[String]

## Describes the user define effects that a move may cause.
## Key: Effect Name, Value: Chance to cause
@export
var side_effects: Dictionary

## The animation to load in
@export
var attack_animation: String
