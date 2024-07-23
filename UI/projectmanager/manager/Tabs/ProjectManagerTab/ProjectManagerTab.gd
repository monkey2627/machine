extends Control

class_name ProjectManager

var listNode
var projectInfo
var delete_button
var delete_dialog
var new_button
var new_dialog
var modify_button
var modify_dialog
var run_button
var flush_button

var sub_list
var sub_index_id_map = []

var http
var url
var user

func _ready():
	http = HTTPRequest.new()
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	add_child(http)
	
	delete_button = get_node("Panel/HSplitContainer/Buttons/delete")
	delete_button.connect("pressed", Callable(self, "delete_project"))
	delete_dialog = get_node("DeleteDialog")
	delete_dialog.connect("confirmed", Callable(self, "_on_delete_confirm"))
	
	new_button = get_node("Panel/HSplitContainer/Buttons/new")
	new_button.connect("pressed", Callable(self, "new_project"))
	new_dialog = get_node("NewDialog")
	new_dialog.connect("confirmed", Callable(self, "_on_new_confirm"))
	
	modify_button = get_node("Panel/HSplitContainer/Buttons/modify")
	modify_button.connect("pressed", Callable(self, "modify_project"))
	modify_dialog = get_node("ModifyDialog")
	modify_dialog.connect("confirmed", Callable(self, "_on_modify_confirm"))

	run_button = get_node("Panel/HSplitContainer/Buttons/run")
	run_button.connect("pressed", Callable(self, "run_project"))
	
	flush_button = get_node("Panel/HSplitContainer/Buttons/flush")
	flush_button.connect("pressed", Callable(self, "_flush_list"))
	
	projectInfo = get_node("Panel/HSplitContainer/ListBox/HSplitContainer/Panel/ScrollContainer/projectInfo")


func load_items_from_database():
	http.request(url + "project/get/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"ProjectId" : null,
	}))


func load_items(data):
	for item in data:
		item["ImgPath"] = "res://UI/projectmanager/icons/2.png"
		listNode.add_list_item(item)
	for item in listNode.list:
		item.connect("gui_input", Callable(self, "list_input").bind(item))
	http.request(url + "subject/get/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"SubjectId" : null,
	}))


func list_input(event, item):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.double_click:
			get_tree().change_scene_to_file("res://MainUI.tscn")
		
			get_node("/root/Global").project_path = item.project_url
			
		elif event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT:
			item.select = true
			listNode.selectedItem = item
			for project in listNode.list:
				if project != item:
					project.select = false
					project.queue_redraw()
			update_project_info(item)


func update_project_info(item):
	projectInfo.get_node("projectBox/projectName/name").text = item.project_name
	projectInfo.get_node("projectBox/projectInfo/info").text = item.project_info
	projectInfo.get_node("projectBox/projectUrl/url").text = item.project_url
	projectInfo.get_node("belongs/name").text = item.belongs_name


func flush_project_info():
	projectInfo.get_node("projectBox/projectName/name").text = ""
	projectInfo.get_node("projectBox/projectInfo/info").text = ""
	projectInfo.get_node("projectBox/projectUrl/url").text = ""
	projectInfo.get_node("belongs/name").text = ""
	

func new_project():
	new_dialog.get_ok_button().set_disabled(true)
	new_dialog.update_list(sub_list)
	new_dialog.show()
	if new_dialog.get_node("GridContainer/name").text:
		new_dialog.get_ok_button().set_disabled(false)
	

func _new_project(projectName, text, belongs, projectUrl):
	var nowTime = Time.get_date_string_from_system()
	#var item = listNode.new_item(projectName, text, user["UserName"], belongs, nowTime, projectUrl)
	#item.connect("gui_input", Callable(self, "list_input").bind(item))
	# database options
	http.request(url + "project/insert/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"ProjectName" : projectName,
		"ProjectDescription" : text,
		"CreateTime" : nowTime,
		"CreateUserId" : user["UserId"],
		"ProjectUrl" : projectUrl,
		"SubjectId" : belongs
	}))

	
func delete_project():
	if not listNode.selectedItem:
		delete_dialog.get_node("HBoxContainer/Label").text = "未选择项目!"
		delete_dialog.show()
	else:
		delete_dialog.get_node("HBoxContainer/Label").text = "是否确认删除该项目!"
		delete_dialog.show()
	

func _delete_project(item):
	flush_project_info()
	listNode.selectedItem = null
	# database options
	http.request(url + "project/delete/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"ProjectId" : item.ID
	}))
	listNode.delete_item(item)


func modify_project():
	if not listNode.selectedItem:
		delete_dialog.get_node("HBoxContainer/Label").text = "未选择项目!"
		delete_dialog.show()
	else:
		modify_dialog.get_node("GridContainer/name").text = listNode.selectedItem.project_name
		modify_dialog.get_node("GridContainer/text").text = listNode.selectedItem.project_info
		modify_dialog.get_node("GridContainer/projectUrl").text = listNode.selectedItem.project_url
		modify_dialog.show()
	pass
	

func _modify_project(item, projectName, text, projectUrl):
	#item.get_child(1).text = projectName
	#item.get_child(3).get_child(5).text = text
	#item.project_name = projectName
	#item.project_info = text
	#item.project_url = projectUrl
	#item.queue_redraw()
	var nowTime = Time.get_date_string_from_system()
	#update_project_info(item)
	# database options
	http.request(url + "project/change/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"ProjectId" : item.ID,
		"ProjectName" : projectName,
		"ProjectDescription" : text,
		"CreateTime" : nowTime,
		"CreateUser" : user["UserId"],
		"ProjectUrl" : projectUrl
	}))
	pass


func run_project():
	if not listNode.selectedItem:
		delete_dialog.get_node("HBoxContainer/Label").text = "未选择项目!"
		delete_dialog.show()
	else:
		get_tree().change_scene_to_file("res://MainUI.tscn")
		get_node("/root/Global").project_path = listNode.selectedItem.project_url


func _on_new_confirm():
	var projectName = new_dialog.get_node("GridContainer/name").text
	var text = new_dialog.get_node("GridContainer/text").text
	var belongs = new_dialog.get_node("GridContainer/belongs").text
	var subID
	for item in sub_list:
		if item["SubjectName"] == belongs:
			subID = item["SubjectId"]
			break
	var projectUrl = new_dialog.get_node("GridContainer/projectUrl").text
	
	new_dialog.get_node("GridContainer/name").text = ""
	new_dialog.get_node("GridContainer/text").text = ""
	new_dialog.get_node("GridContainer/projectUrl").text = ""
	new_dialog.get_node("GridContainer/Label3").text = "项目名称不能为空!"
	new_dialog.get_ok_button().set_disabled(true)
	_new_project(projectName, text, subID, projectUrl)


func _on_delete_confirm():
	if not listNode.selectedItem:
		pass
	else:
		_delete_project(listNode.selectedItem)


func _on_modify_confirm():
	if not listNode.selectedItem:
		pass
	else:
		var projectName = modify_dialog.get_node("GridContainer/name").text
		var text = modify_dialog.get_node("GridContainer/text").text
		var projectUrl = modify_dialog.get_node("GridContainer/projectUrl").text
		_modify_project(listNode.selectedItem, projectName, text, projectUrl)


func _on_new_text_changed(new_text):
	if new_text:
		new_dialog.get_node("GridContainer/Label3").text = ""
		new_dialog.get_ok_button().set_disabled(false)
	else:
		new_dialog.get_node("GridContainer/Label3").text = "项目名称不能为空!"
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
			var proName = String(item.get_child(1).text)
			if not new_text in proName:
				item.visible = false
	else:
		for item in listNode.list:
			item.visible = true
	pass


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var res = JSON.parse_string(body.get_string_from_utf8())
		if res["status"] == 1:
			load_items(res["data"])
		elif res["status"] == 2:
			sub_list = res["data"]
		elif res["status"] == 0:
			_flush_list()
	else:
		print("Request failed with response code:", response_code)
		

func _flush_list():
	print("刷新列表")
	for child in listNode.get_children():
		listNode.remove_child(child)
	listNode.list.clear()
	flush_project_info()
	load_items_from_database()
	listNode.selectedItem = null
	pass
