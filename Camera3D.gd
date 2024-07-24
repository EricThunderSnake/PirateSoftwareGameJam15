extends Camera3D

@onready var camera:Camera3D = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_Vector2_from_Vector3(unproject_from_Vec3:Vector3) -> Vector2:
	return camera.unproject_position(unproject_from_Vec3)
