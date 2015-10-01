#-------------------------------------------------------------------------------
# Name:        sdf
# Purpose:     operations with sdf files (reading)
#
# Author:      Pavel
#
# Created:     11.01.2013
# Copyright:   (c) Pavel 2013
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#!/usr/bin/env python

import os, csv

from mols import Mol3 as Mol

def MolstrToMol(molstr):
    mol = Mol()
    mol.title = molstr[0]
    natoms = int(molstr[3][0:3])
    nbonds = int(molstr[3][3:6])
    # read atoms
    id = 0
    for line in molstr[4:4+natoms]:
        x = float(line[0:10])
        y = float(line[10:20])
        z = float(line[20:30])
        label = line[30:33].strip()
        id += 1
        mol.AddAtom(id, label, x, y, z)
    # read bonds
    for line in molstr[4+natoms:4+natoms+nbonds]:
        id1 = int(line[0:3])
        id2 = int(line[3:6])
        bond_type = int(line[6:9])
        mol.AddBond(id1, id2, bond_type)
    return mol
    
 
    
def ReadSDF(fname):
    mols = []
    molstr = []
    f = open(fname)
    for line in f:
        if line.find("$$$$") < 0:
            molstr.append(line.rstrip())
        else:
            mols.append(MolstrToMol(molstr))
            molstr = []
    return mols

def LoadRangedProperty(mols, setup_dir, prop_fname):

    def ReturnPropertyRange(f, prop_name):
        res = None
        for line in f:
            if prop_name == line.split('=')[0]:
                res = list(map(float, line.strip().split('=')[1].split('<')))
                break
        return(res)

    def RangedLetter(value, prop_range):
        s = 'ABCDEFGHJKLMNOP'
        if value <= prop_range[0]:
            return('A')
        for i in range(len(prop_range)):
            if i == 0 and value <= prop_range[0]:
                return('A')
            if prop_range[i-1] < value <= prop_range[i]:
                return(s[i])
            if i == len(prop_range)-1 and value > prop_range[-1]:
                return(s[i+1])
        print('Property label was not assigned.')
        return(None)

    try:
        fsetup = open(os.path.join(setup_dir, 'setup.txt'))
    except:
        print('File setip.txt cannot be found in the folder containing input sdf file.')
        exit()
    prop_name = prop_fname[-3:]
    prop_range = ReturnPropertyRange(fsetup, prop_name)
    fsetup.close()
    if prop_range is None:
        print('Cannot find "%s" property in setup.txt' % prop_name)
        exit()
    # read property file
    f = open(os.path.join(setup_dir, prop_fname))
    sep = '-'*10
    d = {}
    while True:
        line = f.readline()
        if not line: break
        if line[0:10] == sep:
            title = f.readline().split('.')[0]
            n = int(f.readline().strip())
            tmp = f.readline()
            d[title] = list(map(float, [f.readline().split()[1] for i in range(n)]))
    f.close()
    # assign property values to atoms
    for m in mols:
        values = d[m.title]
        for i, a in enumerate(sorted(m.atoms.keys())):
            m.atoms[a]['property'][prop_name] = {'value': values[i], 'label': RangedLetter(values[i], prop_range)}

##Simple Function For Mixtures            
def ReadMolList(mlname):
    mfile = open(mlname)
    mlist = csv.reader(mfile, delimiter = ',')
    # fnames_1 = []
    # fnames_2 = []
    # for line in mlist:
        # fnames_1.append(line[0])
        # fnames_2.append(line[1])
    # return fnames_1, fnames_2
    return mlist

def ReadDict(f_name):
    file_open = open(f_name, 'rt')
    file_ = csv.reader(file_open, delimiter = ',')
    dict = {}
    for line in file_:
        if len(line) != 0:
            dict[line[0]] = line[1]
    return dict

# def SaveFrags(fname, frags, f_names):
    # f_out = open(fname, 'wt')
    # name_FF = raw_input('Print the name of the used FF: ')
    # f_out.write("Force Field used: " + "".join(name_FF) + "\n")
    # f_names = sorted(f_names)
    
    # compound_names = sorted(frags.keys())
    # # print(compound_names)
    # f_out.write("Descriptors\t" + "\t".join(compound_names) + "\n")
    # for n in f_names:
        # line = []
        # for m in compound_names:
            # line.append(frags[m].get(n, 0))
        # f_out.write(n + "\t" + "\t".join(map(str, line)) + "\n")
    # f_out.close()
    
def SaveFrags(fname, frags, f_names):
    f_out = open(fname, 'wt')
    name_FF = input('Print the name of the used FF: ')
    f_out.write("Force Field used: " + "".join(name_FF) + "\n")
    f_names = sorted(f_names)
    
    compound_names = sorted(frags.keys())
    f_out.write("Descriptors\t" + "\t".join(compound_names) + "\n")
    for n in f_names:
        line = []
        for m in compound_names:
            line.append(frags[m].get(n, 0))
        f_out.write(n + "\t" + "\t".join(map(str, line)) + "\n")
    f_out.close()


