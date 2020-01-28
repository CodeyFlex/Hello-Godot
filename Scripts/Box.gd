extends KinematicBody2D

var refill = false
var current_stock = 0
var buy_roll = null
var store_favor = 1

var target = null

func _process(delta):
	if Input.is_action_just_pressed('ui_f'):
		refill_display()

func _on_EntryRadius_body_entered(body):
#	Body.name kravet skal måske ændres til noget mere inkluderende
	if body.name == "Player":
		target = body
		refill = true
	if body.name == "Customer":
		if current_stock >= 1:
			buy_stock()
		if current_stock == 0:
			angry()
#			emote

func _on_EntryRadius_body_exited(body):
	if body == target:
		target = null
		refill = false

func refill_display():
	if refill == true:
		current_stock = 1
		stock_filled()

func buy_stock():
	buy_roll = randi()%10+1
	print("buy roll: ", buy_roll)
	print("current stock: ", current_stock)
	if buy_roll >= 7 - store_favor:
		current_stock -= 1
		stock_empty()
		stock_filled()

func stock_empty():
	if current_stock == 0:
		$Body.play("Empty")

func stock_filled():
	if current_stock >= 1:
		$Body.play("Food")

func angry():
	pass
#	emote, put dem  i people scripted