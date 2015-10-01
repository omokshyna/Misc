def get_answer(promt):
    ''' (str) -> str

    Use promt to ask user for a 'yes' or 'no'
    answer and continue asking until the user gives a valid
    response. Return the answer.
    '''

    answer = input(promt)

    while not (answer == 'yes' or answer == 'no'):
        answer = input(promt)

    return answer

def up_to_vowel(s):
    ''' (str) => str

    Return a substring of s from index 0 up to but
    not including the first vowel in s.

    >>> up_to_vowel('hello')
    'h'
    >>> up_to_vowel('there')
    'th'
    >>> up_to_vowel('cs')
    'cs'
    '''

    # before_vowel contains all the characters found in s[0:i]
    before_vowel = ''
    i = 0

    # Accumulate the non-vowels at the beginning of the string
    while i < len(s) and not (s[i] in 'aeiouAEIOU'):
        before_vowel = before_vowel + s[i]
        i = i + 1

    return before_vowel
