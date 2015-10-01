## Import modules
import os, sys, getopt, csv, math
from itertools import combinations_with_replacement
from collections import defaultdict

## Create a list of FF parameters
def Create_FF_list(fname):
    ff_list = list(csv.reader(open(fname), delimiter = ';'))
    ff_list.pop(0) ## Delete header
    return ff_list

## Create all combinations of atoms
## and dictionary 
def Atom_Combinations(ff_list):
    count = len(ff_list) ## Number of atoms in list
    comb_dict_r612 = {}
    comb_dict_e612 = {}
    function_r612 = raw_input('Print in function for weighing of r612, call arguments x1 and x2: ')
    function_e612 = raw_input('Print in function for weighing of e612, call arguments x1 and x2: ')
    # function_r612 = input('Print in function for weighing of r612, call arguments x1 and x2: ')
    # function_e612 = input('Print in function for weighing of e612, call arguments x1 and x2: ')
    ## !!!!CHECK for in-tuple conversion
    for p in combinations_with_replacement(range(count),2):
        if str(ff_list[p[0]][0]) > str(ff_list[p[1]][0]):
            comb_dict_r612[ff_list[p[0]][0], ff_list[p[1]][0]] = round(CalculateWeights(float(ff_list[p[0]][1]), float(ff_list[p[1]][1]), function_r612),3)
            comb_dict_e612[ff_list[p[0]][0], ff_list[p[1]][0]] = round(CalculateWeights(float(ff_list[p[0]][2]), float(ff_list[p[1]][2]), function_e612),3)
        
        else:
            comb_dict_r612[ff_list[p[1]][0], ff_list[p[0]][0]] = round(CalculateWeights(float(ff_list[p[0]][1]), float(ff_list[p[1]][1]), function_r612),3)
            comb_dict_e612[ff_list[p[1]][0], ff_list[p[0]][0]] = round(CalculateWeights(float(ff_list[p[0]][2]), float(ff_list[p[1]][2]), function_e612),3)
    
    return comb_dict_r612, comb_dict_e612    

## User inputs the form of weighing function
def CalculateWeights(value1, value2, function):
    x1 = value1
    x2 = value2
    return eval(function)

## Write dictionaries to files:
def Save_Dict(out_fname, dictionary):
    out = open(out_fname, 'w')
    w = csv.writer(out)
    for key, value in dictionary.items():
        w.writerow([key, value])
    out.close()

##========================================================================================================================================================
def main():
    # parser = OptionParser()
    # print(sys.argv[1:])
    # parser.add_option("--in", dest = "fname")
    # print(fname)
    # parser.add_option("--out_r612", dest='out_r612')
    # parser.add_option("--out_e612", dest='out_e612')
    # optlist, args = parser.parse_args(sys.argv[1:])
    optlist, args = getopt.getopt(sys.argv[1:], '', ['in=', 'out_r612=', 'out_e612='])
    fname = None
    out_r612 = None
    out_e612 = None
    for o, a in optlist:
        if o == "--in": fname = a
        if o == "--out_r612": out_r612 = a
        if o == "--out_e612": out_e612 = a

    ## Read file with parameters
    FF_list = Create_FF_list(fname)
    Dict_r612, Dict_e612 = Atom_Combinations(FF_list)
    # Save dictionaries
    Save_Dict(out_r612, Dict_r612)
    Save_Dict(out_e612, Dict_e612)

##=========================================================================================================================================================

if __name__ == '__main__':
    main()  
    
