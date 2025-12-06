class Employee():
    def __init__(self, id, name, role, salary):
        self.id = id
        self.name = name
        self.role = role
        self.salary = salary

    def apply_raise(self, role, percent):
        if (role) == 'Manager':
            if percent > 0:
                self.salary = self.salary + (self.salary*(percent/100))


e1 = Employee(1, 'davinder', 'Developer', 75000.00)
print(f"Salary Before increment - ", e1.salary)
e1.apply_raise('Manager', 20)
print(f"Salary After increment - ", e1.salary)
