extends Area2D
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape = CircleShape2D.new()
	shape.set_radius(Global.visionRange)

	var collision = CollisionShape2D.new()
	collision.set_shape(shape)

	add_child(collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
