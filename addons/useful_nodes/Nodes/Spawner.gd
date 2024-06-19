class_name Spawner
extends Node
## Node that instantiates a scene and places it in the scene tree


## Signal emitted when a scene is successfully instantiated
## Use this to modify instance attributes
signal spawned(instance: Node)


## Scene that will be instantiated
@export var scene: PackedScene

## Group of node that will be the parent of instantiated nodes
@export var parent_group: String


# Private Attribute. Used to cache a parent in memory 
# and avoid having to search for it multiple times
var _cached_parent: Node = null


## Main method of Spawner Class. Tries to instantiate scene and place its instance as child
## of a node in parent_group. Can fail if no parent is found. Emits Spawned when it
## successifully instantiates a scene
func spawn():
	var instance_parent := _get_scene_parent()
	if not is_instance_valid(instance_parent):
		printerr("No node in group {", parent_group, "} to be a parent")
		return
	
	var instance := scene.instantiate()
	instance_parent.add_child(instance)
	
	spawned.emit(instance)


# Private Function. returns a node in parent_group to be parent of a instatiated node.
# return _cached_parent if still valid. Otherwise searches for first node in parent_group.
# Can return null if there is no node in parent_group
func _get_scene_parent() -> Node:
	if not is_instance_valid(_cached_parent):
		_cached_parent = get_tree().get_first_node_in_group(parent_group)
		
	return _cached_parent
