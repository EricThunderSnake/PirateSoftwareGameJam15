extends GridMap

@export var x_range:int
@export var z_range:int
@export_range(2,1000) var max_height:int
@export_range(0,1000) var base_bound:int
var noise_array:Array[float]

var noise := FastNoiseLite.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_noise()
	generate_terrain()
	place_bases()

func generate_noise():
	noise.seed = randi()
	for x in range(-x_range,x_range): # range is from -11 (inclusive) to 11(exclusive)
		for y in range(max_height): 
			for z in range(-z_range, z_range):
				noise_array.append(noise.get_noise_2d(x+1000,z+1000))
				
	var c = (noise_array.max() - noise_array.min()*max_height)/(max_height - 1)
	var d = (noise_array.max() - noise_array.min())/(max_height - 1)
		
	for i in range(noise_array.size()):
		noise_array[i] =  (noise_array[i] + c)/d

func generate_terrain():
	var count = 0
	for x in range(-x_range,x_range): # range is from -11 (inclusive) to 11(exclusive)
		for y in range(max_height): 
			for z in range(-z_range, z_range):
				var test = noise_array[count]
				count += 1
				if y < test:
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
		
		
		
