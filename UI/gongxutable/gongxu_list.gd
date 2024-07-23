extends VBoxContainer



var gongxuList = []
var gongxuItemUI = preload("res://UI/gongxutable/gongxu_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var item1= {}
	item1.id = 0
	item1.name = "gongxu1"
	item1.content = "工序1的部门"
	item1.time = 1
	item1.demand = "工序1的要求"
	gongxuList.push_back(item1)
	
	var item2= {}
	item2.id = 1
	item2.name = "gongbu2"
	item2.content = "工步2的部门"
	item2.time = 2
	item2.demand = "工步2的要求"
	gongxuList.push_back(item2)
	
	var item3= {}
	item3.id = 2
	item3.name = "gongbu3"
	item3.content = "工步3的描述"
	item3.time = 3
	item3.demand = "工步3的要求"
	gongxuList.push_back(item3)
	_update_list_ui()



func _delete_item_by_id(id):
	var i:int = 0
	while i < gongxuList.size():

		var item = gongxuList[i]
		if item.id == id:
			gongxuList.remove_at(i)
			i-=1
		i+= 1
	_update_list_ui()

	
func _add_item(item):
	item.id = randi_range(1,100)
	gongxuList.push_back(item)
	_update_list_ui()
	pass

func _edit_item(item):
	for i in range(gongxuList.size()):
		var _item = gongxuList[i]
		if _item.id == item.id:
			gongxuList[i] = item
			
		i+= 1
	_update_list_ui()
	pass
	
func _update_list_ui():
	var node = $"."
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
	for i in range(gongxuList.size()):
		var item = gongxuList[i]
		item.number = i
		var uiItem = gongxuItemUI.instantiate()
		uiItem.connect("gongxuItem_delele",_delete_item_by_id)
		uiItem.connect("gongxuItem_edit",_edit_item)
		uiItem._update_UI(item);
		node.add_child(uiItem)
		uiItem.set_owner(node)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass







func _on_add_gong_yi_dialog_confirmed():
	var item ={}
	item.name = $"../../AddGongYiDialog/VBoxContainer/HBoxContainer/NameEdit".text
	item.desc = $"../../AddGongYiDialog/VBoxContainer/HBoxContainer2/DescEdit".text
	_add_item(item)
	print(item)
	pass # Replace with function body.


func _on__pressed():
	$"../../AddGongxuDialog".visible = true
	$"../../AddGongxuDialog/VBoxContainer/Name/NameEdit".text = ""
	$"../../AddGongxuDialog/VBoxContainer/Content/ContentEdit".text = ""
	$"../../AddGongxuDialog/VBoxContainer/Demand/DemandEdit".text = ""
	$"../../AddGongxuDialog/VBoxContainer/Time/TimeEdit".text = ""
	
	pass # Replace with function body.


func _on_add_gongxu_dialog_confirmed():
	var item ={}
	item.name = $"../../AddGongxuDialog/VBoxContainer/Name/NameEdit".text
	item.content = $"../../AddGongxuDialog/VBoxContainer/Content/ContentEdit".text
	item.demand = $"../../AddGongxuDialog/VBoxContainer/Demand/DemandEdit".text
	item.time = int($"../../AddGongxuDialog/VBoxContainer/Time/TimeEdit".text)
	_add_item(item)
	print(item)
	pass # Replace with function body.
