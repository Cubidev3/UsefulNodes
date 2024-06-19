class_name CountTrigger
extends Trigger


@export var counter: Counter


@export_range(0.0, 1.0) var completion_percentage: float
@export_range(0.0, 1.0) var remaining_percentage: float


func _on_counter_changed(difference: int):
	if (difference > 0 and counter.get_completion_percentage() >= completion_percentage) or (difference < 0 and counter.get_remaining_percentage() >= remaining_percentage):
		triggered.emit()
