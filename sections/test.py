import yaml

class Move(yaml.YAMLObject):
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

class Predicate(yaml.YAMLObject):
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
        return "{!s} '{!s}'".format(self.__class__.__name__.lower(), self.name)

class Algorithm(yaml.YAMLObject):
    yaml_tag = u'!Algorithm'
    yaml_flow_style = False

    def __init__(self, name, author, date, rules):
        self.name   = name
        self.author = author
        self.date   = date
        self.rules  = rules

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
