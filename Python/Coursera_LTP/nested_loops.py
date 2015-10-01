def averages(grades):
    
    '''
    (list of list of number) -> list of float

    Return a new list in which each item is the average
    of the grades in the inner list at the corresponding
    position of grades
    
    >>> average([[70,75,80], [70,80,90,100], [80,100]])
    [75.0, 85.0, 90.0]
    '''

    averages = []

    for grades_list in grades:
        #Calculate the average of grades_list and append
        # it to average

        total = 0
        for mark in grades_list:
            total = total + mark
            
        averages.append(total / len(grades_list))


    return averages

def mystery(lst):
    '''
    >>> print(mystery([[10, 20], [20], [40,10]]))
    50
    '''
    for sublist in lst:
        total = 0
        for num in sublist:
            total = total + num
    return total
    

