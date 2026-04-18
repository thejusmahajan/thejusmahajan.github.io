import os
import glob
import re

html_files = glob.glob('/scratch/local1/my_website_gitio/*.html')
modified_files = []

# Desktop nav patterns
re_desktop = re.compile(r'<a\s+href="dashboard\.html"\s+class="([^"]+)">DeGIR Dashboard</a>')
def repl_desktop(m):
    return f'<a href="https://thejusmahajan.shinyapps.io/degir-dashboard/" target="_blank" rel="noopener noreferrer" class="{m.group(1)}">Live DeGIR Dashboard</a>'

# LinkedIn pattern
re_linkedin = re.compile(r'(<a\s+href="https://www\.linkedin\.com/in/thejusmahajan/"[^>]+>\s*LinkedIn\s*</a>)')
def repl_linkedin(m):
    original = m.group(1)
    # create xing link by mimicking the linkedin one
    xing_part = original.replace("https://www.linkedin.com/in/thejusmahajan/", "[XING-URL-PLACEHOLDER]").replace("LinkedIn", "Xing")
    return original + "\n" + xing_part


for file in html_files:
    with open(file, 'r') as f:
        content = f.read()

    new_content = content
    new_content = re_desktop.sub(repl_desktop, new_content)
    new_content = re_linkedin.sub(repl_linkedin, new_content)
    
    if new_content != content:
        modified_files.append(os.path.basename(file))
        with open(file, 'w') as f:
            f.write(new_content)

print(f"Modified {len(modified_files)} files:")
for f in modified_files:
    print(f)
