extends Button

@onready var line_edit: LineEdit = $"../../HBoxContainer/LineEdit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	line_edit.text = line_edit.text.left(-1)


func _process(_delta: float) -> void:
	if line_edit.text.length() == 0:
		disabled = true
	else:
		disabled = false
