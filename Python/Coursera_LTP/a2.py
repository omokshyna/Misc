def get_length(dna):
    ''' (str) -> int

    Return the length of the DNA sequence dna.

    >>> get_length('ATCGAT')
    6
    >>> get_length('ATCG')
    4
    '''
    return len(dna)



def is_longer(dna1, dna2):
    ''' (str, str) -> bool

    Return True if and only if DNA sequence dna1 is longer than DNA sequence
    dna2.

    >>> is_longer('ATCG', 'AT')
    True
    >>> is_longer('ATCG', 'ATCGGA')
    False
    '''
    return len(dna1) > len(dna2)



def count_nucleotides(dna, nucleotide):
    ''' (str, str) -> int

    Return the number of occurrences of nucleotide in the DNA sequence dna.

    >>> count_nucleotides('ATCGGC', 'G')
    2
    >>> count_nucleotides('ATCTA', 'G')
    0
    '''
    return dna.count(nucleotide)    



def contains_sequence(dna1, dna2):
    ''' (str, str) -> bool

    Return True if and only if DNA sequence dna2 occurs in the DNA sequence
    dna1.

    >>> contains_sequence('ATCGGC', 'GG')
    True
    >>> contains_sequence('ATCGGC', 'GT')
    False
    
    '''
    
    if dna1.find(dna2) >= 1:
        return True
    else:
        return False

def is_valid_sequence(dna):
    '''(str) -> bool

    Return True if and only if the DNA sequence
    is valid (that is, it contains no characters other than
    'A', 'T', 'C' and 'G').

    >>> is_valid_sequence('ATGG')
    True
    >>> is_valid_sequence('ATFCJ')
    False
    '''
    
    nucleotides = 'ATCG'
       
    for nuc in dna:
        if nuc not in nucleotides:
           return False
    return True

def insert_sequence(dna1, dna2, ind):
    '''(str, str, int) -> str

    Return the DNA sequence obtained by inserting the second DNA sequence
    into the first DNA sequence at the given index. (You can assume that
    the index is valid.)

    >>>insert_sequence('CCGG', 'AT', 2)
    'CCATGG'
    '''
##    new_dna = ''
##    if type(ind) == int:
        new_dna = dna1[:ind] + dna2 + dna1[ind:]
        return new_dna

def get_complement(nuc):
    '''(str) => str

     Return the nucleotide's complement.

     >>> get_complement('A')
     'T'
     >>> get_complement('C')
     'G'
     '''

    if nuc == 'A':
        return 'T'
    elif nuc == 'T':
        return 'A'
    elif nuc == 'G':
        return 'C'
    else:
        return 'G'

def get_complementary_sequence(dna):
    '''(str) -> str

    Return the DNA sequence that is complementary to the given DNA sequence.

    >>> get_complementary_sequence('AGCT')
    'TCGA'
    >>> get_complementary_sequence('GGCCATG')
    'CCGGTAC'
    '''
    dna_comp = ''
    for nuc in dna:
        dna_comp = dna_comp + get_complement(nuc)
     
    return dna_comp

        
    
