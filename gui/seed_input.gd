class_name SeedInput extends LineEdit

@onready var label: Label = $Label
@onready var button: Button = $"../Button"

var final_text: String = ""

func _ready() -> void:
	text_changed.connect(on_line_edit_text_changed)

func on_line_edit_text_changed(_text: String) -> void:
	if _text.is_valid_int():
		final_text = _text

	text = final_text
	caret_column = text.length()
	

func _on_gui_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("up") 
		or event.is_action_pressed("left") 
		or event.is_action_pressed("ui_up")
		or event.is_action_pressed("ui_left")
		or event.is_action_pressed("enter")
		):
		button.grab_focus()
		
