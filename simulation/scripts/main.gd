extends Node2D

const MSG_UNEXPECTED_RESULT = "Unexpected Result."
const MSG_CANNOT_BUY_DRINK = "Cannot buy a drink yet."
const MSG_CAN_BUY_DRINKS = "You can now buy a drink."

var automaton := SoftDrinkAutomaton.new()
var can_buy_drink := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_state_text(automaton.current_state, -SoftDrinkAutomaton.DRINK_COST)
	var buttons = get_tree().get_nodes_in_group("CurrencyButtons")
	for button: CurrencyButton in buttons:
		button.currency_pressed.connect(_handle_currency_button_press)
		
	buttons = get_tree().get_nodes_in_group("DrinkButtons")
	for button: DrinkButton in buttons:
		button.drink_pressed.connect(_handle_drink_button_press)

func _handle_currency_button_press(currency: SoftDrinkAutomaton.Currency):
	match automaton.transition(automaton.current_state, currency):
		[var new_state, var balance]:
			automaton.current_state = new_state
			_update_state_text(automaton.current_state, balance)
			if (automaton.can_dispense_drink() and not can_buy_drink):
				can_buy_drink = true
				_show_popup(MSG_CAN_BUY_DRINKS)
		_:
			push_error(MSG_UNEXPECTED_RESULT)
			
func _handle_drink_button_press(drink: SoftDrinkAutomaton.Drink):
	match automaton.transition(
		automaton.current_state, SoftDrinkAutomaton.Drink.find_key(drink)):
		[var new_state, null]:
			assert(new_state == automaton.current_state)
			_show_popup(MSG_CANNOT_BUY_DRINK)
		[var new_state, var soft_drink]:
			automaton.current_state = new_state
			_show_popup("Bought the drink: %s" % soft_drink)
			_update_state_text(
				automaton.current_state, -SoftDrinkAutomaton.DRINK_COST)
			can_buy_drink = false
		_:
			push_error(MSG_UNEXPECTED_RESULT)


func _on_popup_panel_popup_hide() -> void:
	$Control/PanelContainer.visible = false
	
func _show_popup(msg: String):
	$Control/PanelContainer.visible = true
	$Control/PanelContainer/PopupPanel/Label.text = msg
	$Control/PanelContainer/PopupPanel.show()
	
func _update_state_text(state: int, balance: int):
	$Control/AutomatonStateInfo/CurrentState.text = \
				"Current State: %d" % state
				
	var balance_text: String;
	balance_text = "Balance: %d" % balance
	
	$Control/AutomatonStateInfo/Balance.text = balance_text
