extends Control

var learnedList
var unlearnedList
var selectedItem
var projectInfo

var learned_button
var unlearned_button
var flush_button

var http
var url = "http://127.0.0.1:8000/"
var user


func _ready():
	http = HTTPRequest.new()
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	add_child(http)
	
	learnedList = get_node("Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/Learned/List")
	unlearnedList = get_node("Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/unLearned/List")
	projectInfo = get_node("Panel/HSplitContainer/ListBox/HSplitContainer/Panel/ScrollContainer/projectInfo")
	
	learned_button = get_node("Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/Button")
	unlearned_button = get_node("Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/Button2")
	learned_button.connect("pressed", Callable(self, "_on_learned_list"))
	unlearned_button.connect("pressed", Callable(self, "_on_unlearned_list"))
	
	flush_button = get_node("Panel/HSplitContainer/ListBox/SearchBox/flush")
	flush_button.connect("pressed", Callable(self, "_flush"))
	
	http.request(url + "login/getuser/", [], HTTPClient.METHOD_GET, "")


func list_input(event, item):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT:
			item.select = true
			selectedItem = item
			for project in learnedList.list:
				if project != item:
					project.select = false
					project.queue_redraw()
			for project in unlearnedList.list:
				if project != item:
					project.select = false
					project.queue_redraw()
			update_project_info(item)


func update_project_info(item):
	projectInfo.get_node("projectBox/projectName/name").text = item.project_name
	projectInfo.get_node("projectBox/projectInfo/info").text = item.project_info
	projectInfo.get_node("projectBox/projectUrl/url").text = item.project_url
	projectInfo.get_node("belongs/name").text = item.belongs_name
	# projectInfo.get_node("learnProgress/progress").value = item.learn_progress
	# projectInfo.get_node("evaluateBox/level").text = item.learn_evaluate


func flush_project_info():
	projectInfo.get_node("projectBox/projectName/name").text = ""
	projectInfo.get_node("projectBox/projectInfo/info").text = ""
	projectInfo.get_node("projectBox/projectUrl/url").text = ""
	projectInfo.get_node("belongs/name").text = ""


func load_from_database():
	http.request(url + "project/fromuser/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"UserId" : user["UserId"],
	}))


func load_data(data):
	for item in data:
		item["ImgPath"] = "res://UI/projectmanager/icons/2.png"
		if item["Learned"]:
			learnedList.add_list_item(item)
		else:
			unlearnedList.add_list_item(item)
	for item in learnedList.list:
		item.connect("gui_input", Callable(self, "list_input").bind(item))
		item.get_child(4).get_child(0).connect("pressed", Callable(self, "_on_learn_project").bind(item))
		item.get_child(4).get_child(1).connect("pressed", Callable(self, "_on_evaluate_project").bind(item))
	for item in unlearnedList.list:
		item.connect("gui_input", Callable(self, "list_input").bind(item))
		item.get_child(4).get_child(0).connect("pressed", Callable(self, "_on_learn_project").bind(item))
		item.get_child(4).get_child(1).connect("pressed", Callable(self, "_on_evaluate_project").bind(item))
	pass


func _on_learn_project(item):
	get_tree().change_scene_to_file("res://student_view_ui.tscn")
		
	get_node("/root/Global").project_path = item.project_url
	pass
	
	
func _on_evaluate_project(item):
	print("用户查看项目评估")
	pass
	
	
func _on_learned_list():
	var see = $Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/Learned.visible
	$Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/Learned.visible = !see
	pass
	
	
func _on_unlearned_list():
	var see = $Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/unLearned.visible
	$Panel/HSplitContainer/ListBox/HSplitContainer/VBoxContainer/unLearned.visible = !see
	pass


func _on_search_item(new_text):
	if new_text:
		for item in learnedList.list:
			var proName = String(item.get_child(1).text)
			if not new_text in proName:
				item.visible = false
		for item in unlearnedList.list:
			var proName = String(item.get_child(1).text)
			if not new_text in proName:
				item.visible = false
	else:
		for item in learnedList.list:
			item.visible = true
		for item in unlearnedList.list:
			item.visible = true
	pass


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var res = JSON.parse_string(body.get_string_from_utf8())
		if res["status"] == 3:
			user = res["data"]
			load_from_database()
		elif res["status"] == 1:
			load_data(res["data"])
	else:
		print("Request failed with response code:", response_code)
	pass


func _flush():
	print("刷新列表")
	for child in learnedList.get_children():
		learnedList.remove_child(child)
	learnedList.list.clear()
	for child in unlearnedList.get_children():
		unlearnedList.remove_child(child)
	unlearnedList.list.clear()
	flush_project_info()
	load_from_database()
	pass
