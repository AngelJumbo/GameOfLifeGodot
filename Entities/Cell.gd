
extends KinematicBody2D
class_name Cell

onready var area2D:=$Area2D

var deadByAge:bool
var starve:bool

var gen:int

var contactBreed:bool
var foodToBreed:int
var speed :int
var goal:KinematicBody2D
var goalType=null
var collision
var countFood=0
var breed=false
var direction:Vector2

var ageTimer
var starveTimer

var screenWidth
var screenHeight

var aliveTime

var rng = RandomNumberGenerator.new()
func _init():
	
	screenHeight=Global.screenHeight
	screenWidth=Global.screenWidth
	
	speed=Global.cellSpeed
	contactBreed=not (Global.asexualReproduction)
	foodToBreed=Global.foodToReproduce
	if(Global.starvation):
		starveTimer=Timer.new()
		add_child(starveTimer)
		starveTimer.autostart = true
		starveTimer.wait_time = Global.starvationTime
		starveTimer.connect("timeout", self, "_timeoutStarve")
	if( Global.deadByAge):
		ageTimer = Timer.new()
		add_child(ageTimer)
		ageTimer.autostart = true
		ageTimer.wait_time = Global.lifeTime
		ageTimer.connect("timeout", self, "_timeout")
		
	# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aliveTime=0
	rng.randomize()
	if(not Global.stay): direction=Vector2(rng.randf_range(0, screenWidth),rng.randf_range(0, screenHeight))
	get_parent().countAlive+=1
	#set_physics_process(false)
	
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	aliveTime+=delta
	if (goal==null):
		var bodies = area2D.get_overlapping_bodies()
		rng.randomize()
		goal = bodies[rng.randf_range(0, bodies.size())]
		if(goal!=self): 
			if (goal.get_name()=="Cell" or goal.get_name().substr(0,6)=="@Cell@") and countFood>=foodToBreed and contactBreed:
				var otherCell=get_node("../"+goal.get_name())
				if otherCell.countFood>=foodToBreed:
					goalType="Cell"
					breed=true
					otherCell.goal=self
					otherCell.goalType="Cell"
					otherCell.breed=true
				else:
					goal=null
					#onWay=true
					
			elif goal.get_name()=="Food" or goal.get_name().substr (0,6)=="@Food@":
				goalType="Food"
				#onWay=true
			else:
				goal=null
		else:
			goal=null
	
	if (goal!=null):
		#area2D.monitoring=false
		direction=(goal.global_position-global_position).normalized()
		
		collision = move_and_collide(direction*speed*delta);
		if collision:
			if collision.collider == goal:
				
				if breed and contactBreed and goalType=="Cell":
					breed=false
					goalType=null
					
					reproduce()
					
					goal=null
					#area2D.monitoring=true
					#onWay=false
					
				elif goalType=="Food":
					countFood=countFood+1
					
					if((not contactBreed) and countFood>=foodToBreed): 
						reproduce()
					if(Global.starvation):
						starveTimer.start(Global.starvationTime)
					if(countFood>=3): breed=true
					
					goal.queue_free()
					goal=null
					goalType=null
				
				rng.randomize()
				direction= Vector2(rng.randf_range(0, screenWidth),rng.randf_range(0, screenHeight))
				
				
			else:
				
				if collision.collider.get_name()=="Food" or collision.collider.get_name().substr (0,6)=="@Food@":
					if(Global.starvation):
						starveTimer.start(Global.starvationTime)
					countFood=countFood+1
					if((not contactBreed) and countFood>=foodToBreed): 
						reproduce()
					if(countFood>=3): breed=true
					collision.collider.queue_free()
	else:
		
		if (Global.stay):
			rng.randomize()
			direction= Vector2(rng.randf_range(-1, 1),rng.randf_range(-1, 1))
			collision = move_and_collide((direction)*speed*delta);
			return
		else:
			if (self.position.distance_to(direction)<5 or direction==Vector2(0,0) or goalType!=null):
				rng.randomize()
				goalType=null
				direction= Vector2(rng.randf_range(0, screenWidth),rng.randf_range(0,screenHeight))
				
		collision = move_and_collide((direction-position).normalized()*speed*delta);
		if  collision:
			if(not Global.stay):
				rng.randomize()
				goalType=null
				direction= Vector2(rng.randf_range(0, screenWidth),rng.randf_range(0, screenHeight))
				collision = move_and_collide((direction-position).normalized()*speed*delta);


"""
func _on_Area2D_body_entered(body: Node) -> void:
	
	if (body!=self and goal==null):
		if (body.get_name()=="Cell" or body.get_name().substr(0,6)=="@Cell@") and countFood>=foodToBreed and contactBreed:
			if get_node("../"+body.get_name()).countFood>=foodToBreed:
				goal=body
				goalType="Cell"
				breed=true
				onWay=true
				
		elif body.get_name()=="Food" or body.get_name().substr (0,6)=="@Food@":
			goal= body
			goalType="Food"
			onWay=true
		"""	
func _timeout():
	die()

func _timeoutStarve():
	die()
	
func die():
	if Global.longestLife<aliveTime:
		Global.longestLife=aliveTime
	#if Global.oldestGenAlive<gen:
	#print("Dead by starve")
	get_parent().countAlive-=1
	self.queue_free()
	get_parent().countDeads+=1
	
func reproduce():
	countFood-=foodToBreed
	var scene =load("res://Entities/Cell.tscn")
	var cell=scene.instance()
	cell.gen=gen+1
	if(Global.newestGen<gen+1): Global.newestGen=gen+1
	cell.set_global_position(Vector2(self.global_position.x,self.global_position.y +10))
	get_node("../").add_child(cell)

