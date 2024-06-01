@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Counter", "Node", preload("res://addons/useful_nodes/Nodes/Counter.gd"), preload("res://addons/useful_nodes/Icons/Counter.svg"))


func _exit_tree():
	remove_custom_type("Counter")
