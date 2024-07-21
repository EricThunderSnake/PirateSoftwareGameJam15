extends GridMap

var noise := FastNoiseLite.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	for x in range(-11,11):
		for y in range(30):
			for z in range(-11,11):
				if y < noise.get_noise_2d(x,z)*8+1:
					set_cell_item(Vector3i(x,y,z),0)

