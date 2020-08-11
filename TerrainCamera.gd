extends KinematicBody

onready var terrain = get_node("../WorldState/Terrain")
var circle_rot_phi =  0
var circle_rot_velocity = 0
var pitch_rot_phi = 0
var pitch_rot_velocity = 0
var zoom_path_velocity = 0
var trans_velocity = Vector3()
var is_middle_dragging = false
const ZOOM_DECEL = .9
const TRANSLATION_SPEED = .5
const TRANSLATION_DECEL = .75
const MOUSE_PITCH_SENSITIVITY = .25
const MOUSE_CIRCLE_SENSITIVITY = .15


var map_extents = Vector3()

func init_camera(_map_extents):
	self.map_extents = _map_extents
	var pos = terrain.rand_point_on_terrain()
	#pos.y += 10
	self.translation = pos



func _physics_process(delta):
	
	$Circler.rotation.y += circle_rot_velocity
	circle_rot_phi = $Circler.rotation.y
	circle_rot_velocity*=.75
	
	$Circler/Path/PathFollow/Boom/rotatex.rotation.x += pitch_rot_velocity
	pitch_rot_velocity *=.25
	
	$Circler/Path/PathFollow.offset+=zoom_path_velocity
	zoom_path_velocity*=ZOOM_DECEL
	
	self.translation += trans_velocity
	
	self.translation.x = clamp(self.translation.x, 0, map_extents.x)
	self.translation.z = clamp(self.translation.z, 0, map_extents.z)
	
	trans_velocity*=TRANSLATION_DECEL
	
	#if not is_on_floor():
#		velocity += gravity * delta
		#$onFloor.visible=true
	#else:
		#$onFloor.visible=false
	#get_input(delta)

func camera_pitch_x(amount):
	pitch_rot_velocity+=amount * .01	
	
func on_camera_move_vertical(amount):
	zoom_path_velocity+= amount * .04

func camera_circle(_phi_inc):
	circle_rot_velocity += _phi_inc * .01

func on_camera_move_z(amount):
	var move = Vector3(0, 0, amount * TRANSLATION_SPEED).rotated(Vector3.UP, circle_rot_phi)
	trans_velocity+=move

func on_camera_move_x(amount):
	var move = Vector3(amount * TRANSLATION_SPEED, 0, 0).rotated(Vector3.UP, circle_rot_phi)
	trans_velocity+=move

func _input(event):
#	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.is_pressed():
#		is_dragging = true
#	if (event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and not event.is_pressed()):
#		is_dragging = false
	if (event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE and event.is_pressed()):
		is_middle_dragging = true
	if (event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE and not event.is_pressed()):
		is_middle_dragging = false
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			on_camera_move_vertical(-15)

		if event.button_index == BUTTON_WHEEL_DOWN:
			on_camera_move_vertical(15)

	#do the right-click dragging if we are dragging.
#	if (is_dragging and event is InputEventMouseMotion ):
#		on_camera_move_x(event.relative.x)
#		on_camera_move_z(event.relative.y)

	if (is_middle_dragging and event is InputEventMouseMotion ):	
		camera_circle(-event.relative.x*MOUSE_CIRCLE_SENSITIVITY)
		camera_pitch_x(-event.relative.y * MOUSE_PITCH_SENSITIVITY)

func _process(delta):
	
	if Input.is_action_pressed("CamPanFront"):
		on_camera_move_z(-1)
	if Input.is_action_pressed("CamPanBack"):
		on_camera_move_z(1)
	if Input.is_action_pressed("CamPanLeft"):
		on_camera_move_x(-1)
	if Input.is_action_pressed("CamPanRight"):
		on_camera_move_x(1)
	
	if Input.is_action_pressed("CamPanUp"):
		on_camera_move_vertical(15)
	if Input.is_action_pressed("CamPanDown"):
		on_camera_move_vertical(-15)
	
	
	if Input.is_action_pressed("CamPitchDown"):
		#TODO: inverted mouse?
		camera_pitch_x(-1)
	if Input.is_action_pressed("CamPitchUp"):
		camera_pitch_x(1)
	if Input.is_action_pressed("CamCircleLeft"):
		camera_circle(1)
	if Input.is_action_pressed("CamCircleRight"):
		camera_circle(-1)
