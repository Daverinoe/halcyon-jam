extends Label


export(String) var binding: String

var __current: int = 0


func _ready() -> void:
	self.__current = InputManager.get_key(self.binding)
	self.__update_text()
	if self.text == "" or self.text == null:
		match binding:
			"move_left":
				self.text = "A"
			"move_right":
				self.text = "D"
			"jump":
				self.text = "Space"
			_:
				pass


func __update_text(override: int = -1) -> void:
	var value: int = self.__current

	if override != -1:
		value = override

	self.text = OS.get_scancode_string(value)
