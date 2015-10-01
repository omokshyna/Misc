#-------------------------------------------------------------------------------
# Name:        fullerenes_cyc
# Purpose:     finds all 5 and 6 cycles in fullerene molecule
#
# Author:      Olena Mokshyna
#
# Created:     24.01.2013
#-------------------------------------------------------------------------------

def PathCycle(graph, start, path_list = [], global_list = []):
    for n in graph.bonds[start].keys():
        if n not in path_list and len(path_list) <= 6:
            PathCycle (graph, n, path_list + [n], global_list)
        elif path_list[0] == n and len(path_list) in [5,6]:
            if sorted(path_list) not in global_list:
                global_list.append(sorted(path_list))
    return global_list
   
               
##TEST1                       
from sdf import ReadSDF
mols = ReadSDF('D:\NANO\Cioslowski\converted\c060_001.sdf')
for m in mols:
    for atom in m.atoms:
        path = sorted(PathCycle(m, atom, path_list = []), key = lambda x: len(x))
        for element in path:
            m.atoms[atom]['label'] = m.atoms[atom]['label'] + str(len(element))
                                                                  
    print(path)

