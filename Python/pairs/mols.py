#-------------------------------------------------------------------------------
# Name:        mols
# Purpose:     Mol class to operate with molecules
#
# Author:      Pavel
#
# Created:     11.01.2013
# Copyright:   (c) Pavel 2013
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#!/usr/bin/env python

# Mol class
class Mol:
    def __init__(self):
        self.atoms = {}
        self.bonds = {}
        self.title = ""
    def AddAtom(self, id, label, x, y, z):
        self.atoms[id] = {'label': label, 'x': x, 'y': y, 'z': z}
    def AddBond(self, atom_id1, atom_id2, bond_type):
        self.bonds[atom_id1, atom_id2] = self.bonds[atom_id2, atom_id1] = bond_type
    def GetBondType(self, atom_id1, atom_id2):
        return(self.bonds.get((atom_id1, atom_id2), 0))

from collections import defaultdict

class Mol2:
    def __init__(self):
        self.atoms = {}
        self.bonds = defaultdict(int)
        self.title = ""
    def AddAtom(self, id, label, x, y, z):
        self.atoms[id] = {'label': label, 'x': x, 'y': y, 'z': z, 'property': {}}
        self.bonds[id] = defaultdict(int)
    def AddBond(self, id1, id2, bond_type):
        if id1 not in self.bonds.keys():
            self.bonds[id1] = defaultdict(int)
        if id2 not in self.bonds.keys():
            self.bonds[id2] = defaultdict(int)
        self.bonds[id1][id2] = self.bonds[id2][id1] = bond_type
    def GetBondType(self, id1, id2):
        return(self.bonds[id1][id2])
    def SetSybylTypes(self):
        for id, a in self.atoms.items():
            sybyl_type = self.GetSybylType(id)
            a['property']['type'] = {'value': sybyl_type, 'label': sybyl_type}

    def GetSybylType(self, id):
        if self.atoms[id]['label'] == "C":
            b = list(self.bonds[id].values())
            if b == [2,2] or 3 in b:
                return("C.1")
            if 2 in b:
                return("C.2")
            if 4 in b:
                return("C.ar")
            if b == [1]*len(b):
                return("C.3")
            return("C")
        if self.atoms[id]['label'] == "N":
            b = list(self.bonds[id].values())
            # look at surroundings, if there is a pattern "single bond to C then double bound to O" then it's N.am
            N_am = []
            for k, v in self.bonds[id].items():
                if v == 1 and self.atoms[k]['label'] == "C":
                    for k1, v1 in self.bonds[k].items():
                        if v1 == 2 and self.atoms[k1]['label'] == "O":
                            N_am.append(True)
                        else:
                            N_am.append(False)
            if any(N_am):
                return("N.am")
            n = sum([i == 2 or i == 4 for i in b])
            n_heavy = sum([self.atoms[i]['label'] != "H" for i in self.bonds[id].keys()])
            # look at surroundings, if there is a pattern "single bond then double bound or aromatic bond" then it's N.pl3
            N_pl3 = []
            for k, v in self.bonds[id].items():
                if v == 1:
                    for v1 in self.bonds[k].values():
                        if v1 == 2 or v1 == 4:
                            N_pl3.append(True)
                        else:
                            N_pl3.append(False)
##            N_pl3 = any([True if v1 == 2 or v1 == 4 else False for v1 in self.bonds[k].values() if v == 1 for k, v in self.bonds[id].items()])
            if (n_heavy == 3 and n == 2) or any(N_pl3):
                return("N.pl3")
            if 4 in b:
                return("N.ar")
            if 2 in b:
                return("N.2")
            if 3 in b or b == [2,2]:
                return("N.1")
            if b == [1]*len(b):
                return("N.3")
            return("N")
        if self.atoms[id]['label'] == "O":
            b = list(self.bonds[id].values())
            if b == [2] or 4 in b:
                return("O.2")
            if b == [1]*len(b):
                return("O.3")
            return("O")
        if self.atoms[id]['label'] == "S":
            # number of =O surrounding groups and double bonds
            n_O = sum([True if v == 2 and self.atoms[k]['label'] == "O" else False for k, v in self.bonds[id].items()])
            n_double = sum( [True if v == 2 else False for k, v in self.bonds[id].items()])
            if n_O == 1 == n_double and len(self.bonds[id]) <= 3:
                return("S.O")
            if n_O == 2 == n_double and len(self.bonds[id]) <= 4:
                return("S.O2")
            if n_double == 0:
                return("S.3")
            if n_double > 0 or 4 in list(self.bonds[id].values()):
                return("S.2")
            return("S")
        if self.atoms[id]['label'] == "P":
            return("P.3")
        return(self.atoms[id]['label'])

class Mol3:
    def __init__(self):
        self.atoms = {}
        self.bonds = dict()
        self.title = ""
    def AddAtom(self, id, label, x, y, z):
        self.atoms[id] = {'label': label, 'x': x, 'y': y, 'z': z, 'property': {}}
        self.bonds[id] = dict()
    def AddBond(self, id1, id2, bond_type):
        if id1 not in self.bonds.keys():
            self.bonds[id1] = dict()
        if id2 not in self.bonds.keys():
            self.bonds[id2] = dict()
        self.bonds[id1][id2] = self.bonds[id2][id1] = bond_type
    def GetBondType(self, id1, id2):
        try:
            return(self.bonds[id1][id2])
        except KeyError:
            return(0)
    def SetSybylTypes(self):
        for id, a in self.atoms.items():
            sybyl_type = self.GetSybylType(id)
            a['property']['type'] = {'value': sybyl_type, 'label': sybyl_type}
    def GetSybylType(self, id):
        if self.atoms[id]['label'] == "C":
            b = list(self.bonds[id].values())
            if b == [2,2] or 3 in b:
                return("C.1")
            if 2 in b:
                return("C.2")
            if 4 in b:
                return("C.ar")
            if b == [1]*len(b):
                return("C.3")
            return("C")
        if self.atoms[id]['label'] == "N":
            b = list(self.bonds[id].values())
            # look at surroundings, if there is a pattern "single bond to C then double bound to O" then it's N.am
            N_am = []
            for k, v in self.bonds[id].items():
                if v == 1 and self.atoms[k]['label'] == "C":
                    for k1, v1 in self.bonds[k].items():
                        if v1 == 2 and self.atoms[k1]['label'] == "O":
                            N_am.append(True)
                        else:
                            N_am.append(False)
            if any(N_am):
                return("N.am")
            n = sum([i == 2 or i == 4 for i in b])
            n_heavy = sum([self.atoms[i]['label'] != "H" for i in self.bonds[id].keys()])
            # look at surroundings, if there is a pattern "single bond then double bound or aromatic bond" then it's N.pl3
            N_pl3 = []
            for k, v in self.bonds[id].items():
                if v == 1:
                    for v1 in self.bonds[k].values():
                        if v1 == 2 or v1 == 4:
                            N_pl3.append(True)
                        else:
                            N_pl3.append(False)
##            N_pl3 = any([True if v1 == 2 or v1 == 4 else False for v1 in self.bonds[k].values() if v == 1 for k, v in self.bonds[id].items()])
            if (n_heavy == 3 and n == 2) or any(N_pl3):
                return("N.pl3")
            if 4 in b:
                return("N.ar")
            if 2 in b:
                return("N.2")
            if 3 in b or b == [2,2]:
                return("N.1")
            if b == [1]*len(b):
                return("N.3")
            return("N")
        if self.atoms[id]['label'] == "O":
            b = list(self.bonds[id].values())
            if b == [2] or 4 in b:
                return("O.2")
            if b == [1]*len(b):
                return("O.3")
            return("O")
        if self.atoms[id]['label'] == "S":
            # number of =O surrounding groups and double bonds
            n_O = sum([True if v == 2 and self.atoms[k]['label'] == "O" else False for k, v in self.bonds[id].items()])
            n_double = sum( [True if v == 2 else False for k, v in self.bonds[id].items()])
            if n_O == 1 == n_double and len(self.bonds[id]) <= 3:
                return("S.O")
            if n_O == 2 == n_double and len(self.bonds[id]) <= 4:
                return("S.O2")
            if n_double == 0:
                return("S.3")
            if n_double > 0 or 4 in list(self.bonds[id].values()):
                return("S.2")
            return("S")
        if self.atoms[id]['label'] == "P":
            return("P.3")
        return(self.atoms[id]['label'])
    #####Calculate cycles#####
##    def GetCycles(self, id, path_list = [], global_list = []):
##        for n in self.bonds[id].keys():
##            if n not in path_list: [GetCycles(self, n, path_list + [n], global_list)] 
##            elif path_list[0] == n and len(path_list) in [5,6]:
##                if sorted(path_list) not in global_list:
##                    global_list.append(sorted(path_list))
##        return global_list 
    ###########################    
