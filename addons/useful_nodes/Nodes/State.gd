class_name State
extends Node
## State of a StateMachine Node. Based on GDQuest's Implementation.
## Has methods for process and physics_process called update and fixed_update
## as well as enter and exit methots that are called when transitioning states


func _enter(machine: StateMachine, msg: Dictionary = {}):
	pass


func _update(machine: StateMachine, delta: float):
	pass


func _fixed_update(machine: StateMachine, delta: float):
	pass


func _exit(machine: StateMachine):
	pass
