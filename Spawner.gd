extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var numBoids;
var boids;
var spawnDistance;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	numBoids = 150
	boids = []
	spawnDistance = 100
	var scene = load("res://Boid.tscn")
	for i in numBoids:
		var scene_instance = scene.instance()
		var positionAngle = rand_range(0,2*PI)
		var positionDistance = rand_range(0,spawnDistance)
		scene_instance.set_angle(rand_range(0,2*PI));
		scene_instance.set_position(Vector2(positionDistance*cos(positionAngle),positionDistance*sin(positionAngle)))
		scene_instance.get_node("./Shape").color = Color(randf()*0.75+.25,randf()*0.75+.25,randf()*0.75+.25)
		boids.append(scene_instance)
		add_child(scene_instance)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
