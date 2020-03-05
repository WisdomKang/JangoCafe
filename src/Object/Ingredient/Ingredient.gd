extends StaticBody2D

class_name Ingredient

const POSITION = { 
		FRONT=Vector2(0,16), 
		BACK=Vector2(0, -24), 
		LEFT=Vector2(-40, 0), 
		RIGHT=Vector2(40 ,0),
		CATCH=Vector2(0,-12),
		NOMAL=Vector2(0,0)
	}

var player:KinematicBody2D


onready var shadow: = $IngredientShader

var object_position:Vector2 = POSITION.NOMAL

func _ready():
	pass
	
func _physics_process(delta):
	if player != null:
		pass
		
	
func catched(player):
	print("test")
	


func _on_Area2D_body_entered(body):
	print(body.name)
