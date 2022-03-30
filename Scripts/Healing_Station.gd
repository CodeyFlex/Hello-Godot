extends KinematicBody2D
class_name Healing_Station

var healing_power = 10

var body_in_healing_area = false
var patient = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed('ui_6'):
		print($CooldownTimer.get_time_left())

func _on_EntryRadius_body_entered(body):
	if body.has_method('heal'):
		patient = body
		$CooldownTimer.start()

func _on_EntryRadius_body_exited(body):
	if body == patient:
		patient = null
		$CooldownTimer.stop()

func _on_CooldownTimer_timeout():
	if patient != null:
		patient.heal(healing_power)
		print(patient, " healed for: ", healing_power, " hp")
