class_name MonsterType extends Object
## The base class for monster class
## This exists to calculate the effectiveness of moves,
## As such, there should only need to be one of these for each type at any given time.

## Returns the effectiveness of the move against the enemy type
func effectiveness(type: MonsterType) -> float:
	return 1.0

## Returns the same type attack bonus
func bonus(type: MonsterType) -> float:
	return 1.0
