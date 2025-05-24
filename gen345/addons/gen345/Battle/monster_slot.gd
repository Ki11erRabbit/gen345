class_name MonsterSlot extends Object

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
var user_status_effects: ArrayList = ArrayList.new()

## If this is non-empty, then the monster in this slot is has these types
var type_override: ArrayList = ArrayList.new()

var last_move: MonsterMoveResource = null

## causes the monster in the slot to take damage.
## Returns whether or not the monster fainted
func take_damage(damage: int) -> bool:
	monster.current_health -= damage
	if monster.current_health <= 0:
		monster.current_health = 0
		return true
	return false

## The amount of the max health to heal
func heal_amount(percentage: float) -> void:
	var max_health = monster.resource.health_points
	var healing_amount = int(floor(max_health * percentage))
	monster.current_health += healing_amount
	if monster.current_health > max_health:
		monster.current_health = max_health

## The amount that the monster should be healed to
func heal_limit(percentage: float) -> void:
	var max_health = monster.resource.health_points
	var healing_amount = int(floor(max_health * percentage))
	monster.current_health = healing_amount

func change_stat(stat: String, amount: int, upper_limit: int, lower_limit: int) -> void:
	match stat:
		"attack":
			attack_stat_changes += amount
			if attack_stat_changes < lower_limit:
				attack_stat_changes = lower_limit
			elif attack_stat_changes > upper_limit:
				attack_stat_changes = upper_limit
		"defense":
			defense_stat_changes += amount
			if defense_stat_changes < lower_limit:
				defense_stat_changes = lower_limit
			elif defense_stat_changes > upper_limit:
				defense_stat_changes = upper_limit
		"special_attack":
			special_attack_stat_changes += amount
			if special_attack_stat_changes < lower_limit:
				special_attack_stat_changes = lower_limit
			elif special_attack_stat_changes > upper_limit:
				special_attack_stat_changes = upper_limit
		"special_defense":
			special_defense_stat_changes += amount
			if special_defense_stat_changes < lower_limit:
				special_defense_stat_changes = lower_limit
			elif special_defense_stat_changes > upper_limit:
				special_defense_stat_changes = upper_limit
		"speed":
			speed_stat_changes += amount
			if speed_stat_changes < lower_limit:
				speed_stat_changes = lower_limit
			elif speed_stat_changes > upper_limit:
				speed_stat_changes = upper_limit
		"accuracy":
			accuracy_stat_changes += amount
			if accuracy_stat_changes < lower_limit:
				accuracy_stat_changes = lower_limit
			elif accuracy_stat_changes > upper_limit:
				accuracy_stat_changes = upper_limit
		"evasion":
			evasion_stat_changes += amount
			if evasion_stat_changes < lower_limit:
				evasion_stat_changes = lower_limit
			elif evasion_stat_changes > upper_limit:
				evasion_stat_changes = upper_limit
		var x:
			user_stat_changes.set(x, user_stat_changes.get(x) + amount)
			if user_stat_changes.get(x) < lower_limit:
				user_stat_changes.set(x, lower_limit)
			elif user_stat_changes.get(x) > upper_limit:
				user_stat_changes.set(x, upper_limit)

func clear_status_effect(effect_name: String) -> void:
	var indices = ArrayList.new()
	var index: int = 0
	monster.status_effects.for_each(func(effect: MonsterStatusEffect):
		if effect.name == effect_name:
			indices.push_back(index)
		index += 1)
		

func switch_with_reset(monster: Monster) -> void:
	attack_stat_changes = 0
	defense_stat_changes = 0
	special_attack_stat_changes = 0
	special_defense_stat_changes = 0
	speed_stat_changes = 0
	accuracy_stat_changes = 0
	evasion_stat_changes = 0
	user_stat_changes = {}
	user_status_effects.clear()
	type_override.clear()
	self.monster = monster

func switch_no_reset(monster: Monster) -> void:
	var carry_over_effects = ArrayList.new()
	user_status_effects.for_each(func(effect: MonsterStatusEffect):
		if effect.can_transfer():
			carry_over_effects.push_back(effect))
	user_status_effects = carry_over_effects
	type_override.clear()
	self.monster = monster

func get_types() -> Array[String]:
	if type_override.size() == 0:
		return monster.resource.types
	return type_override.get_array()

func get_status_effect_queue_items() -> Array[QueueItem]:
	var list: ArrayList = ArrayList.new()
	for effect: MonsterStatusEffect in monster.status_effects:
		var item = effect.create_queue_item(monster)
		if item != null:
			list.push_back(item)
	user_status_effects.for_each(func(effect: MonsterStatusEffect):
		var item = effect.create_queue_item(monster)
		if item != null:
			list.push_back(item))
	
	return list.get_array()

## Goes through every status effect on the monster
func status_effects_before_move() -> bool:
	var return_value = false
	for effect: MonsterStatusEffect in monster.status_effects:
		if effect.before_move(monster):
			return_value = true
	user_status_effects.for_each(func(effect: MonsterStatusEffect):
		if effect.before_move(monster):
			return_value = true)
	return return_value

func status_effects_before_move_phase() -> void:
	for effect: MonsterStatusEffect in monster.status_effects:
		effect.before_move_phase(self)
	user_status_effects.for_each(func(effect: MonsterStatusEffect):
		effect.before_move_phase(self))

func status_effects_end_round() -> void:
	for effect: MonsterStatusEffect in monster.status_effects:
		effect.end_round(self)
	user_status_effects.for_each(func(effect: MonsterStatusEffect):
		effect.end_round(self))

## This is called before a monster is hit
## the boolean determines whether or not the status effect blocks the move
func status_effects_before_hit(move: MonsterMoveResource) -> bool:
	var return_value = false
	for effect: MonsterStatusEffect in monster.status_effects:
		if effect.before_hit(move):
			return_value = true
	user_status_effects.for_each(func(effect: MonsterStatusEffect):
		if effect.before_hit(move):
			return_value = true)
	return return_value

## This is called before a monster is hit
## the boolean determines whether or not the status effect blocks the move
func status_effects_after_hit(source: MonsterSlot, move: MonsterMoveResource) -> void:
	for effect: MonsterStatusEffect in monster.status_effects:
		effect.after_hit(self, source, move)
	user_status_effects.for_each(func(effect: MonsterStatusEffect):
		effect.after_hit(self, source, move))
