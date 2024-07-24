extends Node3D


var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()

@onready var select_draw = $SelectDraw

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			selected = []
			dragging = true
			drag_start = event.position
		elif dragging:
			dragging = false
			var drag_end = event.position
			select_rectangle.size = (drag_end - drag_start).abs()
			var space = get_world_3d().direct_space_state
			var query = PhysicsShapeQueryParameters3D.new()
			query.shape = select_rectangle
			print(query.shape)
			query.transform = Transform3D(0, (drag_end - drag_start)/2)
			selected = space.intersect_shape(query)
			print(selected)
