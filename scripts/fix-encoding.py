"""Fix mojibaked Harvey ball characters in markdown files."""
import sys

filepath = sys.argv[1]

with open(filepath, 'rb') as f:
    raw = f.read()

content = raw.decode('utf-8')

# The file has Harvey balls that went through UTF-8 -> Windows-1252 -> UTF-8 cycle
# then the humanizer replaced the phantom em dashes with ' - '
replacements = {
    '\u00e2 - \u008f': '\u25cf',   # ●
    '\u00e2 - \u2022': '\u25d5',   # ◕
    '\u00e2 - \u2018': '\u25d1',   # ◑
    '\u00e2 - \u201c': '\u25d4',   # ◔ (left double quote)
    '\u00e2 - \u201d': '\u25d4',   # ◔ (right double quote)
    '\u00e2 - \u0022': '\u25d4',   # ◔ (straight double quote)
    '\u00e2 - \u2039': '\u25cb',   # ○
    '\u00e2\u20ac\u201c': ' -',    # em dash mojibake (â€")
    '\u00e2\u20ac\u201d': ' -',    # em dash mojibake variant (â€")
    '\u00e2\u0080\u0093': ' -',    # em dash mojibake
    '\u00e2\u0080\u0094': ' -',    # em dash mojibake variant
}

for old, new in replacements.items():
    count = content.count(old)
    if count > 0:
        print(f"Replacing {repr(old)} -> {repr(new)} ({count} occurrences)")
        content = content.replace(old, new)

# Check for remaining â characters
remaining = content.count('\u00e2')
print(f"Remaining \\u00e2 chars: {remaining}")

# Verify Harvey balls present
for name, char in [('●', '\u25cf'), ('◕', '\u25d5'), ('◑', '\u25d1'), ('◔', '\u25d4'), ('○', '\u25cb')]:
    present = char in content
    print(f"{name} present: {present}")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done.")
