extends VBoxContainer

var list = []
var selectedItem

func _ready():
	pass


func add_list_item(item):
	var subjectName = item["SubjectName"]
	var time = item["CreateTime"]
	var who = item["CreateUser"]
	var text = item["SubjectDescription"]
	var imgPath = item["ImgPath"]
	
	var hbox = HBoxContainer.new()
	hbox.set_script(load("res://UI/projectmanager/manager/Tabs/SubjectManagerTab/SubjectItem.gd"))
	
	if item.has("SubjectId"):
		hbox.ID = item["SubjectId"]
	
	var img = TextureRect.new()
	img.texture = load(imgPath)
	img.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var label = Label.new()
	label.text = subjectName
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
	l5.text = "科目描述:"
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
	

func new_item(subjectName, text, who, nowTime):
	var item = {
		"SubjectName" : subjectName,
		"CreateTime" : nowTime,
		"CreateUser" : who,
		"SubjectDescription" : text,
		"ImgPath" : "res://icon.svg"
	}
	return add_list_item(item)

	


