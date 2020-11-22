extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_ToolButton_pressed() -> void:
	Global.foodPerCycle=$VBoxContainer/HBoxContainer/SpinBox.get_value()
	Global.timePerCycle=$VBoxContainer/HBoxContainer2/SpinBox.get_value()
	Global.foodToReproduce=$VBoxContainer/HBoxContainer3/SpinBox.get_value()
	Global.starvation=$VBoxContainer/HBoxContainer4/CheckBox.pressed
	Global.starvationTime=$VBoxContainer/HBoxContainer4/SpinBox.get_value()
	Global.deadByAge=$VBoxContainer/HBoxContainer5/CheckBox.pressed
	Global.lifeTime=$VBoxContainer/HBoxContainer5/SpinBox.get_value()
	Global.visionRange=$VBoxContainer/HBoxContainer7/SpinBox.get_value()
	Global.cellSpeed=$VBoxContainer/HBoxContainer6/SpinBox.get_value()
	Global.initialCells=$VBoxContainer/HBoxContainer9/SpinBox.get_value()
	Global.asexualReproduction=$VBoxContainer/HBoxContainer8/CheckBox.pressed
	Global.stay=not ($VBoxContainer/HBoxContainer10/CheckBox.pressed)
	Global.screenHeight=get_viewport().size.y
	Global.screenWidth=get_viewport().size.x
	Global.longestLife=0
	Global.newestGen=1
	Global.oldestGenAlive=1
	get_tree().change_scene("res://MainNode.tscn")
