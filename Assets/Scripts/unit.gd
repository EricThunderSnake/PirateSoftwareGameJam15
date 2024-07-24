extends CharacterBody3D

var selected = false
@onready var mesh_instance : MeshInstance3D = $CollisionShape3D/MeshInstance3D
var default_color : Color
@export var select_color : Color = Color(1,0,0)
@export var selectable_color : Color = Color(0,0,1)
var default_mat:StandardMaterial3D
var select_mat:StandardMaterial3D
var selectable_mat:StandardMaterial3D

func _ready():
	default_mat = mesh_instance.get_surface_override_material(0)
	select_mat = StandardMaterial3D.new()
	select_mat.albedo_color = select_color
	selectable_mat = StandardMaterial3D.new()
	selectable_mat.albedo_color = selectable_color
	
	

func select():
	selected = true
	mesh_instance.set_surface_override_material(0,select_mat)

func selectable():
	mesh_instance.set_surface_override_material(0,selectable_mat)

func deselect():
	selected = false
	mesh_instance.set_surface_override_material(0,default_mat)
	
