@icon("res://addons/useful_nodes/Icons/Counter.svg")
class_name Counter
extends Node
## An Integer Counter that goes from 0 to Max.


## Gets emitted when count value changes.
## Does not get emitted if there is no difference between new and current count values.
signal changed(difference: int)

## Gets emitted when counter reaches it maximum value.
## Wont get emitted unless count changes.
signal maxed

## Gets emitted when counter reaches zero, its minimum value.
## Wont get emitted unless count changes.
signal zeroed


## Maximum Count value.
## Changing this value can trigger Changed, Maxed and Zeroed signals.
@export_range(0, 1000000) var max: int = 10:
	set(value): 
		max = max(0, value)
		__set_counter(clamp(__current, 0, max))
		
	get: 
		return max


## Private Attribute. Do Not Directly Modify It. Use get_current_count() instead.
## Internal current count value.
var __current: int = 0


## Counts up or down by an amount value.
## Can trigger Changed, Maxed and Zeroed signals.
func count(amount: int = 1):
	__set_counter(clampi(__current + amount, 0, max))


## Sets current count to maximum value.
## Can Trigger Changed and Maxed if counter isnt already maxed.
func fill():
	__set_counter(max)


## Sets current count to zero.
## Can Trigger Changed and Zeroed if counter isnt already zeroed.
func clear():
	__set_counter(0)


## Private Function. Should Not be directly Called or Overridden.
## Sets a new value for current count and emits appropriate signals.
func __set_counter(new: int):
	var difference = new - __current
	__current = new
	
	if difference == 0:
		return
		
	changed.emit(difference)
	
	if __current == max:
		maxed.emit()
		return
		
	if __current == 0:
		zeroed.emit()
		return


## Returns current counted value
func get_current_count() -> int:
	return __current


## Returns completion percentage of counter.
## If max is zero, this will return 1.0.
func get_completion_percentage() -> float:
	if max == 0: return 1.0
	return (__current as float) / (max as float)


## Returns remaining percentage of counter.
## if max is zero, this will return 0.0.
## Is equal to 1.0 - get_completion_percentage().
func get_remaining_percentage() -> float:
	return 1.0 - get_completion_percentage()
