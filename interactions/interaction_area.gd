class_name InteractionArea extends Area2D

@export var action_name: String = "interact"

var interact: Callable = func() -> void:
	pass
	
func _ready() -> void:
	body_entered.connect(_player_entered)
	body_exited.connect(_player_exited)


func _player_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)
	
	
func _player_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)
