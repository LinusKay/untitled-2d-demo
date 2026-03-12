extends Button

@onready var line_edit: LineEdit = $"../../HBoxContainer/LineEdit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	line_edit.text += text


func _process(_delta: float) -> void:
	if line_edit.text.length() >= 10:
		disabled = true
	else:
		disabled = false
