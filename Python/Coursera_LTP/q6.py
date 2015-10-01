def mystery(s):
    ''' (str) -> bool
    '''
    matches = 0
    for i in range(len(s) // 2):
        if s[i] == s[len(s) - 1 - i]:
            matches = matches + 1

    return matches == (len(s) // 2)

def merge(L):
    merged = []
    for i in range(0, len(L), 3):
        merged.append(L[i] + L[i + 1] + L[i + 2])
    return merged

def shift_right(L):
    ''' (list) -> NoneType

    Shift each item in L one position to the right
    and shift the last item to the first position.

    Precondition: len(L) >= 1
    '''

    last_item = L[-1]

    for i in range(1, len(L)):
        L[len(L) - i] = L[len(L) - i - 1]

    L[0] = last_item

    print(L)
    
def shift_left(L):
    ''' (list) -> NoneType
    
    Shift each item in L one position to the left and shift the first item to
    the last position.
    
    Precondition: len(L) >= 1
    
    >>> shift_left(['a', 'b', 'c', 'd'])
    '''
    
    first_item = L[0]
    
    for i in range(len(L) - 1):
        L[i] = L[i + 1]
    
    L[-1] = first_item

def make_pairs(list1, list2):
    ''' (list of str, list of int) -> list of [str, int] list
    
    Return a new list in which each item is a 2-item list with the string from the
    corresponding position of list1 and the int from the corresponding position of list2.
    
    Precondition: len(list1) == len(list2)
    
    >>> make_pairs(['A', 'B', 'C'], [1, 2, 3])
    [['A', 1], ['B', 2], ['C', 3]]
    '''
    
    pairs = []
    
    # CODE MISSING HERE
##    for i in range(len(list1)):
##        pairs.append([list1[i], list2[i]])
##    for i in range(len(list1)):
##        inner_list = []
##        inner_list.append(list1[i])
##        inner_list.append(list2[i])
##        pairs.append(inner_list)
            
    return pairs

def contains(value, lst):
    ''' (object, list of list) -> bool

    Return whether value is an element of one of the nested lists in lst.

    >>> contains('moogah', [[70, 'blue'], [1.24, 90, 'moogah'], [80, 100]])
    True
    '''

    found = False  # We have not yet found value in the list.

    # CODE MISSING HERE
##    for sublist in lst:
##        if value in sublist:
##            found = True
##    for i in range(len(lst)):
##        for j in range(len(lst[i])):
##            if lst[i][j] == value:
##                found = True
    
    return found

def lines_startswith(file, letter):
    '''(file open for reading, str) -> list of str

    Return the list of lines from file that begin with letter. The lines should have the
    newline removed.

    Precondition: len(letter) == 1
    '''

    matches = []

    # CODE MISSING HERE
    

    return matches
