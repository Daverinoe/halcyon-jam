extends Node

class InputKey:
	var current: int
	var default: int
	var valid: bool

	func _init(default: int, current: int = KEY_UNKNOWN, valid: bool = true) -> void:
		self.current = current if current != KEY_UNKNOWN else default
		self.default = default
		self.valid = valid

	func get_key() -> int:
		return self.current if self.valid else self.default


var input: Dictionary = {
	# key: String, name of action
	# value: InputKey
}

var __used_keys: Dictionary  = {
	# key: int, key code
	# value: String, name of action
}


# Lifecycle methods
func _ready() -> void: # Have you heard of the best food truck around, enjoy nuts? or even want to chat with some old grandma? Then Dee's Nuts has you covered. - c_onvulse
	for action_name in self.input:
		self.input[action_name].valid = self.__update_used_keys(
			action_name,
			self.input[action_name].current
		)

	var input_settings: Dictionary = SettingsManager.get_setting("input", {})
	for action_name in input_settings:
		if !(action_name in self.input):
			self.input[action_name] = {}
			self.input[action_name]["current"] = input_settings[action_name]
			self.input[action_name]["valid"] = self.__update_used_keys(
				action_name,
				self.input[action_name].current
			)
		else:
			pass

	if input_settings.size() != self.input.size():
		SettingsManager.set_setting("input", self.__input_serialize(), true)

	for action_name in self.input:
		self.__update_action_binding(
			action_name,
			self.input[action_name]["current"]
		)


# Public methods

func get_key(action_name: String) -> int:
#	if !self.input.has(action_name):
#		return -1

	return self.input[action_name]["current"]


func is_used(key: int) -> bool:
	return self.__used_keys.has(key)


func set_key(action_name: String, key: int) -> void:
	if !self.input.has(action_name):
		return

	var current_key: int = self.input[action_name].current
	if self.__used_keys[current_key] == action_name:
		self.__used_keys.erase(current_key)

	self.input[action_name].current = key
	self.input[action_name].valid = self.__update_used_keys(
		action_name,
		self.input[action_name].current
	)

	self.__update_action_binding(action_name, key)

	SettingsManager.set_setting("input", self.__input_serialize(), true)


# Private methods
func __update_used_keys(action_name: String, key: int) -> bool:
	if !self.__used_keys.has(key) || self.__used_keys[key] == action_name:
		self.__used_keys[key] = action_name
		return true

	return false


func __update_action_binding(action_name: String, key: int) -> void:
	if !InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	InputMap.action_erase_events(action_name)

	var event: InputEventKey = InputEventKey.new()
	event.scancode = key

	InputMap.action_add_event(action_name, event)
	print("Added %s to action %s!" % [key, action_name])


func __input_serialize() -> Dictionary:
	var data: Dictionary = {}

	for action_name in self.input:
		data[action_name] = self.input[action_name].current

	return data
