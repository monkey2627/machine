extends HBoxContainer

class_name ProjectItem

var hover = false
var select = false

var ID
var project_name
var project_info
var belongs
var belongs_name
var project_url
var project_user
var project_date


func _notification(what):
	if what == NOTIFICATION_MOUSE_ENTER:
		hover = true
		queue_redraw()
	elif what == NOTIFICATION_MOUSE_EXIT:
		hover = false
		queue_redraw()
	elif what == NOTIFICATION_DRAW:
		if select:
			draw_style_box(get_theme_stylebox("hover", "Tree"), Rect2(Vector2(), get_size()))
		elif hover:
			draw_style_box(get_theme_stylebox("hover", "Tree"), Rect2(Vector2(), get_size()))


func _ready():
	#connect("gui_input", Callable(SubjectList, "list_input").bind(self))
	pass
