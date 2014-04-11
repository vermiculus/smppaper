import yaml
import copy
import random
import networkx as nx

def neighbor_data(graph, node):
    return {v: graph.node[v] for v in graph.neighbors(node)}

class SecretYAMLObject(yaml.YAMLObject):
    hidden_fields = []
    @classmethod
    def to_yaml(cls, dumper, data):
        new_data = copy.deepcopy(data)
        for item in cls.hidden_fields:
            del new_data.__dict__[item]
            return dumper.represent_yaml_object(
                cls.yaml_tag, new_data,
                cls, flow_style=cls.yaml_flow_style)

class Move(SecretYAMLObject):
    yaml_tag = u'!Move'
    yaml_flow_style = False
    ssa_folder = 'moves'

    def __init__(self, filename, name, description, author, date, tex):
        self.filename    = filename
        self.name        = name
        self.description = description
        self.author      = author
        self.date        = date
        self.tex         = tex

    def __repr__(self):
        return "{!s} '{!s}'".format(self.__class__.__name__.lower(), self.name)

class Predicate(SecretYAMLObject):
    yaml_tag = u'!Predicate'
    yaml_flow_style = False
    ssa_folder = 'predicates'

    def __init__(self, filename, name, description, author, date, tex):
        self.filename    = filename
        self.name        = name
        self.description = description
        self.author      = author
        self.date        = date
        self.tex         = tex

    def __repr__(self):
        return "{!s} '{!s}'".format(self.__class__.__name__.lower(),
                                    self.name)

class Rule(yaml.YAMLObject):
    yaml_tag = u'!Rule'
    def __init__(self, description, author, date, predicate, moves):
        self.description = description
        self.author      = author
        self.date        = date
        self.predicate   = predicate
        self.moves       = moves

    def applies_to(self, v, N):
        return bool(self.predicate(v, N))

    def apply_to(self, graph, node, r=random):
        move                  = r.choice(self.moves)
        old_node              = copy.deepcopy(node)
        old_node_data         = copy.deepcopy(graph.node[node])
        old_neighborhood_data = copy.deepcopy(neighbor_data(graph, node))

        move(v, N)

        return {
            'node'          : (old_node, old_node_data),
            'neighbors'     : old_neighborhood_data,
            'move'          : move,
            'new node'      : node,
            'new neighbors' : neighbor_data(graph, node)
        }


class Algorithm(yaml.YAMLObject):
    yaml_tag = u'!Algorithm'
    yaml_flow_style = False
    ssa_folder = None

    def __init__(self, name, author, date, rules):
        self.name   = name
        self.author = author
        self.date   = date
        self.rules  = rules

    def resolve_rules(self, entities):
        mapping = {entity.name if hasattr(entity, 'name') else repr(entity): entity
                   for entity in entities}
        for rule in self.rules:
            rule.predicate = mapping[rule.predicate]
            rule.moves = [mapping[m] for m in rule.moves]

    def run(self, graph, count=1):
        assert count >= 0
        history = list()
        while count > 0:
            privileged_nodes = dict()
            for node in graph:
                neighbors = neighbor_data(graph, node)
                for rule in self.ruleset:
                    if rule.applies_to(graph.node[node], neighborhood.values()):
                        if node in privileged_nodes:
                            privileged_nodes[node] += rule
                        else:
                            privileged_nodes[node] = [rule]
            if not privileged_nodes:
                break
            node = random.choice(list(privileged_nodes.keys()))
            neighbors = neighbor_data(graph, node)
            applied_rule = random.choice(privileged_nodes[node])
            log = rule.apply_to(node, neighbors)
            history.append(log)
            count -= 1
        return history

    def has_stabilized(self, graph):
        for node in graph:
            neighbors = neighbor_data(graph, node)
            for rule in self.ruleset:
                if rule.applies_to(graph.node[node], neighborhood.values()):
                    return False
        return True

    def stabilize(self, graph):
        while not self.has_stabilized(graph):
            self.run(graph)

    def __repr__(self):
        return "{!s} '{!s}'".format(self.__class__.__name__.lower(), self.name)

class Bundle:

    def __init__(self, initpath=None,
                 move_dir='moves', predicate_dir='predicates',
                 description_document='bundle.yaml'):

        self.entities             = set()
        self.move_dir             = move_dir
        self.predicate_dir        = predicate_dir
        self.description_document = description_document

        self.__len__      = self.entities.__len__
        self.__contains__ = self.entities.__contains__
        self.__iter__     = lambda s: iter(s.entities)
        self.__next__     = iter(self.entities).__next__

        # def construct_rule(loader, node):
        #     value = loader.construct_mapping(node)
        #     r = Rule(**value)

        #     # does filter return a list already?  Python 3 is funky
        #     print(r.predicate)
        #     print(self.entities)
        #     print(list(map(lambda e: e.name, self.entities)))
        #     predicate = list(filter(lambda m: hasattr(m, 'name') and m.name == r.predicate,
        #                             self.entities))
        #     if not predicate: raise Exception()
        #     if len(predicate) > 1: raise Exception()
        #     r.predicate = predicate[0]

        #     # can definitely speed this up
        #     real_moves = list()
        #     for move_name in r.moves:
        #         move = filter(lambda m: hasattr(m, 'name') and m.name == move_name, self.entities)
        #         if not move: raise Exception()
        #         if len(move) > 1: raise Exception()
        #         real_moves.append(move)

        #     r.moves = real_moves
        #     return r
        #     # construct_rule needs to go in Bundle so that it may access the entity names

        # yaml.add_constructor(u'!Rule', construct_rule)

        if initpath is not None:
            self.load(initpath)

    def __len__(self):
        return len(self.entities)

    def __contains__(self, item):
        return self.entities.contains(item)

    def __iter__(self):
        self.__entity_iterator = iter(self.entities)
        return self.__entity_iterator

    def __next__(self):
        r = next(self.__entity_iterator)

    def load(self, path):
        fullpath = '{!s}/{!s}'.format(path, self.description_document)
        yaml_objects = list(yaml.load_all(open(fullpath, 'r')))
        [self.load_definition(path, obj) for obj in yaml_objects]
        self.entities.update(yaml_objects)

    def load_definition(self, path, ssa_obj):
        if hasattr(ssa_obj, 'filename'):
            tag   = ssa_obj.__class__.yaml_tag
            style = ssa_obj.__class__.yaml_flow_style

            # Create new class with inherited YAML attributes
            ssa_obj.__class__ = type(ssa_obj.__class__.__name__,
                                     (ssa_obj.__class__,),
                                     {
                                         'yaml_tag': tag,
                                         'yaml_flow_style': style
                                     })

            # Define call
            with open('/'.join([path, ssa_obj.ssa_folder, ssa_obj.filename])) as f:
                lines = f.readlines()

            ssa_obj._definition = lines

            lines = ['def temp(self, v, N):\n'] + \
                    ['    ' + l for l in lines]
            exec("".join(lines), locals())
            ssa_obj.__class__.__call__ = locals()['temp']


    def sorted(self):
        return sorted(self.entities, reverse=True, key=lambda e: repr(e))

    def to_yaml(self):
        return yaml.dump_all(self.sorted(), explicit_start=True)

    def dump(self, path):
        # create path as directory
        import os
        os.makedirs(path, exist_ok=True)
        for subdir in [self.move_dir, self.predicate_dir]:
            os.makedirs('{!s}/{!s}'.format(path, subdir), exist_ok=True)
        # gather predicates and moves and set in directories
        predicates = []
        moves      = []
        algorithms = []
        for entity in self.entities:
            name = entity.__class__.__name__
            if   name ==      Move.__name__:      moves.append(entity)
            elif name == Predicate.__name__: predicates.append(entity)
            elif name == Algorithm.__name__: algorithms.append(entity)
            else: raise Exception('Encountered an invalid object: {!r}'.format(name))

        for p in predicates:
            with open('/'.join([path, self.predicate_dir, p.filename]), 'w') as f:
                f.writelines(p._definition)

        for p in moves:
            with open('/'.join([path, self.move_dir, p.filename]), 'w') as f:
                f.writelines(p._definition)

        yaml.dump_all(self.sorted(),
                      open('{}/{}'.format(path, self.description_document), 'w'),
                      explicit_start=True)

b = Bundle('test.ssax')
a = b.sorted()[-1]

print('done')
