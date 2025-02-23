class_name SoftDrinkAutomaton

enum Currency {
	Ten = 10,
	Twenty = 20,
	Fourty = 40, 
	Fifty = 50, 
	OneHundred = 100, 
	TwoHundred = 200, 
	FiveHundred = 500, 
	OneThousand = 1000
}

enum Drink {
	Orange
}


# The alphabet is (implicitly) the values of Currency and Drink
var states := [0, 1, 2, 3, 4, 5]
var initial_state : int = states[0]
var current_state: int;

const DRINK_COST = 50
var _transition_map = {}

func _populate_transition_map():
	for name in Currency:
		var currency_val = Currency[name]
		for state in states:
			var val_at_state = state * Currency.Ten + currency_val
			if val_at_state >= DRINK_COST:
				_transition_map[[state, currency_val]] = \
					[len(states) - 1, val_at_state - DRINK_COST]
			else:
				_transition_map[[state, currency_val]] = \
					[(val_at_state % DRINK_COST) / Currency.Ten,
					 val_at_state - DRINK_COST]
					
	for drink in Drink:
		for state in states:
			if state == len(states) - 1:
				_transition_map[[state, drink]] = [initial_state, drink]
			else:
				_transition_map[[state, drink]] = [state, null]

func transition(state: int, input: Variant) -> Array:
	return _transition_map[[state, input]]
	
func can_dispense_drink() -> bool:
	# At the last state, the vending machine
	# has received at least DRINK_COST shillings
	return current_state == len(states) - 1
	

func _init() -> void:
	current_state = initial_state
	_populate_transition_map()
