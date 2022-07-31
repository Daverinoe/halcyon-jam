extends Control
class_name Setting

# Signals

# Enums
enum {
	CHECK_BOX,
	OPTION_BUTTON,
	SLIDER,
	KEY_INPUT,
}

# Public vars

var setting_value setget __set_value, __get_value

# Vars
export(int, "Check Box", "Option Button", "Slider", "Key Input") var type : int setget __set_type, __get_type

# Onreadies
onready var __references :  = [
	$HBoxContainer/CheckBox,
	$HBoxContainer/OptionButton,
	$HBoxContainer/HSlider,
	$HBoxContainer/Button,
]


func _ready() -> void:
	var text_parse = name.split("-")
	$HBoxContainer/Label.text = text_parse[1]
	self.type = type
	var ref = __references[type]
	ref.visible = true
	
	self.setting_value = SettingsManager.get_setting(text_parse[0] + "/" + text_parse[1])
	match type:
		SLIDER:
			self.set_range([0, 1.0], 0.05)


func __set_type(new_type : int) -> void:
	type = new_type


func __get_type() -> int:
	return type


func set_range(slide_range : Array, new_step : float) -> void:
	__references[type].min_value = slide_range[0]
	__references[type].max_value = slide_range[1]
	__references[type].step = new_step


func add_item(label: String, id: int = -1) -> void:
	__references[self.OPTION_BUTTON].add_item(label, id)


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	setting_value = button_pressed


func __set_value(new_value) -> void:
	setting_value = new_value
	
	match type:
		KEY_INPUT:
			__references[type].text = OS.get_scancode_string(setting_value)
		OPTION_BUTTON:
			__references[type].text = setting_value
		CHECK_BOX:
			__references[type].pressed = setting_value
		SLIDER:
			__references[type].value = setting_value
		
	SettingsManager.emit_signal("setting_changed", self.name, self.setting_value)


func __get_value():
	return setting_value


func _on_HSlider_value_changed(value: float) -> void:
	setting_value = value


func _on_OptionButton_item_selected(index: int) -> void:
	pass # Replace with function body.


func _on_Button_pressed() -> void:
	pass # Replace with function body.
