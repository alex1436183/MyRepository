import math
import sys

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Деление на ноль невозможно")
    return a / b

def power(a, b):
    return a ** b

def sqrt(a):
    if a < 0:
        raise ValueError("Невозможно извлечь квадратный корень из отрицательного числа")
    return math.sqrt(a)

def main():
    print("Простой калькулятор")
    print("====================")
    print("Выберите операцию:")
    print("1. Сложение")
    print("2. Вычитание")
    print("3. Умножение")
    print("4. Деление")
    print("5. Возведение в степень")
    print("6. Квадратный корень")
    choice = input("Введите номер операции (1-6): ").strip()
    try:
        if choice == "6":
            a = float(input("Введите число: "))
            result = sqrt(a)
            print(f"\nКвадратный корень из {a} = {result}")
        else:
            a = float(input("Введите первое число: "))
            b = float(input("Введите второе число: "))
            if choice == "1":
                result = add(a, b)
                op = "+"
            elif choice == "2":
                result = subtract(a, b)
                op = "-"
            elif choice == "3":
                result = multiply(a, b)
                op = "*"
            elif choice == "4":
                result = divide(a, b)
                op = "/"
            elif choice == "5":
                result = power(a, b)
                op = "^"
            else:
                print("Неверный выбор операции.")
                sys.exit(1)
            print(f"\n{a} {op} {b} = {result}")
    except Exception as e:
        print("Ошибка:", e)
        sys.exit(1)

if __name__ == "__main__":
    main()
