import os
from dataclasses import dataclass
import z3

@dataclass
class Machine:
    joltage: list[int]
    buttons: list[list[int]]

def parse():
    machines = []
    with open("../priv/day10.txt", 'r') as f:
        for line in f:
            parts = line.strip().split(" ")
            joltage = [int(s) for s in parts[-1].removeprefix("{").removesuffix("}").split(",")]
            n = len(joltage)
            buttons_indices = [ [int(s) for s in nums.removeprefix("(").removesuffix(")").split(",")] for nums in parts[1:-1]]
            buttons = [
                [ 1 if i in button else 0 for i in range(n)]
                for button in buttons_indices
            ]
            machines.append(Machine(joltage, buttons))
    return machines

def solve_pt2(machine: Machine):
    # Transpose the buttons matrix to bring it in the expected form
    buttons = [[machine.buttons[j][i] for j in range(len(machine.buttons))] for i in range(len(machine.buttons[0]))]
    expected_joltage = machine.joltage

    def joltage_after(presses_vec):
        # Matrix vector multiplication
        return [sum(x*y for x, y in zip(row, presses_vec)) for row in buttons ]

    button_presses = [z3.Int(f"b{i}") for i in range(len(machine.buttons))]

    solver = z3.Optimize()
    solver.add(z3.And([ val == j for val, j in zip(joltage_after(button_presses), expected_joltage)]))
    solver.add(z3.And([p >= 0 for p in button_presses]))
    solver.minimize(sum(button_presses))

    assert solver.check() == z3.sat
    model = solver.model()
    return sum(model[p].as_long() for p in button_presses)



def main():
    machines = parse()
    print(sum(solve_pt2(machine) for machine in machines))




if __name__ == "__main__":
    main()
