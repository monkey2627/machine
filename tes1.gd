extends Node2D
@onready var camera = $"../../../../SubViewport_3D/Node3D/Camera3D"
@onready var ray_cast_3d = $"../../../../SubViewport_3D/Node3D/Camera3D/RayCast3D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mouse_pos:Vector2 = get_local_mouse_position()
	
	var start = camera.project_ray_origin(mouse_pos)
	$"../../../../SubViewport_3D/Node3D/MeshInstance3D".position = start
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("mouse_left_click"):
		print("hhha")
	var mouse_pos:Vector2 = get_local_mouse_position()
	var start = camera.position
	ray_cast_3d.target_position = start + camera.project_ray_normal(mouse_pos) * 10000
	ray_cast_3d.force_raycast_update()
	#$"../Node3D/MeshInstance3D2".position=start + camera.project_ray_normal(mouse_pos) * 10
	pass
func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		# and event.is_action_pressed("mouse_left_click"):
		#print(event.position)
		pass
