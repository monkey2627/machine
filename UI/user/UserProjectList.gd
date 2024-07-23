extends VBoxContainer

var list = []


func _ready():
	pass


func add_list_item(item):
	var imgPath = item["ImgPath"]
	var projectName = item["ProjectName"]
	var time = item["CreateTime"]
	var who = item["CreateUser"]
	
	var hbox = UserProjectItem.new()
	
	hbox.ID = item["ProjectId"]
	hbox.project_name = projectName
	hbox.project_info = item["ProjectDescription"]
	hbox.project_date = time
	hbox.belongs = item["SubjectId"]
	hbox.belongs_name = item["SubjectName"]
	hbox.project_url = item["ProjectUrl"]
	hbox.project_user = who
	
	hbox.is_learned = item["Learned"]
	
	# hbox.set_script(load("res://UI/user/UserProjectItem.gd"))
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
	gbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gbox.columns = 2
	var l1 = Label.new()
	var l2 = Label.new()
	var l3 = Label.new()
	var l4 = Label.new()
	l1.text = "创建时间:"
	l1.custom_minimum_size = Vector2(30, 0)
	l2.text = time
	l3.text = "创建人:"
	l4.text = who
	gbox.add_child(l1)
	gbox.add_child(l2)
	gbox.add_child(l3)
	gbox.add_child(l4)
	hbox.add_child(gbox)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	var begin = Button.new()
	begin.text = "开始学习"
	begin.icon = load("res://UI/projectmanager/icons/MainPlay.svg")
	var evaluate = Button.new()
	evaluate.text = "查看评估"
	evaluate.icon = load("res://UI/projectmanager/icons/File.svg")
	vbox.add_child(begin)
	vbox.add_child(evaluate)
	hbox.add_child(vbox)
	
	add_child(hbox)
	list.append(hbox)
	return hbox


func _process(delta):
	pass
