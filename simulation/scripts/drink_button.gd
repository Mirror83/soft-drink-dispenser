@tool
class_name DrinkButton extends Button

signal drink_pressed(value: SoftDrinkAutomaton.Drink)

@export
var value: SoftDrinkAutomaton.Drink = SoftDrinkAutomaton.Drink.Orange:
	set(new_value):
		value = new_value
		text = SoftDrinkAutomaton.Drink.find_key(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = SoftDrinkAutomaton.Drink.find_key(value)

func _on_pressed() -> void:
	drink_pressed.emit(value)
