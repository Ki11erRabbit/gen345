class_name MoveQueueItem extends QueueItem

var user: MonsterSlot

var targets: Array[MonsterSlot]

var move: MonsterMoveSlot

func process_item():
	
	if user.status_effects_before_move():
		return
	
	for target: MonsterSlot in targets:
		if target.status_effects_before_hit(move.monster_move.resource):
			continue
		
		
		target.status_effects_after_hit(user, move.monster_move.resource)
		
	pass
