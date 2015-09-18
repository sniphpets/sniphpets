import re

def camel_to_snake(camel, delimiter = '_'):
    regex = r'\1' + delimiter + r'\2'
    s1 = re.sub('(.)([A-Z][a-z]+)', regex, camel)
    return re.sub('([a-z0-9])([A-Z])', regex, s1).lower()

def snake_to_camel(snake, delimiter = '_'):
    components = snake.split(delimiter)
    return components[0] + "".join(x.title() for x in components[1:])
