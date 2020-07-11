extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func onHacked(who,damage,knockback):
	
	#Decrement health and suffer effects. In this case, just so I know it's working!
	$Tween.interpolate_property(self,"modulate",Color(1,1,1),Color(3,3,3,3),.1,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"modulate",Color(3,3,3),Color(1,1,1,1),.1,Tween.TRANS_CUBIC,Tween.EASE_IN,.1)
	$Tween.start()
	print("I done been hacked!")
	print("Owie.")
