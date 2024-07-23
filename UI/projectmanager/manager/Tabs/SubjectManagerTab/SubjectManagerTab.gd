extends Control

class_name SubjectManager

var listNode
var includedItemList

var delete_button
var delete_dialog
var new_button
var new_dialog
var modify_button
var modify_dialog
var flush_button

var http
var url
var user

func _ready():
	http = HTTPRequest.new()
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	add_child(http)
	
	delete_button = get_node("Panel/HSplitContainer/Buttons/delete")
	delete_button.connect("pressed", Callable(self, "delete_subject"))
	delete_dialog = get_node("DeleteDialog")
	delete_dialog.connect("confirmed", Callable(self, "_on_delete_confirm"))
	
	new_button = get_node("Panel/HSplitContainer/Buttons/new")
	new_button.connect("pressed", Callable(self, "new_subject"))
	new_dialog = get_node("NewDialog")
	new_dialog.connect("confirmed", Callable(self, "_on_new_confirm"))
	
	modify_button = get_node("Panel/HSplitContainer/Buttons/modify")
	modify_button.connect("pressed", Callable(self, "modify_subject"))
	modify_dialog = get_node("ModifyDialog")
	modify_dialog.connect("confirmed", Callable(self, "_on_modify_confirm"))
	
	flush_button = get_node("Panel/HSplitContainer/Buttons/flush")
	flush_button.connect("pressed", Callable(self, "_flush_list"))
	

func load_items_from_database():
	http.request(url + "subject/get/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"SubjectId" : null,
	}))


func load_items(data):
	for item in data:
		item["ImgPath"] = "res://UI/projectmanager/icons/1.png"
		listNode.add_list_item(item)
	for item in listNode.list:
		item.connect("gui_input", Callable(self, "list_input").bind(item))
	includedItemList.load_items_from_database()


func list_input(event, item):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT:
			item.select = true
			listNode.selectedItem = item
			for subject in listNode.list:
				if subject != item:
					subject.select = false
					subject.queue_redraw()
			includedItemList.update_list(item.ID)


func new_subject():
	new_dialog.get_ok_button().set_disabled(true)
	new_dialog.show()
	if new_dialog.get_node("GridContainer/name").text:
		new_dialog.get_ok_button().set_disabled(false)
	

func _new_subject(subjectName, text):
	var nowTime = Time.get_date_string_from_system()
	# var item = listNode.new_item(subjectName, text, user["UserName"], nowTime)
	# item.connect("gui_input", Callable(self, "list_input").bind(item))
	# database options
	http.request(url + "subject/insert/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"SubjectName" : subjectName,
		"SubjectDescription" : text,
		"CreateTime" : nowTime,
		"CreateUserId" : user["UserId"]
	}))


func delete_subject():
	if not listNode.selectedItem:
		delete_dialog.get_node("HBoxContainer/Label").text = "未选择科目!"
		delete_dialog.show()
	else:
		delete_dialog.get_node("HBoxContainer/Label").text = "是否确认删除该科目!"
		delete_dialog.show()
	

func _delete_subject(item):
	listNode.selectedItem = null
	# database options
	http.request(url + "subject/delete/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"SubjectId" : item.ID
	}))
	listNode.delete_item(item)


func modify_subject():
	if not listNode.selectedItem:
		delete_dialog.get_node("HBoxContainer/Label").text = "未选择科目!"
		delete_dialog.show()
	else:
		modify_dialog.get_node("GridContainer/name").text = listNode.selectedItem.get_child(1).text
		modify_dialog.get_node("GridContainer/text").text = listNode.selectedItem.get_child(3).get_child(5).text
		modify_dialog.show()
	pass
	

func _modify_subject(item, subjectName, text):
	#item.get_child(1).text = subjectName
	#item.get_child(3).get_child(5).text = text
	#item.queue_redraw()
	#item.subject_name = subjectName
	#item.subject_info = text
	var nowTime = Time.get_date_string_from_system()
	# database options
	http.request(url + "subject/change/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"SubjectId" : item.ID,
		"SubjectName" : subjectName,
		"SubjectDescription" : text,
		"CreateTime" : nowTime,
		"CreateUser" : user["UserId"]
	}))
	pass
	

func _on_new_confirm():
	var subjectName = new_dialog.get_node("GridContainer/name").text
	var text = new_dialog.get_node("GridContainer/text").text
	new_dialog.get_node("GridContainer/name").text = ""
	new_dialog.get_node("GridContainer/text").text = ""
	new_dialog.get_node("GridContainer/Label3").visible = true
	new_dialog.get_ok_button().set_disabled(true)
	_new_subject(subjectName, text)


func _on_delete_confirm():
	if not listNode.selectedItem:
		pass
	else:
		_delete_subject(listNode.selectedItem)


func _on_modify_confirm():
	if not listNode.selectedItem:
		pass
	else:
		var subjectName = modify_dialog.get_node("GridContainer/name").text
		var text = modify_dialog.get_node("GridContainer/text").text
		_modify_subject(listNode.selectedItem, subjectName, text)


func _on_new_text_changed(new_text):
	if new_text:
		new_dialog.get_node("GridContainer/Label3").visible = false
		new_dialog.get_ok_button().set_disabled(false)
	else:
		new_dialog.get_node("GridContainer/Label3").visible = true
		new_dialog.get_ok_button().set_disabled(true)


func _on_modify_text_changed(new_text):
	if new_text:
		modify_dialog.get_node("GridContainer/Label3").visible = false
		modify_dialog.get_ok_button().set_disabled(false)
	else:
		modify_dialog.get_node("GridContainer/Label3").visible = true
		modify_dialog.get_ok_button().set_disabled(true)


func _on_search_item(new_text):
	if new_text:
		for item in listNode.list:
			var subName = String(item.get_child(1).text)
			if not new_text in subName:
				item.visible = false
	else:
		for item in listNode.list:
			item.visible = true
	pass


func _on_jump():
	var father = get_parent()
	father.current_tab = 1
	
	
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var res = JSON.parse_string(body.get_string_from_utf8())
		if res["status"] == 2:
			load_items(res["data"])
		elif res["status"] == 0:
			_flush_list()
	else:
		print("Request failed with response code:", response_code)


func _flush_list():
	print("刷新列表")
	for child in listNode.get_children():
		listNode.remove_child(child)
	listNode.list.clear()
	includedItemList._flush_list()
	load_items_from_database()
	listNode.selectedItem = null
	pass
