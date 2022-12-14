class_name BoardButton extends Button


# Public variables

var points: PoolVector2Array = PoolVector2Array()


# Public variables

export(bool) var animating: bool = false


# Private variables

var __focus: bool = false
var __lower: bool = false
var __mouse: bool = false
var __timer: Timer = Timer.new()


func _ready() -> void:
	__timer.wait_time = 0.2
	__timer.connect("timeout", self, "__toggle_text")
	self.add_child(__timer)

	if animating:
		__timer.start()
	else:
		connect("focus_entered", self, "__focused", [true])
		connect("focus_exited", self, "__focused", [false])
		connect("mouse_entered", self, "__moused", [true])
		connect("mouse_exited", self, "__moused", [false])


# Private methods

func __focused(focus: bool) -> void:
	__focus = focus

	__update_highlight()


func __moused(mouse: bool) -> void:
	__mouse = mouse

	grab_focus()

	__update_highlight()


func __toggle_text() -> void:
	if __lower:
		text = text.to_upper()
	else:
		text = text.to_lower()

	__lower = !__lower


func __update_highlight() -> void:
	if __focus || __mouse:
		__timer.start()
	else:
		__timer.stop()
