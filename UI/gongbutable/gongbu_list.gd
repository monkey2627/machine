extends VBoxContainer



var gongbuList = []
var gongbuItemUI = preload("res://UI/gongbutable/gongbu_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var item1= {}
	item1.id = 0
	item1.name = "gongbu1"
	item1.department = "工步1的部门"
	item1.time = 1
	item1.demand = "工步1的要求"
	gongbuList.push_back(item1)
	
	var item2= {}
	item2.id = 1
	item2.name = "gongbu2"
	item2.department = "工步2的部门"
	item2.time = 2
	item2.demand = "工步2的要求"
	gongbuList.push_back(item2)
	
	var item3= {}
	item3.id = 2
	item3.name = "gongbu3"
	item3.department = "工步3的描述"
	item3.time = 3
	item3.demand = "工步3的要求"
	gongbuList.push_back(item3)
	_update_list_ui()



func _delete_item_by_id(id):
	var i:int = 0
	while i < gongbuList.size():

		var item = gongbuList[i]
		if item.id == id:
			gongbuList.remove_at(i)
			i-=1
		i+= 1
	_update_list_ui()

	
func _add_item(item):
	item.id = randi_range(1,100)
	gongbuList.push_back(item)
	_update_list_ui()
	pass

func _edit_item(item):
	for i in range(gongbuList.size()):
		var _item = gongbuList[i]
		if _item.id == item.id:
			gongbuList[i] = item
			
		i+= 1
	_update_list_ui()
	pass
	
func _update_list_ui():
	var node = $"."
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
	for i in range(gongbuList.size()):
		var item = gongbuList[i]
		item.number = i
		var uiItem = gongbuItemUI.instantiate()
		uiItem.connect("gongbuItem_delele",_delete_item_by_id)
		uiItem.connect("gongbuItem_edit",_edit_item)
		uiItem._update_UI(item);
		node.add_child(uiItem)
		uiItem.set_owner(node)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass








func _on__pressed():
	$"../../AddGongbuDialog".visible = true
	pass # Replace with function body.


func _on_add_gongbu_dialog_confirmed():
	var item ={}
	item.name =$"../../AddGongbuDialog/VBoxContainer/Name/NameEdit".text
	item.department = $"../../AddGongbuDialog/VBoxContainer/Department/DepartmentEdit".text
	item.time = int($"../../AddGongbuDialog/VBoxContainer/Time/TimeEdit".text) 
	item.demand = $"../../AddGongbuDialog/VBoxContainer/Demand/DemandEdit".text
	_add_item(item)
	pass # Replace with function body.
