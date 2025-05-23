class_name BattleQueue extends Node

var switch_queue: Queue = Queue.new()

var item_queue: Queue = Queue.new()

var rotation_queue: Queue = Queue.new()

var transformation_queue: Queue = Queue.new()

var move_queue: Queue = Queue.new()

var status_effect_queue: Queue = Queue.new()

var weather: QueueItem = null

## Process one element in the queue at a time.
func process_queue_item():
	if not switch_queue.is_empty():
		var item: QueueItem = switch_queue.pop()
		item.process_item()
		return
	
	if not item_queue.is_empty():
		var item: QueueItem = item_queue.pop()
		item.process_item()
		return
	
	if not rotation_queue.is_empty():
		var item: QueueItem = rotation_queue.pop()
		item.process_item()
		return
	
	if not transformation_queue.is_empty():
		var item: QueueItem = transformation_queue.pop()
		item.process_item()
		return
	
	if not move_queue.is_empty():
		var item: QueueItem = move_queue.pop()
		item.process_item()
		return
	
	if not status_effect_queue.is_empty():
		var item: QueueItem = status_effect_queue.pop()
		item.process_item()
		return
	
	if weather != null:
		weather.process_item()
		weather = null

func before_move_phase() -> bool:
	return switch_queue.is_empty() and item_queue.is_empty() and rotation_queue.is_empty() and transformation_queue.is_empty()

func battle_phase_done() -> bool:
	return switch_queue.is_empty() and item_queue.is_empty() and rotation_queue.is_empty() and transformation_queue.is_empty() and move_queue.is_empty()

func end_of_turn_phase_done() -> bool:
	return status_effect_queue.is_empty() and weather == null

func is_empty() -> bool:
	return switch_queue.is_empty() and item_queue.is_empty() and rotation_queue.is_empty() and transformation_queue.is_empty() and move_queue.is_empty() and status_effect_queue.is_empty() and weather == null

func tweak_queue(queue_tweaker: QueueTweaker):
	queue_tweaker.tweak(switch_queue, item_queue, rotation_queue, transformation_queue, move_queue, status_effect_queue)

func add_to_switch_queue(item: QueueItem):
	switch_queue.push(item)

func add_to_item_queue(item: QueueItem):
	item_queue.push(item)

func add_to_rotation_queue(item: QueueItem):
	rotation_queue.push(item)

func add_to_transformation_queue(item: QueueItem):
	transformation_queue.push(item)

func add_to_move_queue(item: QueueItem):
	move_queue.push(item)

## [param comparator] should return 0 for equal, -1 for less than, and 1 for greater than
func sort_move_queue(comparator: Callable):
	move_queue.sort(comparator)

func add_to_status_effect_queue(item: QueueItem):
	status_effect_queue.push(item)

func set_weather(item: QueueItem):
	weather = item

class QueueTweaker:
	func tweak(switch_queue: Queue, item_queue: Queue, rotation_queue: Queue, transformation_queue: Queue, move_queue: Queue, status_effect_queue: Queue):
		pass
