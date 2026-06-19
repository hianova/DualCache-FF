import os
import glob
import re

def update_max_threads():
    files = glob.glob('tests/it/*.rs')
    for file in files:
        with open(file, 'r') as f:
            content = f.read()
        
        # Replace Config::new_expert(..., 2) or 4 or anything < 128 with 128
        new_content = re.sub(r'(Config::new_expert\([^,]+,\s*[^,]+,\s*[^,]+,\s*[^,]+,\s*)(\d+)(\s*\))', 
                             lambda m: m.group(1) + ('128' if int(m.group(2)) < 128 else m.group(2)) + m.group(3), 
                             content)
        
        if new_content != content:
            with open(file, 'w') as f:
                f.write(new_content)

if __name__ == '__main__':
    update_max_threads()
