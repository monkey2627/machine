extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready():
	var vsb := $".".get_v_scroll_bar() as VScrollBar
	vsb.custom_minimum_size.x = 50
	vsb.position.x = vsb.position.x - 25


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
