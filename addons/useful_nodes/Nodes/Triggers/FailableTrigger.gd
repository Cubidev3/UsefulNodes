class_name FailableTrigger
extends Trigger


@export_range(0.0, 1.0) var chance_of_triggering = 0.5


func try_trigger():
	randomize()
	if randf_range(0.0, 1.0) > chance_of_triggering:
		return
	
	triggered.emit()
