@tool
class_name CurrencyButton extends Button

signal currency_pressed(value: SoftDrinkAutomaton.Currency)

@export
var value: SoftDrinkAutomaton.Currency = SoftDrinkAutomaton.Currency.Ten:
	set(new_value):
		value = new_value
		text = "%d" % value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "%d" % value

func _on_pressed() -> void:
	currency_pressed.emit(value)
