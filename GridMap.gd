extends GridMap

@export var x_range:int
@export var z_range:int
@export_range(0,1000) var base_bound:int

var noise := FastNoiseLite.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_terrain()
	place_bases()

func generate_terrain():
	noise.seed = randi()
	for x in range(-x_range,x_range): # range is from -11 (inclusive) to 11(exclusive)
		for y in range(30): 
			for z in range(-z_range, z_range):
				if y < noise.get_noise_2d(x,z)*8+2 or y == 0:
					set_cell_item(Vector3i(x,y,z),0)

func place_bases():
	var x := randi_range(-x_range+1,-x_range+base_bound)
	var z := randi_range(-z_range+1,z_range-2)
	var y = 0
	while true:
		if get_cell_item(Vector3i(x,y,z)) == INVALID_CELL_ITEM:
			set_cell_item(Vector3i(x,y,z),1)
			print("x: ",x,", y: ",y,", z: ",z)
			break
		y += 1
		
		
		
