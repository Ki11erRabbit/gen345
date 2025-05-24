extends Node

var damage_calculuator: DamageCalculator = null
var status_applier: StatusApplier = null

var types: Dictionary = {}

var move_overrides: Dictionary = {}

var status_effects: Dictionary = {}

func set_types(types: Dictionary) -> void:
	self.types = types

func set_damage_calculator(calculator: DamageCalculator) -> void:
	self.damage_calculuator = calculator

func set_move_overrides(overrides: Dictionary) -> void:
	self.move_overrides = overrides

func set_status_applier(applier: StatusApplier) -> void:
	self.status_applier = applier

func process_move(move: MonsterMoveSlot, user: MonsterSlot, target: MonsterSlot) -> void:
	match move.monster_move.resource.move_type:
		MonsterMoveResource.MoveType.Attack:
			var damage: int = calculate_damage(move, user, target)
			target.take_damage(damage)
		MonsterMoveResource.MoveType.Healing:
			var healing: float = move.monster_move.resource.heal_data
			if healing >= 1.0:
				healing /= 100
				target.heal_limit(healing)
			else:
				target.heal_amount(healing)
		MonsterMoveResource.MoveType.StatusAfflict:
			for effect_name: String in move.monster_move.resource.status_afflict_data:
				assert(status_effects.get(effect_name) != null, "Effect does not exist")
				apply_status_effect(effect_name, target)
		MonsterMoveResource.MoveType.StatusClear:
			for effect_name: String in move.monster_move.resource.status_clear_data:
				assert(status_effects.get(effect_name) != null, "Effect does not exist")
				target.clear_status(effect_name)
		MonsterMoveResource.MoveType.StatChange:
			pass


## Calculates the amount of damage for the target to take
## This also calculates the effectiveness and bonus for the move before handing off control to the DamageCalculator
## If the move has an override, then that override is used instead of the global damage calculator
func calculate_damage(move: MonsterMoveSlot, user: MonsterSlot, target: MonsterSlot) -> int:
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
func use_damage_calculator(move: MonsterMoveSlot, user: MonsterSlot, target: MonsterSlot, effectiveness: float, bonus: float) -> int:
	assert(damage_calculuator != null, "Damage Calculator Strategy not loaded in yet")
	return damage_calculuator.calculate(move, user, target, effectiveness, bonus)

class DamageCalculator:
	## Helper class using the strategy pattern to define how to calculate damage from the move, user, target, effectiveness, and bonus
	
	func calculate(move: MonsterMoveSlot, user: MonsterSlot, target: MonsterSlot, effectiveness: float, bonus: float) -> int:
		return 0


func apply_status_effect(effect_name: String, monster_wrapper: MonsterSlot) -> void:
	var effect = status_effects.get(effect_name)
	assert(effect != null, "Status effect was not found")
	assert(status_applier != null, "Status Applier has not been set")
	status_applier.apply_status_effect(effect, monster_wrapper)

class StatusApplier:
	func apply_status_effect(effect: MonsterStatusEffect, monster_wrapper: MonsterSlot) -> void:
		pass
