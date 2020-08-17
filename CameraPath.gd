extends Path


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _curve = Curve3D.new()
	_curve.clear_points()
	for i in range (1, 200):
		var c = Vector3(0, i, i)
		#print(c)
		#self.curve.add_point(Vector3(0, 5*i,i ))
		_curve.add_point(c)
	self.set_curve(_curve)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
