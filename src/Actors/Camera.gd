extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var zoomSpd=0.1
export var cameraSpd=500
var frame=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.get_action_strength("ui_page_up"):
		zoom-=Vector2(zoomSpd,zoomSpd)*delta
		#print(zoom)
			
	if Input.get_action_strength("ui_page_down"):
		zoom+=Vector2(zoomSpd,zoomSpd)*delta	
		#print(zoom)
		
	if Input.get_action_strength("ui_left"):
		position-=Vector2(cameraSpd,0)*delta
			
	if Input.get_action_strength("ui_right"):
		position+=Vector2(cameraSpd,0)*delta	
	
	if Input.get_action_strength("ui_up"):
		position-=Vector2(0,cameraSpd)*delta
			
	if Input.get_action_strength("ui_down"):
		position+=Vector2(0,cameraSpd)*delta
			
			
	pass
	
	
	
func print_zoom():
		print("zoom"+str(zoom))
		pass
