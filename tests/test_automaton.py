from soft_drink_automaton import SoftDrinkAutomaton, Currency, SoftDrinks

class TestSoftDrinkAutomaton:
    automaton = SoftDrinkAutomaton()

    def test_empty(self):
        assert self.automaton.is_acceptable([])

    def test_tens(self):
        assert self.automaton.is_acceptable([
            Currency.Ten,
            Currency.Ten,
            Currency.Ten,
            Currency.Ten,
            Currency.Ten,
            SoftDrinks.Fanta
        ])