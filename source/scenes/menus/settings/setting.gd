extends Control
class_name Setting

# Signals

# Enums
enum {
	CHECK_BOX,
	OPTION_BUTTON,
	SLIDER,
}

# Public vars

var value setget __set_value, __get_value

# Vars
var type : int setget __set_type, __get_type

# Onreadies
onready var __references :  = [
	$HBoxContainer/CheckBox,
	$HBoxContainer/OptionButton,
	$HBoxContainer/HSlider,
]


func _ready(type : int = 0) -> void:
	self.type = type
	
	var ref = __references[type]
	ref.visible = true
	
	match type:
		0:
			self.value = ref.pressed
		1:
			self.value = ref.get_item_text(ref.selected)
		2:
			self.value = ref.value


func __set_type(new_type : int) -> void:
	type = new_type


func __get_type() -> int:
	return type


func set_range(slide_range : Array) -> void:
	__references[type].min_value = slide_range[0]
	__references[type].max_value = slide_range[1]


func add_item(label: String, id: int = -1) -> void:
	__references[self.OPTION_BUTTON].add_item(label, id)


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	value = button_pressed


func __set_value(new_value) -> void:
	value = new_value
	SettingsManager.emit_signal("setting_changed", self.name, self.value)


func __get_value():
	return value
