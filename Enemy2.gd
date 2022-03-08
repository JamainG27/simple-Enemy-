extends KinematicBody2D



var player
export var speed = 250
var stunned = false
export var fall_speed = 100
export (PackedScene) var FriendlyEnemy



func _process(delta):
	if not stunned : 
		if player:
			var distance = player.global_position - global_position
			var direction = distance.normalized()
			move_and_slide(direction * speed)

		$AnimationPlayer.play("Floating")
	else: 
		move_and_slide(Vector2.DOWN * fall_speed ) 
		$AnimationPlayer.play("Idle")
	
	if player.position.x <= position.x:
		$Area2D/CollisionPolygon2D.scale.x = 1
	if player.position.x >= position.x:
		$Area2D/CollisionPolygon2D.scale.x = -1
	
	if  $BubbleTimer.time_left > 0 :
		if  $BubbleTimer.time_left <= 3 :
			$Bubble/AnimationPlayer.play("StruggleBubble")

func stun():
	if not stunned: 
		stunned = true
		$Bubble/AnimationPlayer.play("Bubble Spawn")
		$BubbleTimer.start()
	

func _on_BubbleTimer_timeout():
	stunned = false
	$Bubble/AnimationPlayer.play("FreeBubble")
	

func on_hit_by_playershot():
	if not stunned:
		stun()
	if stunned:
		$BubbleTimer.start()


func _on_Bubble_touched():
	if stunned: 
		var NewEnemy = FriendlyEnemy.instance()
		get_parent().add_child(NewEnemy)
		NewEnemy.position = self.position
		queue_free()
