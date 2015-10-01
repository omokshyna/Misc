'''A board is a list of list of str. For example, the board
    ANTT
    XSOB
is represented as the list
    [['A', 'N', 'T', 'T'], ['X', 'S', 'O', 'B']]

A word list is a list of str. For example, the list of words
    ANT
    BOX
    SOB
    TO
is represented as the list
    ['ANT', 'BOX', 'SOB', 'TO']
'''


def is_valid_word(wordlist, word):
    ''' (list of str, str) -> bool

    Return True if and only if word is an element of wordlist.

    >>> is_valid_word(['ANT', 'BOX', 'SOB', 'TO'], 'TO')
    True
    '''
    is_word = False
    
    for words in wordlist:
        if words == word:
            is_word = True
    return is_word
            


def make_str_from_row(board, row_index):
    ''' (list of list of str, int) -> str

    Return the characters from the row of the board with index row_index
    as a single string.

    >>> make_str_from_row([['A', 'N', 'T', 'T'], ['X', 'S', 'O', 'B']], 0)
    'ANTT'
    '''
    new_string = ''
    
    for char in board[row_index]:
        new_string = new_string + char

    return new_string
        
def make_str_from_column(board, column_index):
    ''' (list of list of str, int) -> str

    Return the characters from the column of the board with index column_index
    as a single string.

    >>> make_str_from_column([['A', 'N', 'T', 'T'], ['X', 'S', 'O', 'B']], 1)
    'NS'
    '''
    new_string = ''

    for i in board:
        new_string = new_string + i [column_index]

    return new_string

def board_contains_word_in_row(board, word):
    ''' (list of list of str, str) -> bool

    Return True if and only if one or more of the rows of the board contains
    word.

    Precondition: board has at least one row and one column, and word is a
    valid word.

    >>> board_contains_word_in_row([['A', 'N', 'T', 'T'], ['X', 'S', 'O', 'B']], 'SOB')
    True
    '''

    for row_index in range(len(board)):
        if word in make_str_from_row(board, row_index):
            return True

    return False


def board_contains_word_in_column(board, word):
    ''' (list of list of str, str) -> bool

    Return True if and only if one or more of the columns of the board
    contains word.

    Precondition: board has at least one row and one column, and word is a
    valid word.

    >>> board_contains_word_in_column([['A', 'N', 'T', 'T'], ['X', 'S', 'O', 'B']], 'NO')
    False
    '''
    for i in range(len(board[0])):
        if word in make_str_from_column(board, i):
            return True
    return False

def board_contains_word(board, word):
    '''(list of list of str, str) -> bool

    Return True if and only if word appears in board.

    Precondition: board has at least one row and one column.

    >>> board_contains_word([['A', 'N', 'T', 'T'], ['X', 'S', 'O', 'B']], 'ANT')
    True
    '''

    if board_contains_word_in_column(board, word) == True:
        return True
    elif board_contains_word_in_row(board, word) == True:
        return True
    return False

def word_score(word):
    '''(str) -> int

    Return the point value the word earns.

    Word length: < 3: 0 points
                 3-6: 1 point per character in word
                 7-9: 2 points per character in word
                 10+: 3 points per character in word

    >>> word_score('DRUDGERY')
    16
    '''
      
    if len(word) < 3:
        word_score = 0
    elif len(word) in range(3,7):
        word_score = 1 * len(word)
    elif len(word) in range(7,10):
        word_score = 2 * len(word)
    else:
        word_score = 3 * len(word)

    return word_score
    

def update_score(player_info, word):
    '''([str, int] list, str) -> NoneType

    player_info is a list with the player's name and score. Update player_info
    by adding the point value word earns to the player's score.

    >>> update_score(['Jonathan', 4], 'ANT')
    '''
    
    player_info [1] = player_info[1] + word_score(word)

##    return player_info

def num_words_on_board(board, words):
    '''(list of list of str, list of str) -> int

    Return how many words appear on board.

    >>> num_words_on_board([['A', 'N', 'T', 'T'], ['X', 'S', 'O', 'B']], ['ANT', 'BOX', 'SOB', 'TO'])
    3
    '''

    num_words = 0
    for word in words:
        if board_contains_word(board, word):
            num_words = num_words + 1

    return num_words
    
   
def read_words(words_file):
    ''' (file open for reading) -> list of str

    Return a list of all words (with newlines removed) from open file
    words_file.

    Precondition: Each line of the file contains a word in uppercase characters
    from the standard English alphabet.
    '''
##    path = "D:\LTP\wordlist1.txt"
##    words_file = open(path, 'r')
    lists = []
   
    for string in words_file:
            string_n = string.rstrip('\n')
            lists.append(string_n)

    return lists
    

def read_board(board_file):
    ''' (file open for reading) -> list of list of str

    Return a board read from open file board_file. The board file will contain
    one row of the board per line. Newlines are not included in the board.
    '''
     
    lists = []
    
    
    for string in board_file:

            string = string.rstrip('\n')
            sublist = []
            
            #Append characters into sublist:
            for char in string:
             
##                if char != '\n':
                sublist.append(char)
                
            if sublist != []:
                lists.append(sublist)

##    string = board_file.readline
##    lists.append(string)
        
    return lists
   
##    result=[]
##    line=board_file.readline()
##    while line != '':
##        in_result=[]
##        line = line.rstrip('\n')
##        
##        for letter in line:
##            
##            in_result.append(letter)
## 
##        result.append(in_result)    
##        line=board_file.readline()
## 
##    return result
     

