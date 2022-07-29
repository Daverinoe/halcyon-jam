extends Node 

# enums
enum COLORBLIND_OPTIONS {
	NONE = 0, 
	PROTANOPIA, 
	DEUTRANOPIA, 
	TRITANOPIA,
	}

# Public signals

signal setting_changed(name, value)


# Private consts

const __SETTINGS_PATH = "settings.json"


# Private variables 

var __settings: Dictionary = {}
var __settings_default: Dictionary = {
	"volume": {
		"master": 1.0,
		"music": 1.0,
		"effects": 1.0,
	},
	"input": {
		"move_left": KEY_A,
		"move_right": KEY_D,
		"jump": KEY_SPACE,
		"glide": KEY_SPACE,
	},
	"graphics": {
		"screen_resolution": "1920x1080",
		"fullscreen": false,
		"colorblind": COLORBLIND_OPTIONS.NONE,
		"colorblind_intensity": 1,
	},
	"gameplay": {
	},
}


# Lifecycle methods

func _ready() -> void: 
	settings_load()


# Public methods
func get_setting(name, default = null):
	var path: Array = name.split("/")
	var location: Dictionary = self.__settings

	for index in range(path.size() - 1):
		var part: String = path[index]

		if location.has(part):
			location = location[part]
		else:
			return default

	var setting_name: String = path[path.size() - 1]
	if location.has(setting_name):
		return location.get(setting_name)
	else:
		return default


func set_setting(name: String, value, save: bool = false) -> void:	
	for key in __settings:
		if __settings[key].has(name):
			self.change_setting(key, name, value)


func change_setting(type: String, name: String, value, save: bool = false) -> void: 
	match type:
		"volume":
			AudioManager.set_volume(name, value)
		"graphics":
			GraphicManager.set_graphic(name, value)
		"effects":
			EffectManager.set_effect(name, value)
		"input":
			InputManager.set_key(name, value)
		_:
			pass
	
	__settings[type][name] = value


func settings_load() -> void: 
	if IOHelper.file_exists(__SETTINGS_PATH):
		var setting_string: String = IOHelper.file_load(__SETTINGS_PATH)
		
		__settings = parse_json(setting_string)
		
		if __merge_settings(__settings, __settings_default): 
			settings_save()
		
	else:
		__settings = __settings_default
		
		settings_save()
	
	__set_settings(__settings)


func settings_save() -> void: 
	var setting_string: String = to_json(__settings)
		
	IOHelper.file_save(__SETTINGS_PATH, setting_string)


# Private methods 

func __merge_settings(a: Dictionary, b: Dictionary) -> bool: 
	var changed: bool = false
	
	for key in b: 
		if !a.has(key) || typeof(a[key]) != typeof(b[key]):
			a[key] = b[key]
			
			changed = true
		elif b[key] is Dictionary:
			changed = changed || __merge_settings(a[key], b[key]) 
			
	return changed


func __set_settings(settings: Dictionary, type: String = "") -> void:
	for key in settings.keys():
		var setting = settings[key]
		print(key)
		# Recursion! Yay! Nothing could possibly go wrong here!
		if typeof(setting) == TYPE_DICTIONARY:
			__set_settings(setting, key)
		if type:
			change_setting(type, key, settings[key])
