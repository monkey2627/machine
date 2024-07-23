extends Control
@onready var student_user_name := $Panel/VBoxContainer2/HBoxContainer/LineEdit
@onready var subject_add := $Panel/VBoxContainer2/HBoxContainer2/subject_add
@onready var project_add := $Panel/VBoxContainer2/HBoxContainer3/project_add
@onready var stu_info_show_vboxcontainer :=$Panel/VBoxContainer/HBoxContainer/studentInfo/VBoxContainer
@onready var stu_project_show_vboxcontainer := $Panel/VBoxContainer/HBoxContainer/stu_projectInfp/VBoxContainer
@onready var select_user_name :=$Panel/VBoxContainer2/HBoxContainer/LineEdit
var subject_id_all=[]
var project_id_all=[]
var subject_id_name:Dictionary
var student_info_all=[]
var student_project=[]
var flag_p=0
var flag_u=0
var subject_choose_id=-1
var project_choose_id=-1
var select_user_id
var student_id=[]
var vboxcontainer_student = VBoxContainer.new()
var vboxcontainer_project = VBoxContainer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_students_info()
	get_all_subject_info()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_all_subject_info():
	flag_p=1
	var data_to_send  = {"SubjectId":null}
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest_p.request("http://127.0.0.1:8000/subject/get/", headers, HTTPClient.METHOD_POST, json)

func get_projectinfo_from_subject(id):
	flag_p=2
	var data_to_send = {"SubjectId":id}
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest_p.request("http://127.0.0.1:8000/project/fromsubject/", headers, HTTPClient.METHOD_POST, json)

func get_project_from_student(UserId):
	flag_p=3
	var data_to_send = {"UserId":UserId}
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest_p.request("http://127.0.0.1:8000/project/fromuser/", headers, HTTPClient.METHOD_POST, json)

func get_students_info():
	flag_u = 1
	var data_to_send:Dictionary = {"table":"UserRole","selectType":"RoleName","condition":"学生"}
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest_u.request("http://127.0.0.1:8000/select-data/", headers, HTTPClient.METHOD_POST, json)

func  flush_stu_project(name):
	flag_u = 2
	var data_to_send:Dictionary = {"table":"UserRole","selectType":"UserName","condition":name} 
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest_u.request("http://127.0.0.1:8000/select-data/", headers, HTTPClient.METHOD_POST, json)



func show_studentinfo_inscreen():
	vboxcontainer_student.free()
	vboxcontainer_student = VBoxContainer.new()
	var hboxcontainer_title = HBoxContainer.new()
	
	stu_info_show_vboxcontainer.add_child(vboxcontainer_student)
	vboxcontainer_student.add_child(hboxcontainer_title)
	var line_edit_1_title = LineEdit.new()
	var line_edit_2_title = LineEdit.new()

	line_edit_1_title.set_custom_minimum_size(Vector2(100,0))
	line_edit_2_title.set_custom_minimum_size(Vector2(100,0))
	line_edit_1_title.text="用户Id"
	line_edit_2_title.text="账号"

	line_edit_1_title.editable = false
	line_edit_2_title.editable = false
	
	hboxcontainer_title.add_child(line_edit_1_title)
	hboxcontainer_title.add_child(line_edit_2_title)
	for i in range(student_info_all.size()):
		var hboxcontainer = HBoxContainer.new()
		vboxcontainer_student.add_child(hboxcontainer)
	
		
		var line_edit_1 = LineEdit.new()
		var line_edit_2 = LineEdit.new()
	
		line_edit_1.set_custom_minimum_size(Vector2(100,0))
		line_edit_2.set_custom_minimum_size(Vector2(100,0))
		student_id.append(student_info_all[i]["UserId"])
		line_edit_1.text=str(student_info_all[i]["UserId"])
		line_edit_2.text=student_info_all[i]["UserName"]
	
		line_edit_1.editable = false
		line_edit_2.editable = false

		hboxcontainer.add_child(line_edit_1)
		hboxcontainer.add_child(line_edit_2)

func show_stu_project_inscreen():
	
	stu_project_show_vboxcontainer.add_child(vboxcontainer_project)
	
	if len(student_project)==0:
		var hboxcontainer = HBoxContainer.new()
		vboxcontainer_project.add_child(hboxcontainer)
	
		
		var line_edit_1 = LineEdit.new()
		var line_edit_2 = LineEdit.new()
		var line_edit_3 = LineEdit.new()
		var line_edit_4 = LineEdit.new()
	
		line_edit_1.set_custom_minimum_size(Vector2(80,0))
		line_edit_2.set_custom_minimum_size(Vector2(80,0))
		line_edit_3.set_custom_minimum_size(Vector2(80,0))
		line_edit_4.set_custom_minimum_size(Vector2(80,0))

		line_edit_1.text=str(select_user_id)
		line_edit_2.text=select_user_name.text
		line_edit_3.text=""
		line_edit_4.text=""
	
		line_edit_1.editable = false
		line_edit_2.editable = false
		line_edit_3.editable = false
		line_edit_4.editable = false

		hboxcontainer.add_child(line_edit_1)
		hboxcontainer.add_child(line_edit_2)
		hboxcontainer.add_child(line_edit_3)
		hboxcontainer.add_child(line_edit_4)
	

	for i in range(student_project.size()):
		var hboxcontainer = HBoxContainer.new()
		vboxcontainer_project.add_child(hboxcontainer)
	
		
		var line_edit_1 = LineEdit.new()
		var line_edit_2 = LineEdit.new()
		var line_edit_3 = LineEdit.new()
		var line_edit_4 = LineEdit.new()
	
		line_edit_1.set_custom_minimum_size(Vector2(80,0))
		line_edit_2.set_custom_minimum_size(Vector2(80,0))
		line_edit_3.set_custom_minimum_size(Vector2(80,0))
		line_edit_4.set_custom_minimum_size(Vector2(80,0))

		line_edit_1.text=str(select_user_id)
		line_edit_2.text=select_user_name.text
		if str(student_project[i]["SubjectId"])!="":
			line_edit_3.text=subject_id_name[str(student_project[i]["SubjectId"])]
		else:
			line_edit_3.text=""
		line_edit_4.text=student_project[i]["ProjectName"]
	
		line_edit_1.editable = false
		line_edit_2.editable = false
		line_edit_3.editable = false
		line_edit_4.editable = false

		hboxcontainer.add_child(line_edit_1)
		hboxcontainer.add_child(line_edit_2)
		hboxcontainer.add_child(line_edit_3)
		hboxcontainer.add_child(line_edit_4)





func _on_http_request_request_completed(result, response_code, headers, body):
	var test = JSON.parse_string(body.get_string_from_utf8())
	
	if flag_p == 1 and test["status"]==2 :
		subject_add.get_popup().set_item_text(0,test["data"][0]["SubjectName"])
		subject_id_all.append(test["data"][0]["SubjectId"])
		subject_id_name[str(test["data"][0]["SubjectId"])]=test["data"][0]["SubjectName"]
		for i in range(1,len(test["data"])):
			subject_add.get_popup().add_item(test["data"][i]["SubjectName"])
			subject_id_all.append(test["data"][i]["SubjectId"])
			subject_id_name[str(test["data"][i]["SubjectId"])] = test["data"][i]["SubjectName"]
	if flag_p==2 and test["status"]==1 :
		project_add.get_popup().clear()
		project_id_all=[]
		if len(test["data"])!=0:
			project_add.get_popup().add_item(test["data"][0]["ProjectName"])
			project_id_all.append(test["data"][0]["ProjectId"])
		
		for i in range(1,len(test["data"])):
			project_add.get_popup().add_item(test["data"][i]["ProjectName"])
			project_id_all.append(test["data"][i]["ProjectId"])
	if flag_p==3 and test["status"]==1 :
		student_project=test["data"]
		print(student_project)
		show_stu_project_inscreen()
	if flag_p==4 and test["status"]==0:
		vboxcontainer_project.free()
		vboxcontainer_project=VBoxContainer.new()
		flush_stu_project(student_user_name.text)
	pass # Replace with function body.

func _on_line_edit_text_changed(new_text):
	print(new_text)
	vboxcontainer_project.free()
	vboxcontainer_project=VBoxContainer.new()
	if new_text!="":
		flush_stu_project(new_text)
	pass # Replace with function body.
	

func _on_subject_add_toggled(button_pressed):
	subject_choose_id = subject_add.get_popup().get_focused_item()
	
	if subject_choose_id != -1:
		project_add.text="选择项目"
		project_add.get_popup().clear()
		get_projectinfo_from_subject(subject_id_all[subject_choose_id])
		subject_add.text = subject_add.get_popup().get_item_text(subject_choose_id)
		
	pass # Replace with function body.

func _on_project_add_toggled(button_pressed):
	project_choose_id = project_add.get_popup().get_focused_item()
	if project_choose_id!=-1:
		project_add.text =project_add.get_popup().get_item_text(project_choose_id)
	pass # Replace with function body.

func _on_button_add_pressed():
	flag_p = 4
	var data_to_send  = {"UserId":select_user_id,"ProjectId":project_id_all[project_choose_id]}
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest_p.request("http://127.0.0.1:8000/project/AddToUser/", headers, HTTPClient.METHOD_POST, json)
	pass # Replace with function body.


func _on_button_delete_pressed():
	flag_p = 4
	var data_to_send  = {"UserId":select_user_id,"ProjectId":project_id_all[project_choose_id]}
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest_p.request("http://127.0.0.1:8000/project/DeleteFromUser/", headers, HTTPClient.METHOD_POST, json)
	pass # Replace with function body.
	pass # Replace with function body.


func _on_http_request_u_request_completed(result, response_code, headers, body):
	var test = JSON.parse_string(body.get_string_from_utf8())
	
	if flag_u == 1 and test[0]["message"]=="0" :
		student_info_all = test
		show_studentinfo_inscreen()
	if flag_u == 2 and test[0]["message"]=="0" :
		select_user_id = test[0]["UserId"]
		if test[0]["UserId"] in student_id:
			get_project_from_student(int(select_user_id))
		
	pass # Replace with function body.















