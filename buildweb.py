#!/usr/bin/env python3

from jinja2 import FileSystemLoader, Template, Environment

env = Environment()
env.loader = FileSystemLoader(['web'])

t = env.get_template('documentation.jinja')
with open('web/documentation.html', 'w') as fd:
    fd.write(t.render())

t = env.get_template('index.jinja')
with open('web/index.html', 'w') as fd:
    fd.write(t.render())
