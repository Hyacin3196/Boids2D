extends Polygon2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var height
var width
var left_bound
var right_bound 
var up_bound
var down_bound
# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_rect = get_viewport().get_visible_rect()
	height = viewport_rect.size.y *1
	width = viewport_rect.size.x*1
	
	left_bound = -width/2
	right_bound = width/2
	up_bound = -height/2
	down_bound = height/2
	
	self.polygon = [Vector2(left_bound,up_bound),
	Vector2(left_bound,down_bound),
	Vector2(right_bound,down_bound),
	Vector2(right_bound,up_bound)]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
