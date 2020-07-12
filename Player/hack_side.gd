extends Node2D

var damage = 1

func _ready():
	$Slice_Animator.play("default")
	$Slice_Animator.frame = 0

func _on_Area2D_area_entered(area):
	if area.has_method("onHacked"):
		print("GGGGGG")
		area.onHacked(self, 1,0)

#func _on_AnimatedSprite_frame_changed():
#	if($Slice_Animator.frame == 3):
#		queue_free()


func _on_Slice_Animator_frame_changed():
	if($Slice_Animator.frame == 3):
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("onHacked"):
		print("GGGGGG")
		body.onHacked(self, 1,0)
