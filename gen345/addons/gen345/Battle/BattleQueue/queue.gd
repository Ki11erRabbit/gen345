class_name Queue extends Object


var list: ArrayList = ArrayList.new()

func push(value: Variant):
	list.push_back(value)

func sort(comparator: Callable = func(a, b):
		if a == b:
			return 0
		elif a < b:
			return -1
		else:
			return 1):
	list.sort(comparator)

func pop() -> Variant:
	return list.pop_front()

func for_each(body: Callable):
	list.for_each(body)

func is_empty() -> bool:
	return list.is_empty()
