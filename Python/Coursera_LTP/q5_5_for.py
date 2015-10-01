def sum_odd(num1, num2):

    i = 0
    sum = 0
    
    for num in range(num1, num2 + 1, 2):
        sum = sum + num
    return sum
