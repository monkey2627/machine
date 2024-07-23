extends HBoxContainer


	
@export var gongbu_item ={}

signal gongbuItem_delele
signal gongbuItem_edit
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _update_UI(item):
	gongbu_item = item;
	$"number".text = str(item.id)
	$name.text = item.name
	$department.text = item.department
	$time.text = str(item.time)
	$demand.text = item.demand





func _on_delete_pressed():
	self.emit_signal("gongbuItem_delele",gongbu_item.id)
	pass # Replace with function body.


func _on_edit_gongyi_dialog_confirmed():
	
	
	pass # Replace with function body.


func _on_edit_pressed():
	$EditGongbuDialog.visible =true
	$EditGongbuDialog/VBoxContainer/Name/NameEdit.text = gongbu_item.name
	$EditGongbuDialog/VBoxContainer/Department/DepartmentEdit.text = gongbu_item.department
	$EditGongbuDialog/VBoxContainer/Demand/DemandEdit.text = gongbu_item.demand
	$EditGongbuDialog/VBoxContainer/Time/TimeEdit.text = str(gongbu_item.time)
	pass # Replace with function body.


func _on_edit_gongbu_dialog_confirmed():
	
	gongbu_item.name =$EditGongbuDialog/VBoxContainer/Name/NameEdit.text
	gongbu_item.department =$EditGongbuDialog/VBoxContainer/Department/DepartmentEdit.text
	gongbu_item.demand	= $EditGongbuDialog/VBoxContainer/Demand/DemandEdit.text
	gongbu_item.time = int($EditGongbuDialog/VBoxContainer/Time/TimeEdit.text)
	print(gongbu_item)
	self.emit_signal("gongbuItem_edit",gongbu_item)
	pass # Replace with function body.
