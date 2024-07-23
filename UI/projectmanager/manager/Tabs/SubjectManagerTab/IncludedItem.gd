extends VBoxContainer

var list = []
var http
var url

func _ready():
	http = HTTPRequest.new()
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	add_child(http)
	pass
	

func load_items_from_database():
	http.request(url + "project/get/", [], HTTPClient.METHOD_POST, JSON.stringify({
		"ProjectId" : null,
	}))
	

func load_items(data):
	for item in data:
		item["ImgPath"] = "res://UI/projectmanager/icons/1.png"
		add_list_item(item)


func add_list_item(item):
	var projectName = item["ProjectName"]
	var time = item["CreateTime"]
	var who = item["CreateUser"]
	var text = item["ProjectDescription"]
	var imgPath = item["ImgPath"]
	
	var hbox = ProjectItem.new()
	hbox.ID = item["ProjectId"]
	hbox.belongs = item["SubjectId"]
	# hbox.set_script(load("res://UI/projectmanager/manager/Tabs/ProjectManagerTab/ProjectItem.gd"))
	var img = TextureRect.new()
	img.texture = load(imgPath)
	img.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var label = Label.new()
	label.text = projectName
	label.custom_minimum_size = Vector2(120, 0)
	var split = VSeparator.new()
	hbox.add_child(img)
	hbox.add_child(label)
	hbox.add_child(split)
	
	var gbox = GridContainer.new()
	gbox.columns = 2
	var l1 = Label.new()
	var l2 = Label.new()
	var l3 = Label.new()
	var l4 = Label.new()
	var l5 = Label.new()
	var l6 = Label.new()
	l1.text = "创建时间:"
	l2.text = time
	l3.text = "创建人:"
	l4.text = who
	l5.text = "项目描述:"
	l6.text = text
	gbox.add_child(l1)
	gbox.add_child(l2)
	gbox.add_child(l3)
	gbox.add_child(l4)
	gbox.add_child(l5)
	gbox.add_child(l6)
	
	hbox.add_child(gbox)
	add_child(hbox)
	list.append(hbox)
	hbox.visible = false
	return hbox


func update_list(selectedID):
	for item in list:
		if item.belongs == selectedID:
			item.visible = true
		else:
			item.visible = false


func _flush_list():
	for child in list:
		remove_child(child)
	list.clear()
	pass


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var res = JSON.parse_string(body.get_string_from_utf8())
		if res["status"] == 1:
			load_items(res["data"])
	else:
		print("Request failed with response code:", response_code)
	pass
