extends Camera3D


var _a = false
var _s =false
var _w = false
var _d= false
var _q = false
var _e = false

var _mouse_position= Vector2(0,0)
var sec =0.5

var _dir_move
var speed= 5.0

func _ready():
	print("相机准备")
	pass
	
func _process(delta):
	#print(get_viewport().name)
	_update_move(delta)
	
	pass
	

func _update_rotate():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_position *= 0.5
		var offsetX = _mouse_position.x
		var offsetY = _mouse_position.y
		
		rotate_y(deg_to_rad(-offsetX))
		
		var r_x = get_rotation_degrees().x + - offsetY
		if r_x <= -89 or r_x >= 89:
			return
		rotate_object_local(Vector3(1,0,0),deg_to_rad(-offsetY))
		pass
	pass 

func _update_move(delta):
	_dir_move = Vector3((_d as float) - (_a as float),(_e as float) - (_q as float),(_s as float) - (_w as float))
	
	#_dir_move = self.transform.basis*_dir_move
	_dir_move = _dir_move.normalized() * speed * delta
	

	self.translate(_dir_move)
	pass
	

func get_selection():
	
	print("get_selection")
	var worldspace = get_world_3d().direct_space_state
	#获得当前场景的direct_space_state
	#可以用来进行射线检测
	var mouse_pos = get_viewport().get_mouse_position();
	print(get_viewport().name)
	print( get_viewport().get_mouse_position())
	#获得鼠标当前的屏幕坐标
	var start = project_ray_origin(mouse_pos)
	var end = start + project_ray_normal(mouse_pos) * 2000
	#计算出一条从相机出发的射线
	#起点是相机位置，方向是相机瞄准的方向
	var ray  =  PhysicsRayQueryParameters3D.create(start,end)
	print(ray.from,(ray.from-ray.to).normalized())
	#进行射线检测，检查有没有物体被击中
	var result = worldspace.intersect_ray(ray)
	print(result)
#   假如有物体被击中，且该物体有playAnimation方法
	if result and result.collider and result.collider.has_method("playAnimation"):
		result.collider.playAnimation()
#		print(result.collider)

func _input(event):
	print("input")
	
	if event is InputEventMouseMotion:
		print("eventMouseMotion")
		_mouse_position =  event.relative
	
	if event is InputEventKey:
		print("eventKey")
		match event.keycode:
			KEY_W:
				_w = event.pressed
			KEY_S:
				_s = event.pressed
			KEY_A:
				_a = event.pressed
			KEY_D:
				_d = event.pressed
			KEY_Q:
				_q = event.pressed
			KEY_E:
				_e = event.pressed
			
#
#	if event is InputEventMouseButton:
#		print("发生了鼠标事件")
#		match event.button_index:
#			MOUSE_BUTTON_RIGHT:
#				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED  
#				if event.is_pressed() else Input.MOUSE_MODE_VISIBLE)
#

		
	#假如鼠标右键按下事件
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		get_selection()
	pass
