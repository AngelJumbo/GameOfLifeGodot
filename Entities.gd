extends Node2D

var rng = RandomNumberGenerator.new()
var timer=0
var maxFood:int
var countAlive=0
var countDeads=0
var time=0
var play=true


func _ready():
	maxFood=Global.foodPerCycle
	rng.randomize()
	for i in range(0,Global.initialCells):
		var scene =load("res://Entities/Cell.tscn")
		var cell=scene.instance()
		cell.gen=1
		cell.set_global_position(Vector2(rng.randf_range(0, Global.screenWidth),rng.randf_range(0, Global.screenHeight)))
		add_child(cell)
	#var my_random_number = rng.randf_range(-10.0, 10.0)
"""
func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			var scene =load("res://Entities/Cell.tscn")
			var cell=scene.instance()
			cell.set_global_position(event.global_position)
			add_child(cell)
			#goal = event.position
			#path = nav.get_simple_path($KinematicBody2D.position, goal, false)
			#$Line2D.points = PoolVector2Array(path)
			#$Line2D.show()
		elif (event.button_index == BUTTON_RIGHT and event.pressed):
			var scene =load("res://Entities/Food.tscn")
			var food=scene.instance()
			food.set_global_position(event.global_position)
			add_child(food)
	"""		
func _process(delta: float) -> void:
	timer=timer+delta
	time+=delta
	$"../VBox/AliveLabel".text="Alive: "+String(countAlive)
	$"../VBox/DeadsLabel".text="Deads: "+String(countDeads)
	$"../VBox/TimeLabel".text="Time: "+String(time)
	$"../VBox/NewestGenLabel".text="Newest gen: "+String(Global.newestGen)
	$"../VBox/LongestLifeLabel".text="Longest life: "+String(Global.longestLife)
	#print(fmod(timer, 5))
	if(timer>Global.timePerCycle):
		timer=0
		for i in range(maxFood):
			var posi= Vector2(rng.randf_range(0, 500),rng.randf_range(0, 500))
			var scene =load("res://Entities/Food.tscn")
			var food=scene.instance()
			food.set_global_position(posi)
			add_child(food)
	

# Replace with function body.


