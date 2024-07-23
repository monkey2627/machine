extends AcceptDialog


var button
var select_dialog
var list

func _ready():
	button = get_node("GridContainer/belongs")
	select_dialog = get_node("GridContainer/belongs/selectSubject")
	button.connect("pressed", Callable(self, "_on_select_show"))
	select_dialog.connect("confirmed", Callable(self, "_on_select_confirm"))
	list = select_dialog.get_node("ScrollContainer/ItemList")
	pass


func update_list(data):
	list.clear()
	for item in data:
		list.add_item(item["SubjectName"])


func _on_select_show():
	select_dialog.show()
	
	
func _on_select_confirm():
	var item = list.get_selected_items()[0]
	button.text = list.get_item_text(item)
