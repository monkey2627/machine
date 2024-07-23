extends HBoxContainer


	
@export var gongyi_item ={}

signal gongyiItem_delele
signal gongyiItem_edit
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _update_UI(item):
	gongyi_item = item;
	$"number".text = str(item.id)
	$name.text = item.name
	$desc.text =  item.desc





func _on_delete_pressed():
	
	self.emit_signal("gongyiItem_delele",gongyi_item.id)
	pass # Replace with function body.


func _on_edit_gongyi_dialog_confirmed():
	
	gongyi_item.name = $EditGongyiDialog/VBoxContainer/HBoxContainer/NameEdit.text
	gongyi_item.desc = $EditGongyiDialog/VBoxContainer/HBoxContainer2/DescEdit.text
	print(gongyi_item)
	self.emit_signal("gongyiItem_edit",gongyi_item)
	pass # Replace with function body.


func _on_edit_pressed():
	$EditGongyiDialog.visible = true
	$EditGongyiDialog/VBoxContainer/HBoxContainer/NameEdit.text = gongyi_item.name
	$EditGongyiDialog/VBoxContainer/HBoxContainer2/DescEdit.text = gongyi_item.desc
	
	pass # Replace with function body.
