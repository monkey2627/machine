extends VBoxContainer



var gongyiList = []
var gongyiItemUI = preload("res://UI/gongyitable/gongyi_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var item1= {}
	item1.id = 0
	item1.name = "gongyi1"
	item1.desc = "gongyi1 工艺1的描述"
	gongyiList.push_back(item1)
	var item2= {}
	item2.id = 1
	item2.name = "gongyi2"
	item2.desc = "gongyi2 工艺2的描述"
	gongyiList.push_back(item2)
	var item3= {}
	item3.id = 2
	item3.name = "gongyi3"
	item3.desc = "gongyi3 工艺3的描述"
	gongyiList.push_back(item3)
	_update_list_ui()



func _delete_item_by_id(id):
	var i:int = 0
	while i < gongyiList.size():

		var item = gongyiList[i]
		if item.id == id:
			gongyiList.remove_at(i)
			i-=1
		i+= 1
	_update_list_ui()

	
func _add_item(item):
	item.id = randi_range(1,100)
	gongyiList.push_back(item)
	_update_list_ui()
	pass

func _edit_item(item):
	for i in range(gongyiList.size()):
		var _item = gongyiList[i]
		if _item.id == item.id:
			gongyiList[i] = item
			
		i+= 1
	_update_list_ui()
	pass
	
func _update_list_ui():
	var node = $"."
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
	for i in range(gongyiList.size()):
		var item = gongyiList[i]
		item.number = i
		var uiItem = gongyiItemUI.instantiate()
		uiItem.connect("gongyiItem_delele",_delete_item_by_id)
		uiItem.connect("gongyiItem_edit",_edit_item)
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
	$"../../AddGongYiDialog".visible = true
	$"../../AddGongYiDialog/VBoxContainer/HBoxContainer/NameEdit".text = ""
	$"../../AddGongYiDialog/VBoxContainer/HBoxContainer2/DescEdit".text = ""
	
	pass # Replace with function body.
