"""Investigate remaining â patterns in the file."""
import sys
import re

filepath = sys.argv[1]

with open(filepath, encoding='utf-8') as f:
    content = f.read()

# Find all â with surrounding context  
for m in re.finditer(r'.{0,5}\u00e2.{0,10}', content):
    chars = m.group()
    hex_repr = ' '.join(f'U+{ord(c):04X}' for c in chars)
    print(f'{repr(chars)}  -> {hex_repr}')
