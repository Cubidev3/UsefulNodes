class_name StateMachine
extends Node
## Node for a Finite State Machine, based on GDQuest's implementation.
## Place State Nodes as children of an StateMachine Node to add them to the FSM.
## States can be added or removed at execution time by manipulating the scene tree.
## Adding an State Node to an empty StateMachine will automatically make it the current state
## Removing the current state will cause the machine to stop. Other nodes won't


## Gets Emiten when an successiful transition happens
signal transitioned(old: State, new: State)


## Gets Emited if the state machine loses track of its current_state,
## which usually happens when its current state node is removed form the scene tree
signal stopped


# Dictonary where States are stored. 
# Values are State Nodes and keys are these node's name.
var _states: Dictionary = {}


# The current State. Will automatically disable process and physics_process if its set to null.
var _current: State = null:
	set(value):
		set_process(value != null)
		set_physics_process(value != null)
		_current = value
		
		if _current == null:
			stopped.emit()
		
	get:
		return _current


# Sets up adding and removing states in execution time
func _ready():
	child_entered_tree.connect(_on_child_entered)
	child_exiting_tree.connect(_on_child_exiting)


## Changes the current state of the State Machine if an valid state name is passed.
## Calls exit method of last state and enter method the new state, passing the transition message.
## Returns true if it sucessifully transitioned
func transition_to(state_name: String, msg: Dictionary = {}) -> bool:
	var next_state = _states[state_name]
	if next_state == null:
		printerr("Unknown state {", state_name, "}")
		return false
		
	if _current != null:
		_current._exit(self)
		
	var old = _current
	_current = next_state
	_current._enter(self, msg)
	
	transitioned.emit(old, _current)
	return true
	
	
## Returns the current state
func get_current_state() -> State:
	return _current
	
	
## Returns the state assocciated with state_name if it exists
func get_state(state_name: String) -> State:
	return _states[state_name]
	
	
## Returns if an state named state_name is registered
func has_state(state_name: String) -> bool:
	return _states.has(state_name)
	
	
## Returns true if the current state is not null
func is_running() -> bool:
	return _current != null


# Runs update of current state
# Gets disabled when current scene is null.
func _process(delta):
	_current._update(self, delta)


# Runs fixed update of current state.
# Gets disabled when current scene is null.
func _physics_process(delta):
	_current._fixed_update(self, delta)


func _get_states_from_children():
	for child: Node in get_children():
		if child is State:
			_add_state(child)


# Adds a new state and sets it as current if the State Machine stopped
func _add_state(state: State):
	if state == null:
		return
	
	if _current == null:
		_current = state
	
	_states[state.name] = state


# Removes a state and stops the state machine if the current state is removed
func _remove_state(state: State):
	if state == null:
		return
		
	if _current == state:
		_current = null
		
	_states.erase(name)


func _on_child_entered(child: Node):
	if child is State:
		_add_state(child)


func _on_child_exiting(child: Node):
	if child is State:
		_remove_state(child)
