def contains(v, d):
    ''' (object, dict of {object: list}) -> bool

    Return whether v is an element of one of the list values in d.

    >>> contains('moogah', {1: [70, 'blue'], 2: [1.24, 'moogah', 90], 3.14: [80, 100]})
    True
    >>> contains('moogah', {'moogah': [1.24, 'frooble', 90], 3.14: [80, 100]})
    False
    '''

    found = False  # Whether we have found v in a list in d.

    # CODE MISSING HERE
##    for k in d:
##        if v in d[k]:
##            found = True
##    for k in d:
##        for i in range(len(d[k])):
##            if d[k][i] == v:
##                found = True
   
    return found
