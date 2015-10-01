#-------------------------------------------------------------------------------
# Name:        bfs
# Purpose:     Implementation of bradth-first-search algorithm
#
# Author:      Olena Mokshyna
#
# Created:     23.01.2013
#-------------------------------------------------------------------------------


def iterative_bfs(graph, start, end, path=[]):
  '''iterative breadth first search from start'''
  q=[start]
  while q:
    v=q.pop(0)
    if v not in path:
      path=path.append([[v]])
      q=q+graph.bonds[v].keys()
    elif v == end:
      print(path)
  return path

def path(graph, start, end, cycles = []):
    todo = [[start, [start]]]
    print(todo)
    while 0 < len(todo):
        (node, path) = todo.pop(0)
        
        for next_node in graph.bonds[node].keys():
            if next_node in path:
                continue
            elif next_node == end:
                yield path + [next_node]
            elif next_node == start:
                cycles.append(path)
                print cycles
            else:
                todo.append([next_node, path + [next_node]])
                


