def capitalized(two_words):
    '''(str) -> str

    Precondition: two_words is a string containing two words separated by one space.

    Return a string containing the words in two_words, but capitalized, again
    separated by one space.

    >>> capitalized('hello world')
    Hello World
    '''

    first = two_words[:two_words.find(' ')]
    second = two_words[two_words.find(' '):]
    return first.capitalize() + ' ' + second.capitalize()
