marked = v['marked']
neighbor_marked = any(map(lambda n: n['marked'], N))
return not (marked or neighbor_marked)
