extends KinematicBody2D

class_name Player

var _velocity:Vector2 = Vector2()
export var speed: = 400.0

enum STATE { CATCH, COOKING, NONE }
const OBJECT_POSITION = { FRONT=Vector2(0,16), BACK=Vector2(0, -24), LEFT=Vector2(-40, 0), RIGHT=Vector2(40 ,0) }

onready var anim_player:AnimationPlayer = $AnimationPlayer
onready var char_texture:Sprite = $CharactorPostion/CharactorImg

var catch_object:StaticBody2D = null
var detected_object
var hand_state = STATE.NONE

var object_position: Vector2 = Vector2()

signal test_signal(test_text)


var jango_motion = {
	"front": preload("res://asset/charactor/Jango_front.png"),
	"back" : preload("res://asset/charactor/Jango_back.png"),
	"side" : preload("res://asset/charactor/Jango_side.png"),
	"side_catch" : preload("res://asset/charactor/Jango_side_catch.png")
}

func _on_object_body_entered(body):
	print("body entered")
	detected_object = body

func _on_object_body_exited(body):
	print("body exited")
	detected_object = null
	
	
func _physics_process(delta):
	_velocity = get_direction() * speed
	_velocity = move_and_slide( _velocity )
	action_object()
	
	
func get_direction() -> Vector2:
	var move_vector:Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if move_vector.length() != 0:
		if move_vector.x != 0:
			if move_vector.x > 0:
				char_texture.flip_h = true
				object_position = OBJECT_POSITION.RIGHT
			else:
				char_texture.flip_h = false
				object_position = OBJECT_POSITION.LEFT
			
			if hand_state == STATE.CATCH:
				char_texture.set_texture( jango_motion["side_catch"])
			else:
				char_texture.set_texture( jango_motion["side"])
			
			
			
		elif move_vector.y !=0:
			if move_vector.y > 0:
				object_position = OBJECT_POSITION.FRONT
				char_texture.set_texture( jango_motion["front"] )
			else:
				object_position = OBJECT_POSITION.BACK
				char_texture.set_texture(jango_motion["back"])
		
		if catch_object:
			catch_object.get_node("AnimationPlayer").play("catch_move")
		anim_player.play("move_motion")
	else:
		if catch_object:
			catch_object.get_node("AnimationPlayer").play("stop")
		anim_player.play("stop")
		
	return  move_vector


func action_object():
	if Input.is_action_just_pressed("ui_select") && detected_object != null && catch_object == null:
		catch_object = detected_object
		call_deferred("catch_action", catch_object)
	elif Input.is_action_just_pressed("ui_select") && catch_object != null:
		var realese_postion = get_global_position() + object_position
		print("put object")
		call_deferred("object_put_action", catch_object, realese_postion)
		
	if catch_object:
		catch_object.set_position( object_position )
		
		
	if Input.is_action_just_pressed("test_input"):
		emit_signal("test_signal", "test signal trans?")
		
		
func catch_action(object:Node2D):
	hand_state = STATE.CATCH
	object.get_parent().remove_child(object)
	self.get_node("ObjectPosition").add_child(object)
	

	
func object_put_action(object:Node2D, position:Vector2):
	hand_state = STATE.NONE
	object.get_parent().remove_child(object)
	get_parent().add_child(object)
	object.set_position(position)
	catch_object = null
	print("put")

