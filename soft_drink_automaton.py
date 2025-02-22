from enum import Enum, auto
from typing import List

DRINK_COST = 50


class Currency(Enum):
    Ten = 10
    Twenty = 20
    Forty = 40
    Fifty = 50
    OneHundred = 100
    TwoHundred = 200
    FiveHundred = 500
    OneThousand = 1000


class SoftDrinks(Enum):
    Fanta = auto()


Alphabet = Currency | SoftDrinks
State = int  # 0-5 (inclusive)

class SoftDrinkAutomaton:
    def __init__(self):
        self._states: List[State] = [x for x in range(6)]

        alphabet = list(Currency)
        alphabet.extend(list(SoftDrinks))
        self._alphabet: List[Alphabet] = alphabet

        self._accepting_states: List[State] = [self._states[0]]
        self._initial_state: State = self._states[0]

        self._current_state: State = self._initial_state

        self._next_state_map = {}
        # Populate next state map
        for currency in list(Currency):
            for state in self._states:
                val_at_state = state * Currency.Ten.value + currency.value
                if val_at_state >= DRINK_COST:
                    self._next_state_map[(state, currency)] = len(self._states) - 1
                else:
                    self._next_state_map[(state, currency)] = (val_at_state % DRINK_COST) // 10

        for drink in list(SoftDrinks):
            for state in range(len(self._states) - 1):
                self._next_state_map[(state, drink)] = state

            self._next_state_map[(len(self._states) - 1, drink)] = self._states[0]

    def _transition(self, state: State, symbol: Alphabet) -> State:
        return self._next_state_map[(state, symbol)]

    def is_acceptable(self, symbols: List[Alphabet]) -> bool:
        """Checks whether the automaton accepts or rejects the given input sequence"""
        self._current_state = self._initial_state
        for symbol in symbols:
            self._current_state = self._transition(self._current_state, symbol)

        return self._current_state in self._accepting_states

if __name__ == '__main__':
    # Example
    print(
        SoftDrinkAutomaton().is_acceptable(
            [Currency.Ten, Currency.Twenty, Currency.Ten, Currency.Ten, SoftDrinks.Fanta]
        )
    )