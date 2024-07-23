extends HBoxContainer


	
@export var gongxu_item ={}

signal gongxuItem_delele
signal gongxuItem_edit
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _update_UI(item):
	gongxu_item = item;
	$"number".text = str(item.id)
	$name.text = item.name
	$time.text =  str(item.time)
	$content.text = item.content
	$demand.text = item.demand





func _on_delete_pressed():
	
	self.emit_signal("gongxuItem_delele",gongxu_item.id)
	pass # Replace with function body.



func _on_edit_pressed():
	$EditGongxuDialog.visible = true
	$EditGongxuDialog/VBoxContainer/Name/NameEdit.text = gongxu_item.name
	$EditGongxuDialog/VBoxContainer/Content/ContentEdit.text=gongxu_item.content
	$EditGongxuDialog/VBoxContainer/Demand/DemandEdit.text = gongxu_item.demand
	$EditGongxuDialog/VBoxContainer/Time/TimeEdit.text =str(gongxu_item.time)
	pass # Replace with function body.


func _on_edit_gongxu_dialog_confirmed():
	
	gongxu_item.name = $EditGongxuDialog/VBoxContainer/Name/NameEdit.text
	gongxu_item.content = $EditGongxuDialog/VBoxContainer/Content/ContentEdit.text
	gongxu_item.demand = $EditGongxuDialog/VBoxContainer/Demand/DemandEdit.text
	gongxu_item.time = int($EditGongxuDialog/VBoxContainer/Time/TimeEdit.text)
	
	print(gongxu_item)
	self.emit_signal("gongxuItem_edit",gongxu_item)
	pass # Replace with function body.
