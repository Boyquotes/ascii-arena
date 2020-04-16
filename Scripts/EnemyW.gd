extends KinematicBody2D

func _delete_self():
	get_parent().remove_child(self)


func die():
	self.rotation = 90
	$Blood.emitting = true
	
	var timer = Timer.new()
	timer.set_wait_time(5)
	timer.connect("timeout", self, "_delete_self")
	add_child(timer) #to process
	timer.start() #to start
	
	
