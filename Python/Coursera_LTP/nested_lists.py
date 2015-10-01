def calculate_average(asn_grades):
    ''' (list of list of [str, number]) -> float

    Return the average of grades in asn_grades.

    >>> calculate_average([['A1', 80], ['A2', 90]])
    85.0
    '''

    total = 0

    for item in asn_grades:
        total = total + item[1]

    return total / len(asn_grades)
