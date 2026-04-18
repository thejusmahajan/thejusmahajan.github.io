import glob, re

for file in glob.glob('/scratch/local1/my_website_gitio/*.html'):
    with open(file, 'r') as f:
        content = f.read()

    # Fix indentation for the main 20 files
    if '\n<a href="[XING-URL-PLACEHOLDER]"' in content:
        content = content.replace('\n<a href="[XING-URL-PLACEHOLDER]"', '\n                <a href="[XING-URL-PLACEHOLDER]"')

    # Add Xing to rogue files
    rogue_linkedin = r'(<a\s+href="https://www\.linkedin\.com/in/thejusmahajan"\s+target="_blank"\s*class="[^"]+">LinkedIn</a>)'
    def repl_rogue(m):
        original = m.group(1)
        xing_part = original.replace("https://www.linkedin.com/in/thejusmahajan", "[XING-URL-PLACEHOLDER]").replace(">LinkedIn<", ">Xing<")
        return original + "\n                " + xing_part
    
    if re.search(rogue_linkedin, content) and '[XING-URL-PLACEHOLDER]' not in content:
        content = re.sub(rogue_linkedin, repl_rogue, content)
        
    with open(file, 'w') as f:
        f.write(content)
