extends TabContainer

var subject
var project
var http
var url = "http://127.0.0.1:8000/"
var user

var sub_data
var pro_data


func _ready():
	http = HTTPRequest.new()
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	add_child(http)
	http.request(url + "login/getuser/", [], HTTPClient.METHOD_GET, "")
	pass
	
	
func _initialize():
	subject = preload("res://UI/projectmanager/manager/Tabs/SubjectManagerTab/SubjectManagerTab.tscn").instantiate()
	subject.name = "科目管理"
	add_child(subject)
	
	project = preload("res://UI/projectmanager/manager/Tabs/ProjectManagerTab/ProjectManagerTab.tscn").instantiate()
	project.name = "项目管理"
	add_child(project)
	
	subject.listNode = subject.get_node("Panel/HSplitContainer/ListBox/HSplitContainer/ScrollContainer/List")
	subject.includedItemList = subject.get_node("Panel/HSplitContainer/ListBox/HSplitContainer/ScrollContainer2/ProjectList/Panel/projects")
	subject.user = user
	subject.url = url
	subject.includedItemList.url = url
	project.listNode = project.get_node("Panel/HSplitContainer/ListBox/HSplitContainer/ScrollContainer/List")
	project.user = user
	project.url = url
	load_from_database()
	
	
func load_from_database():
	# load_data_from_database
	subject.load_items_from_database()
	project.load_items_from_database()
	pass


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var res = JSON.parse_string(body.get_string_from_utf8())
		if res["status"] == 3:
			user = res["data"]
			_initialize()
	else:
		print("Request failed with response code:", response_code)
	pass
