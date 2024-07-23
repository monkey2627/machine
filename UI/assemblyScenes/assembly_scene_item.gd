extends PanelContainer


var scene_item = {}

signal select_item
signal select_item_right

var stylebox
# Called when the node enters the scene tree for the first time.
func _ready():
	
	stylebox = StyleBoxFlat.new()
	stylebox.border_width_bottom  =0 
	stylebox.border_width_left  =0 
	stylebox.border_width_right  =0 
	stylebox.border_width_top  =0 
	stylebox.bg_color = Color(0,0,0,0)
	pass # Replace with function body.

func update_ui(item):
	scene_item = item
	$VBoxContainer/Label.text = scene_item.name
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_mouse_entered():

	self.add_theme_stylebox_override("panel", stylebox)

#	var stylebox = get_theme_stylebox("Panel","PanelContainer")
	stylebox.border_width_bottom =1
	stylebox.border_width_left =1
	stylebox.border_width_right =1
	stylebox.border_width_top =1
	

	pass # Replace with function body.


func _on_mouse_exited():
	
	stylebox.border_width_bottom  =0 
	stylebox.border_width_left  =0 
	stylebox.border_width_right  =0 
	stylebox.border_width_top  =0 
	pass # Replace with function body.

var mouse_pressed_left = false
var mouse_pressed_right = false
func _on_gui_input(event):
	if event is InputEventMouseButton:
		#按键为左键
		if event.button_index == MOUSE_BUTTON_LEFT:
			#左键按下
			if event.pressed == true:
				mouse_pressed_left = true
				pass
			#左键松开
			else:
				if mouse_pressed_left == true:
					mouse_pressed_left = false
					self.emit_signal("select_item",event.global_position,scene_item)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			#右键按下
			if event.pressed == true:
				mouse_pressed_right = true
				pass
			#右键松开
			else:
				if mouse_pressed_right == true:
					mouse_pressed_right = false
					self.emit_signal("select_item_right",event.global_position,scene_item)

	pass # Replace with function body.
