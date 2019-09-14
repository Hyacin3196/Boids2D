extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxSpeed;
var minSpeed;
var velocity;
var maxTurnSpeed;
var target;
var antitarget;
var bounds;
var spawner;
var config;

# Called when the node enters the scene tree for the first time.
func _ready():
	maxSpeed = 130;
	minSpeed = 10;
	maxTurnSpeed = 5;
	velocity = Vector2(maxSpeed  * cos(self.rotation), maxSpeed * sin(self.rotation))
	bounds = get_node("../../Bounds");
	spawner = get_node("../../Spawner");
	config = get_node("../../Config");
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var avoidanceVector = Vector2.ZERO
	var alignmentVector = Vector2.ZERO
	var cohesionVector = Vector2.ZERO
	var cohesionNumBoids = 0
	for boid in spawner.boids:
		if self != boid :
			var distance = self.position.distance_to(boid.position)
			if distance < config.boidRange && distance != 0:
				avoidanceVector -= (boid.position - self.position).normalized() * pow(config.boidRange/distance,2.5)
			if distance < config.alignmentRange && distance != 0:
				alignmentVector += boid.velocity.normalized() * config.boidRange/distance
			if distance < config.alignmentRange && distance != 0:
				cohesionNumBoids+=1
				cohesionVector += boid.position
	if cohesionNumBoids !=0:
		cohesionVector = (cohesionVector/cohesionNumBoids  - self.position) *.25
	
	if true:
		if self.position.x + config.boidRange > bounds.right_bound:
			var distance = - self.position.x + bounds.right_bound
			if distance != 0: avoidanceVector += Vector2.LEFT * pow(config.boidRange/distance,2.5)
		elif self.position.x - config.boidRange < bounds.left_bound:
			var distance = self.position.x - bounds.left_bound
			if distance != 0: avoidanceVector += Vector2.RIGHT * pow(config.boidRange/distance,2.5)
		
		if self.position.y + config.boidRange > bounds.down_bound:
			var distance = - self.position.y + bounds.down_bound
			if distance != 0: avoidanceVector += Vector2.UP * pow(config.boidRange/distance,2.5)
		elif self.position.y + config.boidRange > bounds.up_bound:
			var distance = self.position.y - bounds.up_bound
			if distance != 0: avoidanceVector += Vector2.DOWN * pow(config.boidRange/distance,2.5)
	
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		target = get_viewport().get_mouse_position() - Vector2(bounds.right_bound,bounds.down_bound)
		antitarget = null
	elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
		antitarget = get_viewport().get_mouse_position() - Vector2(bounds.right_bound,bounds.down_bound)
		target = null
	elif Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		target = null
		antitarget = null
		
	#var acceleration = Vector2(rand_range(-20,20),rand_range(-20,20))
	var acceleration = Vector2.ZERO
	if velocity.length() < maxSpeed:
		acceleration = velocity.normalized()
	if(target != null):
		acceleration += (target - self.position).normalized() * 20
	elif antitarget != null:
		acceleration -= (antitarget - self.position).normalized() * 500/self.position.distance_to(antitarget)
	
	
	acceleration += avoidanceVector
	acceleration += alignmentVector
	acceleration += cohesionVector
	
	velocity += acceleration * 50 * delta;
	self.velocity = self.velClamp(self.velocity,minSpeed,maxSpeed)
	self.move(velocity,delta)
	self.rotation=velocity.angle()
	
	
	
	if bounds == null:
		bounds = get_node("../../Bounds");
	else:
		if self.position.y < bounds.up_bound:
			self.position.y = bounds.down_bound
		elif self.position.y > bounds.down_bound:
			self.position.y = bounds.up_bound
		
		if self.position.x < bounds.left_bound:
			self.position.x = bounds.right_bound
		elif self.position.x > bounds.right_bound:
			self.position.x = bounds.left_bound
	pass


func atanRelativeTo(relative: Vector2, vector: Vector2):
	return atan2(vector.y - relative.y, vector.x - relative.x)

func set_angle(angle):
	self.rotation = angle
	pass

func move(velocity: Vector2, delta):
	self.position.x += velocity.x * delta
	self.position.y += velocity.y * delta
	pass

func velClamp(velocity:Vector2,minimum,maximum):
	if velocity.length() < minimum:
		return velocity.normalized() * minimum
	return velocity.clamped(maximum)
