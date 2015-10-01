from collections import Counter, defaultdict
from itertools import combinations, product
from sdf import ReadSDF, ReadMolList, ReadDict, SaveFrags
import getopt, sys, os
import csv
import argparse

from pairs_ff import Save_Dict

def PairFrags(mol1, mol2):
    '''finds all combinations of two atoms for two separate molecules'''
    flist ={}
    part_frag_list = defaultdict(int)
    for p in product(mol1.atoms, mol2.atoms):
        a = str(mol1.atoms[p[0]]['label'])
        b = str(mol2.atoms[p[1]]['label'])
        if a>b:
                part_frag_list[str((a,b))] += 1
        else:
                part_frag_list[str((b,a))] += 1
    # flist[mol1.title, '+', mol2.title] = part_frag_list
    return part_frag_list
    
def main():
    optlist, args = getopt.getopt(sys.argv[1:], '', ['ml=', 'in=', 'FF=', 'out='])
    mlname = None
    fname = None
    FF_name = None
    out = None
    for o, a in optlist:
        if o == "--ml": mlname = a
        if o == "--in": fname = a
        if o == "--FF": FF_name = a
        if o == "--out": out = a
    if mlname is None:
        print("Error. Option --ml is required.")
        exit()
    if fname is None:
        print("Error. Option --in is required.")
        exit()
    if FF_name is None:
        print("Error. Option --FF is required.")
        exit()
    if out is None:
        print("Error. Option --out is required.")
        exit()
        
    # fname_1, fname_2 = ReadMolList(mlname)
    mlist = ReadMolList(mlname)
    mols = ReadSDF(fname)
    FF_d = ReadDict(FF_name)
    FF_names = FF_d.keys()


    
    
    fdict = {}
    for item in mlist:    
        # print(item[0], item[1])
        mol_1_list = [m for m in mols if m.title == item[0]]
        mol_2_list = [n for n in mols if n.title == item[1]]
        for m in mol_1_list: 
            mol_1 = m
        for n in mol_2_list: 
            mol_2 = n
        # fdict = PairFrags(mol_1, mol_2)
        key = str(mol_1.title + '+' + mol_2.title)
        fdict[key] = PairFrags(mol_1, mol_2)
        
    for dict in fdict.values():
        for pair in dict.keys():
            dict[pair] = float(dict[pair])*float(FF_d[pair])
    
    # Assign types ===TEST===
    tdict = {}
    ##REMEMBER THAT FDICT is dict in dict so tdict should contain the names of molecules as well
    # for dict in fdict.values():
        # for pair in dict.keys():
            # if dict[pair] < 0.1:
                # tdict["Pair_weak"] += 1
            # elif dict[pair] >= 0.1:
                # tdict["Pair_medium"] += 1
            # else:
                # tdict["Pair_strong"] += 1
                
    for name in fdict.keys():
        tdict[name] = defaultdict(int)
        tdict[name]["Pair_weak"] = 0
        tdict[name]["Pair_medium"] = 0
        tdict[name]["Pair_strong"] = 0
        for pair in fdict[name].keys():
            fdict[name][pair]
            # if fdict[name][pair] <= 0.1:
                # tdict[name]["Pair_weak"] += 1
            # elif 0.1 < fdict[name][pair] <= 0.3:
                # tdict[name]["Pair_medium"] += 1
            # elif fdict[name][pair] > 0.3:
                # tdict[name]["Pair_strong"] += 1
            if fdict[name][pair] <= 3.5:
                tdict[name]["Pair_weak"] += 1
            elif 3.5 < fdict[name][pair] <= 4:
                tdict[name]["Pair_medium"] += 1
            elif fdict[name][pair] > 4:
                tdict[name]["Pair_strong"] += 1
    
    #print(tdict.values())    
    # Save_Dict(out, fdict)
    SaveFrags(out, tdict, ["Pair_weak", "Pair_medium", "Pair_strong"])
                   
if __name__ == '__main__':
    import sys
    main()                           
    
