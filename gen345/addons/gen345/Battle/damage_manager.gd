extends Node

var damage_calculuator: DamageCalculator = null

var types: Dictionary = {}

var move_overrides: Dictionary = {}

func set_types(types: Dictionary) -> void:
	self.types = types

func set_damage_calculator(calculator: DamageCalculator) -> void:
	self.damage_calculuator = calculator

func set_move_overrides(overrides: Dictionary) -> void:
	self.move_overrides = overrides

## Calculates the amount of damage for the target to take
## This also calculates the effectiveness and bonus for the move before handing off control to the DamageCalculator
## If the move has an override, then that override is used instead of the global damage calculator
func calculate_damage(move: MonsterMove, user: MonsterWrapper, target: MonsterWrapper) -> int:
	assert(types.size() != 0, "Types haven't been loaded in yet")
	
	var move_type: String = move.get_type()
	
	# loop through the target's types to calculate the effectiveness
	var target_monster_types: Array[String] = target.get_types()
	var effectiveness: float = 1.0
	for type in target_monster_types:
		var move_monster_type: MonsterType = types.get(move_type)
		effectiveness *= move_monster_type.effectiveness(types.get(type))
	
	# loop through the user's types to calculate the bonus
	var user_monster_types: Array[String] = user.get_types()
	var bonus: float = 1.0
	for type in user_monster_types:
		var move_monster_type: MonsterType = types.get(move_type)
		bonus *= move_monster_type.bonus(types.get(type))
	
	# get override
	var override: String = move.get_override()
	if override != null:
		# use override if it exists
		var method: DamageCalculator = move_overrides.get(override)
		assert(method != null, "Override doesn't exist")
		return method.calculate(move, user, target, effectiveness, bonus)
	
	# otherwise, use the global damage calculator
	assert(damage_calculuator != null, "Damage Calculator Strategy not loaded in yet")
	return damage_calculuator.calculate(move, user, target, effectiveness, bonus)

## Method to use the global damage calculator if needed
func use_damage_calculator(move: MonsterMove, user: MonsterWrapper, target: MonsterWrapper, effectiveness: float, bonus: float) -> int:
	assert(damage_calculuator != null, "Damage Calculator Strategy not loaded in yet")
	return damage_calculuator.calculate(move, user, target, effectiveness, bonus)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



class DamageCalculator:
	## Helper class using the strategy pattern to define how to calculate damage from the move, user, target, effectiveness, and bonus
	
	func calculate(move: MonsterMove, user: MonsterWrapper, target: MonsterWrapper, effectiveness: float, bonus: float) -> int:
		return 0
