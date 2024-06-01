@icon("res://addons/useful_nodes/Icons/Counter.svg")
class_name Counter
extends Node
## An Integer Counter that goes from Min to Max.


## Gets emitted when count value changes.
## Does not get emitted if there is no difference between new and current count values.
signal changed(difference: int)

## Gets emitted when counter reaches it maximum value.
## Wont get emitted unless count changes.
signal maxed_out

## Gets emitted when counter reaches zero, its minimum value.
## Wont get emitted unless count changes.
signal minimized


## Maximum Count Value.
## Changing this value can trigger Changed, Maxed_Out and Minimized signals.
@export_range(0, 1000000) var max: int = 10:
	set(value): 
		max = max(min, value)
		__set_counter(clampi(__current, min, max))

	get: 
		return max
		
		
## Minimum Count Value.
## Changing this value can trigger Changed, Maxed_Out and Minimized signals.
@export var min: int = 0:
	set(value):
		min = min(max, value)
		__set_counter(clampi(__current, min, max))

	get:
		return min


## default value of counter.
## Use reset() to set current count back to this value.
## default cannot go below zero nor higher than max
@export_range(0, 1000000) var default: int = 0:
	set(value):
		default = clampi(value, min, max)
		
	get:
		return default


## Current count value. 
## Use this to count up or down and get the counted value.
## current cannot go below zero nor higher than max
## Can trigger Changed, Maxed_Out and Minimized signals.
var current: int = 0:
	set(value):
		__set_counter(clampi(value, min, max))

	get:
		return __current


var __current: int = 0


func _ready():
	default = clampi(default, min, max)
	__current = default


## Counts up if amount is higher than 0
## Does nothing otherwise
func count_up_or_nothing(amount: int = 1):
	__set_counter(clampi(__current + amount, __current, max))


## Counts down if amount is higher than 0
## Does nothing otherwise
func count_down_or_nothing(amount: int = 1):
	__set_counter(clampi(__current + amount, min, __current))


## Sets current count to maximum value.
## Can Trigger Changed and Maxed_Out if counter isnt already maxed_out.
func fill():
	__set_counter(max)


## Sets current count to minimum value.
## Can Trigger Changed and Minimized if counter isnt already at minimum.
func clear():
	__set_counter(min)
	

## Sets current count back to default.
## Can Trigger Changed, Maxed_Out or Minimized
func reset():
	__set_counter(default)


func __set_counter(new: int):
	var difference = new - __current
	__current = new
	
	if difference == 0:
		return
		
	changed.emit(difference)
	
	if __current == max:
		maxed_out.emit()
		return
		
	if __current == min:
		minimized.emit()
		return


## Returns total size of counter
func get_size() -> int:
	return max - min


## Returns completion percentage of counter.
## If current size is zero, this will return 1.0.
func get_completion_percentage() -> float:
	var size: int = get_size()
	if size == 0: return 1.0
	return ((__current - min) as float) / (size as float)


## Returns remaining percentage of counter.
## if current size is zero, this will return 0.0.
## Is equal to 1.0 - get_completion_percentage().
func get_remaining_percentage() -> float:
	return 1.0 - get_completion_percentage()
