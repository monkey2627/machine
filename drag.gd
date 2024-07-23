extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:	
		print("get")
	pass # Replace with function body.
