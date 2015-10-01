import a3
import unittest
class InvalidWordError(Exception):
    pass
class A3Test(unittest.TestCase):
    asym_board = [['B', 'K', 'I', 'T', 'E', 'A', 'T', 'O'],
                  ['O', 'J', 'E', 'B', 'A', 'C', 'Y', 'R'],
                  ['L', 'D', 'S', 'A', 'D', 'S', 'L', 'K'],
                  ['T', 'J', 'S', 'D', 'N', 'J', 'E', 'N']]
    sym_board = [['P', 'W', 'D', 'J', 'R', 'S', 'H', 'I'],
                 ['Y', 'A', 'J', 'K', 'U', 'C', 'A', 'P'],
                 ['T', 'D', 'A', 'I', 'B', 'A', 'S', 'A'],
                 ['H', 'A', 'V', 'A', 'Y', 'A', 'K', 'D'],
                 ['O', 'M', 'A', 'T', 'R', 'L', 'E', 'M'],
                 ['N', 'E', 'J', 'B', 'O', 'A', 'L', 'A'],
                 ['K', 'G', 'B', 'S', 'W', 'A', 'A', 'C'],
                 ['S', 'A', 'S', 'D', 'E', 'L', 'T', 'A']]
    wordlist = ['EBAY',
                'ADOBE',
                'AMAZON',
                'GOOGLE',
                'ORACLE',
                'MICROSOFT',
                'FACEBOOK']
    asym_file_board = open('asym_test_board.txt','r')
    sym_file_board = open('sym_test_board.txt','r')
    file_word = open('test_wordlist.txt','r')

    def test01_read_words(self):
        """read words should read from the file and return correct list of words"""
        self.assertEqual(self.wordlist, a3.read_words(self.file_word))
    
    def test02_read_board(self):
        """read board should return the correct list for symmetric board"""
        self.assertEqual(self.asym_board, a3.read_board(self.asym_file_board))
    def test03_read_board(self):
        """read board should return the correct list for asymmetric board"""
        self.assertEqual(self.sym_board, a3.read_board(self.sym_file_board))

    def test04_is_valid_word(self):
        """should return True for word at start"""
        self.assertEqual(True, a3.is_valid_word(self.wordlist,"ADOBE"))
    def test05_is_valid_word(self):
        """should return True for word at end"""
        self.assertEqual(True, a3.is_valid_word(self.wordlist,"FACEBOOK"))
    def test06_is_valid(self):
        """should return False for invalid word"""
        self.assertEqual(False, a3.is_valid_word(self.wordlist,"CISCO"))


    def test07_make_str_from_row(self):
        """should return correct word for first row index for non square board"""
        self.assertEqual("BKITEATO", a3.make_str_from_row(self.asym_board, 0))
    def test08_make_str_from_row(self):
        """should return correct word for last row index for square board"""
        self.assertEqual("SASDELTA", a3.make_str_from_row(self.sym_board, 7))


    def test09_board_contains_word_in_row(self):
        """should return True for substring match in a row for non-square board"""
        self.assertEqual(True, a3.board_contains_word_in_row(self.asym_board, "JEN"))
    def test10_board_contains_word_in_row(self):
        """should return False for no match of substring in square board"""
        self.assertEqual(False, a3.board_contains_word_in_row(self.sym_board,"ELTS"))
    def test11_board_contains_word_in_row(self):
        """should return True for complete match for a row in square board"""
        self.assertEqual(True, a3.board_contains_word_in_row(self.sym_board,"SASDELTA"))
    def test12_board_contains_word_in_row(self):
        """should return True for complete match for a row in non square board"""
        self.assertEqual(True, a3.board_contains_word_in_row(self.asym_board, "TJSDNJEN"))

    def test13_make_str_from_column(self):
        """should return correct word for square board with first index"""
        self.assertEqual("PYTHONKS", a3.make_str_from_column(self.sym_board, 0))
    def test14_make_str_from_column(self):
        """should return correct word for non square board with first index"""
        self.assertEqual("BOLT", a3.make_str_from_column(self.asym_board, 0))
    def test15_make_str_from_column(self):
        """should return correct word for square board for last index"""
        self.assertEqual("IPADMACA", a3.make_str_from_column(self.sym_board, 7))
    def test16_make_str_from_column(self):
        """should return correct word for non square board for last index"""
        self.assertEqual("ORKN", a3.make_str_from_column(self.asym_board, 7))

    def test17_board_contains_word_in_column(self):
        """should return True for correct substring match for square board"""
        self.assertEqual(True, a3.board_contains_word_in_column(self.sym_board,"JAVA"))
    def test18_board_contains_word_in_column(self):
        """should return True for correct substring match for non square board"""
        self.assertEqual(True, a3.board_contains_word_in_column(self.asym_board,"YLE"))
    def test19_board_contains_word_in_column(self):
        """should return True for correct match for square board"""
        self.assertEqual(True, a3.board_contains_word_in_column(self.sym_board,"IPADMACA"))
    def test20_board_contains_word_in_column(self):
        """should return True for correct match for non square board"""
        self.assertEqual(True, a3.board_contains_word_in_column(self.asym_board,"EADN"))
    def test21_board_contains_word_in_column(self):
        """should return False for incorrect substring match for square board"""
        self.assertEqual(False, a3.board_contains_word_in_column(self.sym_board,"RUBYRKW"))
    def test22_board_contains_word_in_column(self):
        """should return True for incorrect match for square board"""
        self.assertEqual(False, a3.board_contains_word_in_column(self.sym_board,"WADAMEGB"))

    def test23_board_contains_word(self):
        """should return true for substring match in row for square board"""
        self.assertEqual(True, a3.board_contains_word(self.sym_board,"TDA"))
    def test24_board_contains_word(self):
        """should return true for substring match in row for non square board"""
        self.assertEqual(True, a3.board_contains_word(self.asym_board,"ADSL"))
    def test25_board_contains_word(self):
        """should return true for substring match in column for square board"""
        self.assertEqual(True, a3.board_contains_word(self.sym_board,"HASKEL"))
    def test26_board_contains_word(self):
        """should return true for substring match in column for non square board"""
        self.assertEqual(True, a3.board_contains_word(self.asym_board,"ADN"))
    def test27_board_contains_word(self):
        """should return false for substring mismatch in row for square board"""
        self.assertEqual(False, a3.board_contains_word(self.sym_board,"BDA"))
    def test28_board_contains_word(self):
        """should return false for substring mismatch in row for non square board"""
        self.assertEqual(False, a3.board_contains_word(self.asym_board,"ADBL"))
    def test29_board_contains_word(self):
        """should return false for substring mismatch in column for square board"""
        self.assertEqual(False, a3.board_contains_word(self.sym_board,"HASDEL"))
    def test30_board_contains_word(self):
        """should return false for substring mismatch in column for non square board"""
        self.assertEqual(False, a3.board_contains_word(self.asym_board,"ADM"))

    def test31_word_score(self):
        """should return 0 for word with length < 3"""
        self.assertEqual(0, a3.word_score("AH"))
        self.assertEqual(0, a3.word_score(""))
    def test32_word_score(self):
        """should return correct length as specified in assignment"""
        self.assertEqual(14, a3.word_score("SANDBOX"))
        self.assertEqual(5, a3.word_score("MXTDA"))
        self.assertEqual(36, a3.word_score("TRANSRAILWAY"))

    def test33_update_score(self):
        """should update score correctly for a player"""
        player_info = ["puneet", 22]
        a3.update_score(player_info, "TRANSRAILWAY")
        self.assertEqual(58, player_info[1])
    def test34_update_score(self):
        """should not update score for a player if word_score is 0"""
        player_info = ["puneet", 22]
        a3.update_score(player_info, "AN")
        self.assertEqual(22, player_info[1])

    def test35_num_words_on_board(self):
        """should return correct number for matches in square board"""
        self.assertEqual(5, a3.num_words_on_board(self.sym_board,["RUBY","JAVA","SCAALA","IPAD","YAKD","WBX","INER"]))
if __name__ == '__main__':
    unittest.main()


