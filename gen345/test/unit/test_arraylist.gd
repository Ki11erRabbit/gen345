extends GutTest


func test_creation():
	var list = ArrayList.new()
	assert_not_null(list, "Fresh Arraylist is null")

func test_from_array():
	var array = [0, 1, 2, 3, 4]
	var list = ArrayList.from_array(array)
	assert_eq(list.size(), array.size(), "Arraylist and array are not the same length")
	assert_eq(list.capacity(), array.size(), "Arraylist and array are not the same capacity")

func test_with_capacity():
	const capacity = 10
	var list = ArrayList.with_capacity(capacity)
	assert_eq(list.capacity(), capacity, "Capacities not the same despite being initialized with one")

func test_initialize():
	const compare = [0, 1, 2, 3, 4]
	var list = ArrayList.initialize(5, func(i):
		return i)
	assert_eq(list.get(0), compare[0], "0th items should be the same in arraylist")
	assert_eq(list.get(1), compare[1], "1st items should be the same in arraylist")
	assert_eq(list.get(2), compare[2], "2nd items should be the same in arraylist")
	assert_eq(list.get(3), compare[3], "3rd items should be the same in arraylist")
	assert_eq(list.get(4), compare[4], "4th items should be the same in arraylist")

func test_append():
	var list = ArrayList.new()
	list.append(1)
	assert_eq(list.front(), 1, "Failed to insert into arraylist correctly")

func test_append_array():
	var insert = [0, 1, 2, 3, 4]
	var list = ArrayList.new()
	list.append_array(insert)
	assert_eq(list.get(0), insert[0], "0th items should be the same in arraylist")
	assert_eq(list.get(1), insert[1], "1st items should be the same in arraylist")
	assert_eq(list.get(2), insert[2], "2nd items should be the same in arraylist")
	assert_eq(list.get(3), insert[3], "3rd items should be the same in arraylist")
	assert_eq(list.get(4), insert[4], "4th items should be the same in arraylist")

func test_push():
	var list = ArrayList.new()
	list.push_front(2)
	list.push_back(3)
	list.push_front(4)
	
	for i in range(3):
		print(list.get(i))
	
	assert_eq(list.front(), 4, "First item is incorrect")
	assert_eq(list.back(), 3, "Last item is incorrect")
