class_name InputTrigger
extends Trigger


@export var action: String
@export var trigger_on_press: bool = false
@export var trigger_on_release: bool = false


func _input(event):
	if (trigger_on_press and Input.is_action_just_pressed(action)) or (trigger_on_release and Input.is_action_just_released(action)):
		triggered.emit()
