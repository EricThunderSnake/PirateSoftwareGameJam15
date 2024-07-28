extends CharacterBody3D

const module_camera:GDScript = preload("res://Assets/Scripts/module_camera.gd")

var steer_speed:float  = 4.0
var nav_path_goal_position:Vector3

@onready var nav_path_timer:Timer = $Timer
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var gravity_raycast:RayCast3D = $RayCast3D

@export var rotation_fast:bool = false

var stuck_max:int = 9
var stuck_count:int = 0
var last_position:Vector3

var selected = false
@onready var mesh_instance : MeshInstance3D = $CollisionShape3D/MeshInstance3D
var default_color : Color
@export var select_color : Color = Color(1,0,0)
@export var selectable_color : Color = Color(0,0,1)
var default_mat:StandardMaterial3D
var select_mat:StandardMaterial3D
var selectable_mat:StandardMaterial3D

func _ready():
	
	set_max_slides(2)
	nav_agent.velocity_computed.connect(char_move)
	nav_path_timer.timeout.connect(nav_path_timer_update)
	
	default_mat = mesh_instance.get_surface_override_material(0)
	select_mat = StandardMaterial3D.new()
	select_mat.albedo_color = select_color
	selectable_mat = StandardMaterial3D.new()
	selectable_mat.albedo_color = selectable_color

func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_leftclick"):
		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		var camera:Camera3D = get_viewport().get_camera_3d()
		var camera_raycast_coords:Vector3 = module_camera.get_vector3_from_camera_raycast(camera,mouse_pos)
		if camera_raycast_coords != Vector3.ZERO:
			nav_agent.set_target_position(camera_raycast_coords)
			nav_path_goal_position = camera_raycast_coords

func _physics_process(delta:float) -> void:
	if nav_agent.is_navigation_finished(): return
	
	position.y = gravity_raycast.get_collision_point().y + 0.4

	var next_position:Vector3 = nav_agent.get_next_path_position()
	var direction:Vector3 = global_position.direction_to(next_position) * nav_agent.max_speed
	
	rotate_to_direction(direction,delta)
	
	var steered_velocity:Vector3 = (direction - velocity) * delta * steer_speed
	var new_agent_velocity:Vector3 = velocity + steered_velocity
	nav_agent.set_velocity(new_agent_velocity)

func rotate_to_direction(dir:Vector3,delta:float) -> void:
	if rotation_fast:
		rotation.y = atan2(-dir.x,-dir.z)
	else:
		var pos_2D:Vector2 = Vector2(-transform.basis.z.x,-transform.basis.z.z)
		var goal_2D:Vector2 = Vector2(dir.x,dir.z)
		rotation.y -= pos_2D.angle_to(goal_2D) * delta * steer_speed

func nav_path_timer_update() -> void:
	if nav_agent.is_navigation_finished(): return
	nav_agent.set_target_position(nav_path_goal_position)
	stuck_check()
	last_position = global_position

func stuck_check() -> void:
	if last_position.distance_squared_to(global_position) < 0.8:
		if stuck_count < stuck_max: stuck_count += 1
	
	if stuck_count >= 3:
		if global_position.distance_squared_to(nav_path_goal_position) < 10.0 or stuck_count >= stuck_max:
			cancel_navigation()
			stuck_count == 0
			
			

func cancel_navigation() -> void:
	nav_agent.emit_signal("navigation_finished")
	nav_agent.set_target_position(global_position)

func char_move(new_velocity:Vector3) -> void:
	velocity = new_velocity
	
	var collision:KinematicCollision3D = move_and_collide(velocity * get_physics_process_delta_time())
	if collision:
		var collider:Object = collision.get_collider()
		if collider is CharacterBody3D:
			velocity = velocity.slide(collision.get_normal())
		elif collider is StaticBody3D:
			move_and_slide()
	
	#move_and_slide()


func select():
	selected = true
	mesh_instance.set_surface_override_material(0,select_mat)

func selectable():
	mesh_instance.set_surface_override_material(0,selectable_mat)

func deselect():
	selected = false
	mesh_instance.set_surface_override_material(0,default_mat)
	
