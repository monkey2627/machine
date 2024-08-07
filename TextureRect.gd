extends TextureRect

@onready var camera = $"../../../SubViewport_3D/Node3D/Camera3D"
@onready var ray_cast_3d = $"../../../SubViewport_3D/Node3D/Camera3D/RayCast3D"
# Called when the node enters the scene tree for the first time.
var col:Object = null
var axis:Object = null
var selected_object = null
var timer = 0
var first:bool = true
var last:Vector3
var now:Vector3



var _a = false
var _s =false
var _w = false
var _d= false
var _q = false
var _e = false

var _mouse_position= Vector2(0,0)
var sec =0.5
var _dir_move
var speed= 10.0
var move = 0
var first_ = false	
var before_
var now_
@onready var Axis:Object = $"../../../../../../../../../../axis"
var center
var x_li
var y_li
var z_li
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("quit"):
		Axis.visible = false
		selected_object = null
	
	if Input.is_action_pressed("cameraRotatel"):
		camera.rotation += Vector3(0,0.05,0)
	if Input.is_action_pressed("camraRotater"):
		camera.rotation += Vector3(0,-0.05,0)
			
	timer += 1
	if timer > 100:
			timer = 0
	var mouse_pos = get_local_mouse_position()
	#print(mouse_pos)
	var start = camera.project_ray_origin(mouse_pos)
	ray_cast_3d.target_position = camera.project_local_ray_normal(mouse_pos) * 10000
	ray_cast_3d.force_raycast_update()
	$"../../../SubViewport_3D/Node3D/MeshInstance3D2".position = camera.position + camera.project_ray_normal(mouse_pos) * 10
	
	if selected_object == null:
		if ray_cast_3d.is_colliding():
			col = ray_cast_3d.get_collider()
			print(ray_cast_3d.get_collider().name)
			if col !=null && Input.is_action_pressed("drag") && selected_object == null && timer > 10:
				print("select:"+col.name)
				selected_object = col
				timer = 0
				Axis.visible = true
				Axis.position = ray_cast_3d.get_collision_point()
				center = Axis.position
				print(selected_object.get_parent().name)
			elif  col == null:
				selected_object = null
		else:
			col = null
	else:#如果已经有选中物体
		move += 1
		#如果鼠标左键点击并且已有选中物体
		if Input.is_action_pressed("drag") :
			axis = ray_cast_3d.get_collider()
			if(axis == null):
				print("you did not click on the obj")
			elif axis != null && axis.name == "x":
				print("click")
				if move >= 10:
					first = true
					move = 0
				if first == true:
					last = ray_cast_3d.get_collision_point() 
					move = 0
					first = false
				else:
					move = 0
					now = ray_cast_3d.get_collision_point() 
					Axis.position +=  Vector3((now-last).x,0,0) 
					selected_object.get_parent().position += Vector3((now-last).x*400,0,0) 
					last = now
			elif axis != null && axis.name == "y":
				if move >= 10:
					first = true
					move = 0
				if first == true:
					last = ray_cast_3d.get_collision_point() 
					move = 0
					first = false
				else:
					move = 0
					now = ray_cast_3d.get_collision_point() 
					Axis.position +=  Vector3(0,(now-last).y,0) 
					selected_object.get_parent().position += Vector3(0,(now-last).y*400,0) 
					last = now
			elif axis != null && axis.name == "z":
				if move >= 10:
					first = true
					move = 0
				if first == true:
					last = ray_cast_3d.get_collision_point() 
					move = 0
					first = false
				else:
					move = 0
					now = ray_cast_3d.get_collision_point() 
					Axis.position +=  Vector3(0,0,(now-last).z) 
					selected_object.get_parent().position += Vector3(0,0,(now-last).z*400) 
					last = now
			elif  axis != null:
				selected_object = axis
