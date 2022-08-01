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
var __type_string : String
var __name_string : String

# Onreadies
onready var __references :  = [
	$HBoxContainer/CheckBox,
	$HBoxContainer/OptionButton,
	$HBoxContainer/HSlider,
]


func _ready() -> void:
	
	var text_parse = name.split("-")
	__type_string = text_parse[0]
	__name_string = text_parse[1]
	$HBoxContainer/Label.text = __name_string.replace("_", " ")
	self.type = type
	
	
	if type == self.KEY_INPUT:
		var key_button : ChangeButton = ChangeButton.new()
		key_button.binding = __name_string
		key_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		__references.push_back(key_button)
		$HBoxContainer.add_child(key_button)
	
	var ref = __references[type]
	ref.visible = true
	
	self.setting_value = SettingsManager.get_setting(__type_string + "/" + __name_string)
	match type:
		SLIDER:
			self.set_range([0, 1.0], 0.05)
	match __name_string:
		"screen_resolution":
			if OS.has_feature("JavaScript"):
				self.queue_free()
			for resolution in SettingsManager.resolutions:
				ref = ref as OptionButton
				ref.add_item(resolution)
			self.__set_value("1920x1080")
		"fullscreen":
			if OS.has_feature("JavaScript"):
				self.queue_free()
#		"colorblind":
#			for index in SettingsManager.COLORBLIND_OPTIONS:
#				ref = ref as OptionButton
#				var name = SettingsManager.COLORBLIND_OPTIONS.keys()[index]
#				ref.add_item(name)


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
	__set_value(button_pressed)


func __set_value(new_value) -> void:
	setting_value = new_value
	
	match type:
		KEY_INPUT:
			__references[type].text = OS.get_scancode_string(setting_value)
		OPTION_BUTTON:
			(__references[type] as OptionButton).select(SettingsManager.resolutions.find(setting_value))
		CHECK_BOX:
			__references[type].pressed = setting_value
		SLIDER:
			__references[type].value = setting_value
		
	SettingsManager.change_setting(self.__type_string, self.__name_string, self.setting_value)


func __get_value():
	return setting_value


func _on_HSlider_value_changed(value: float) -> void:
	__set_value(value)


func _on_OptionButton_item_selected(index: int) -> void:
	var ref = (__references[type] as OptionButton)
	var value = ref.get_item_text(ref.get_selected_id())
	__set_value(value)

