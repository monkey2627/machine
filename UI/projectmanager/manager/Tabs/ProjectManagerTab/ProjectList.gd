extends VBoxContainer

var list = []
var selectedItem

func _ready():
	pass
	

func add_list_item(item):
	var projectName = item["ProjectName"]
	var time = item["CreateTime"]
	var who = item["CreateUser"]
	var text = item["ProjectDescription"]
	var url = item["ProjectUrl"]
	var imgPath = item["ImgPath"]
	
	var hbox = ProjectItem.new()
	hbox.project_name = projectName
	hbox.project_info = text
	hbox.belongs = item["SubjectId"]
	hbox.project_url = url
	hbox.project_date = time
	hbox.project_user = who
	hbox.belongs_name = item["SubjectName"]
	
	if item.has("ProjectId"):
		hbox.ID = item["ProjectId"]
	
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
	
	return hbox


func delete_item(item):
	list.erase(item)
	item.queue_free()
	

func new_item(projectName, text, who, belongs, nowTime, projectUrl):
	var item = {
		"ProjectName" : projectName,
		"CreateTime" : nowTime,
		"CreateUser" : who,
		"ProjectUrl" : projectUrl,
		"ProjectDescription" : text,
		"ImgPath" : "res://UI/projectmanager/icons/2.png",
		"SubjectId" : belongs
	}
	return add_list_item(item)

	


