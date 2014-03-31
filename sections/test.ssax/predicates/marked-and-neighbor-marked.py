marked = v['marked']
neighbor_marked = any(map(lambda n: n['marked'], N))
return marked and neighbor_marked
