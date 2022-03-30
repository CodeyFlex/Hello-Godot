extends KinematicBody2D
class_name Box

var target = null
var refill = false
var buy_roll = null
var store_favor = 1
var current_stock = 0 setget set_current_stock, get_current_stock

signal customer_good_experience

func set_current_stock(new_value):
	current_stock = new_value

func get_current_stock():
	return current_stock

func _process(delta):
	#Automatic food animation check
	if current_stock >= 1:
		$Body.play("Food")
	else:
		$Body.play("Empty")
	
	#Player refill & empty
	if Input.is_action_just_pressed('ui_f'):
		refill_display()
	if Input.is_action_just_pressed('ui_g'):
		buy_stock()

func _on_EntryRadius_body_entered(body): # Checks if a character is near the box
#	Body.name kravet skal måske ændres til noget mere inkluderende
	if body.name == "Player": # If player enters the radius around the box.
		target = body
		refill = true

	if body.name == "Cashier":
		target = body
		refill = true
		refill_display()

	if body.name == "Customer": # If customer enters the radius around the box.
		target = body
		if current_stock >= 1: # If stocked, consider purchase.
			buy_stock()
		elif current_stock == 0: # If no stock, bad impression of store.
			angry()
#			play emote

func _on_EntryRadius_body_exited(body): # When a character leaves the box radius, variables will reflect this here.
	if body == target:
		target = null
		refill = false

func refill_display(): # Refill box of goods
	if refill == true:
		current_stock = 1

func buy_stock(): # Rolls for purchase, and removes 1 stock from box
	print("Target: ", target)
	if target != null:
		buy_roll = randi()%10+1
		print("buy roll: ", buy_roll)
		print("current stock: ", current_stock)
		if buy_roll >= 7 - store_favor:
			if current_stock >= 1:
				current_stock -= 1
				emit_signal("customer_good_experience")

func angry():
	print("Customer is annoyed that there is no stock")
#	emote, put dem  i people scripted
