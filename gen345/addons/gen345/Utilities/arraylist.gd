class_name ArrayListGD extends Object

var array = [0]
var length = 0
var capacity: int :
	get():
		return self.array.size()
var growth_factor: float = 2.0

static func from_array(array: Array, growth_factor: float = 2.0) -> ArrayListGD:
	var instance = ArrayListGD.new()
	instance.array = array
	instance.length = array.size()
	instance.growth_factor = growth_factor
	return instance

static func with_capacity(capacity: int, growth_factor: float = 2.0) -> ArrayListGD:
	var array = []
	array.resize(capacity)
	return ArrayListGD.from_array(array, growth_factor)

## Creates a new [ArrayList] with a [param size] as its length filled with [param value]
## Due to how GDScrpit passes objects around, it is perferable to use [method ArrayList.fill_func] instead for filling an [ArrayList] with objects.
static func fill(size: int, value: Variant, growth_factor: float = 2.0) -> ArrayListGD:
	var array = []
	array.resize(size)
	for i in range(0, size):
		array[i] = value
	return ArrayListGD.from_array(array, growth_factor)

## Works similar to [method ArrayList.fill] but uses a function [param f] that takes an index and returns the value to place at that index.
## If you are trying to fill an [ArrayList] with objects, then this is the constructor to use.
static func fill_func(size: int, f: Callable, growth_factor: float = 2.0) -> ArrayListGD:
	var array = []
	array.resize(size)
	for i in range(0, size):
		array[i] = f.call(i)
	return ArrayListGD.from_array(array, growth_factor)

func grow():
	var size = int(ceil(self.capacity * self.growth_factor))
	self.array.resize(size)

func grow_if_needed(needed_size: int = 0):
	if length == capacity or (capacity - length) < needed_size:
		grow()


func all(method: Callable) -> bool:
	var accum = true
	for i in range(0, self.length):
		accum = accum and self.array[i]
		if not accum:
			return accum
	return accum

func any(method: Callable) -> bool:
	var accum = false
	for i in range(0, self.length):
		accum = accum or self.array[i]
		if accum:
			return accum
	return accum

func append(value: Variant):
	grow_if_needed()
	self.array[length] = value
	self.length += 1

func append_array(array: Array):
	grow_if_needed(array.size())
	for i in range(0, array.size()):
		self.array[self.length + i] = array[i]
	self.length += array.size() - 1

func back() -> Variant:
	assert(length > 0, "ArrayList empty")
	return self.array[length - 1]

func front() -> Variant:
	assert(length > 0, "ArrayList empty")
	return self.array[0]

func bsearch(value: Variant, before: bool = true) -> int:
	return self.bsearch_custom(value, func(av, v):
		if av == v:
			return 0
		elif av > v:
			return 1
		else: 
			return -1, before)

## [param f] should take in two elements, the array element and the [param value] and returns -1 if the [param value] is less than, 0 if equal, and 1 if greater than
func bsearch_custom(value: Variant, f: Callable, before: bool = true) -> int:
	var low: int = 0
	var high: int = self.length
	var mid = 0
	
	while low <= high:
		mid = low + (high - low) / 2
		if f.call(self.array[mid], value) == 0:
			if not before:
				while f.call(self.array[mid], value) == 0:
					mid += 1
			return mid
		
		if f.call(self.array[mid], value) == -1:
			low = mid + 1
		
		if f.call(self.array[mid], value) == 1:
			high = mid -1
		
	return mid

func clear():
	for i in range(0, self.length):
		self.array[i] = 0
	self.length = 0

func count(value: Variant) -> int:
	var counter: int = 0
	for i in range(0, self.length):
		if self.array[i] == value:
			counter += 1
	return counter

func duplicate(deep: bool = false) -> ArrayListGD:
	return ArrayListGD.from_array(self.array.duplicate(deep), self.growth_factor)

func erase(value: Variant):
	for i in range(0, self.length):
		if self.array[i] == value:
			for j in range(i + 1, self.length):
				self.array[j - 1] = self.array[j]
			self.length -= 1

## [param method] should return true if it should be included in the new [ArrayList] or false if it should be excluded.
func filter(method: Callable) -> ArrayListGD:
	var out = ArrayListGD.new()
	
	for i in range(0, self.length):
		if method.call(self.array[i]):
			out.append(self.array[i])
	
	return out

## [param from] controls the start index
## returns -1 if it cannot find the item
func find(what: Variant, from: int = 0) -> int:
	for i in range(from, self.length):
		if what == self.array[i]:
			return i
	
	return -1

## [param method] should return true if it is the first item we are looking from
## [param from] controls the start index
## returns -1 if it cannot find the item
func find_custom(method: Callable, from: int = 0) -> int:
	for i in range(from, self.length):
		if method.call(self.array[i]):
			return i
	
	return -1

## Returns the element at the given [param index] in the ArrayList.
func at(index: int) -> Variant:
	assert(index < length, "Index out of bounds")
	return array[index]

func has(value: Variant) -> bool:
	for i in range(0, length):
		if array[i] == value:
			return true
	
	return false

func insert(position: int, value: Variant):
	assert(position <= length, "Index out of bounds")
	grow_if_needed(1)
	var position_is_zero: bool = false
	
	# range can't have the second argument be 0 because it is exclusive
	if position == 0:
		position = -1
		position_is_zero = true
	for i in range(length, position, -1):
		array[i + 1] = array[i]
	
	if position_is_zero:
		array[0] = value
	else:
		array[position] = value

func is_empty() -> bool:
	return length == 0

func map(method: Callable) -> ArrayListGD:
	return ArrayListGD.fill_func(self.length, func(i):
		return method.call(self.array[i]))

func max() -> Variant:
	var max = null
	for i in range(length):
		if max == null:
			max = array[i]
		elif max < array[i]:
			max = array[i]
	return max

func min() -> Variant:
	var max = null
	for i in range(length):
		if max == null:
			max = array[i]
		elif max > array[i]:
			max = array[i]
	return max

func pick_random() -> Variant:
	var index = randi_range(0, length)
	return array[index]

## negative [param position] means relative to end of array
## if empty, returns null
func pop_at(position: int) -> Variant:
	assert(position < length, "Index out of bounds")
	if is_empty():
		return null
	
	if position < 0:
		position = length + position
		
	var item = array[position]
	
	for i in range(length, position, -1):
		var fill = 0
		if i < array.size():
			fill = array[i]
		array[i] = fill
	
	return item

func pop_back() -> Variant:
	var out = array[array.size() - 1]
	array[array.size() - 1] = 0
	return 0
	
