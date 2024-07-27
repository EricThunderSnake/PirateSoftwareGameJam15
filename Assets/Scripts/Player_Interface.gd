extends Node2D

@onready var player_camera:Node3D = $"../Camera3D"
@onready var player_camera_visibleunits_Area3D:Area3D = $"../Camera3D/visibleunits_Area3D"
@onready var ui_dragbox:NinePatchRect = $ui_dragbox


@onready var BoxSelectionUnits_Visible:Dictionary = {}

const min_drag_squared:int = 128

enum MOUSE_LEFT_CLICK {RELEASE, PRESS}

var mouse_left_click:MOUSE_LEFT_CLICK  = MOUSE_LEFT_CLICK.RELEASE
var drag_rectangle_area:Rect2

# Called when the node enters the scene tree for the first time.
func _ready():
	initialise_interface()

func unit_entered(unit:Node3D):
	var unit_id:int = unit.get_instance_id()
	if BoxSelectionUnits_Visible.keys().has(unit_id):return
	BoxSelectionUnits_Visible[unit_id] = unit
	print("unit entered ", unit_id, unit.name)



func unit_exited(unit:Node3D):
	var unit_id:int = unit.get_instance_id()
	if !BoxSelectionUnits_Visible.keys().has(unit_id):return
	BoxSelectionUnits_Visible.erase(unit_id)
	print("unit entered ", unit_id, unit.name)


func initialise_interface():
	ui_dragbox.visible = false
	player_camera_visibleunits_Area3D.body_entered.connect(unit_entered)
	player_camera_visibleunits_Area3D.body_exited.connect(unit_exited)

func _input(event:InputEvent):
	if Input.is_action_just_pressed("mouse_leftclick"):
		drag_rectangle_area.position = get_global_mouse_position()
		ui_dragbox.position = drag_rectangle_area.position
		mouse_left_click = MOUSE_LEFT_CLICK.PRESS
	if Input.is_action_just_released("mouse_leftclick"):
		mouse_left_click = MOUSE_LEFT_CLICK.RELEASE
		ui_dragbox.visible = false
		cast_selection()

func cast_selection():
	for unit in BoxSelectionUnits_Visible.values():
		#if there is time, I want to replace the player_camera.get_Vector2.... with a solution that allows
		#the player to select a unit by overlap the unit mesh instead of the origin
		if drag_rectangle_area.abs().has_point(player_camera.get_Vector2_from_Vector3(unit.transform.origin)):
			unit.select()
		else:
			unit.deselect()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if mouse_left_click == MOUSE_LEFT_CLICK.PRESS:
		drag_rectangle_area.size = get_global_mouse_position() - drag_rectangle_area.position
		update_ui_dragbox()
		if !ui_dragbox.visible:
			if drag_rectangle_area.size.length_squared() > min_drag_squared:
				ui_dragbox.visible = true
			

func update_ui_dragbox() -> void:
	ui_dragbox.size = abs(drag_rectangle_area.size)
	
	ui_dragbox.scale.x = sign(drag_rectangle_area.size.x)
	ui_dragbox.scale.y = sign(drag_rectangle_area.size.y)









