def equals_false(value):
    if isinstance(value, str):
        if value.lower() in [
            'false',
            'no',
            '0',
            ''
        ]:
            return True
    
    return value in [
        False,
        None,
        0
    ] or len(value) < 0

def equals_empty(value):
    if isinstance(value, str):
        if value.strip(' ') in ['', '-']:
            return True
    
    return len(value) < 1 or equals_false(value)

def colored(color, text):
    endcolor = '\033[0m'
    colormap = {
        "HEADER": '\033[95m',
        "BLUE": '\033[94m',
        "CYAN": '\033[96m',
        "GREEN": '\033[92m',
        "WARNING": '\033[93m',
        "FAIL": '\033[91m',
        "BOLD": '\033[1m',
        "UNDERLINE": '\033[4m',
    }
    
    color = colormap.get(color, False)
    if color:
        return color + str(text) + endcolor
    
    return text