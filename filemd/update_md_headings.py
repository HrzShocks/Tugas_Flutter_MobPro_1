import os

MD_DIR = 'manual_book'

def update_headings(content):
    lines = content.split('\n')
    new_lines = []
    in_code = False
    for line in lines:
        if line.strip().startswith('```'):
            in_code = not in_code
            new_lines.append(line)
            continue
            
        if not in_code:
            # Demote Part Title so it doesn't conflict with Bab (Heading 1)
            if line.startswith('# Manual Book Bagian'):
                line = line.replace('# ', '### Title: ')
            # Promote Bab from ## to # (Heading 1)
            elif line.startswith('## Bab '):
                line = line.replace('## Bab ', '# Bab ', 1)
            # Promote Struktur from ## to # (Heading 1)
            elif line.startswith('## Struktur '):
                line = line.replace('## Struktur ', '# Struktur ', 1)
            # Promote Sub-bab from ### to ## (Heading 2)
            elif line.startswith('### '):
                line = line.replace('### ', '## ', 1)
            # Promote Sub-sub-bab from #### to ### (Heading 3)
            elif line.startswith('#### '):
                line = line.replace('#### ', '### ', 1)
        
        new_lines.append(line)
    return '\n'.join(new_lines)

for filename in os.listdir(MD_DIR):
    if filename.endswith('.md'):
        path = os.path.join(MD_DIR, filename)
        with open(path, 'r') as f:
            content = f.read()
        
        content = update_headings(content)
        
        with open(path, 'w') as f:
            f.write(content)
print("Updated markdown headings.")
