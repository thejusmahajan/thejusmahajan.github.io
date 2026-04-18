import glob
import re

desc_meta = '<meta name="description" content="Computational scientist (PhD) with recent experience refactoring clinical data pipelines at scale (143,000+ patient records, German DeGIR registry). Available in Hamburg / Berlin / remote.">'
og_meta = '<meta property="og:image" content="images/faceshot_tilted_01.png">'

html_files = glob.glob('/scratch/local1/my_website_gitio/*.html')

for filepath in html_files:
    with open(filepath, 'r') as f:
        content = f.read()

    # Remove existing description meta tags
    content = re.sub(r'<meta\s+name="description"\s+content="[^"]*">\s*', '', content)
    
    title_pattern = r'(<title>.*?</title>)'
    
    if re.search(r'<meta\s+property="og:image"', content):
        # og:image already exists, only add description
        replacement = r'\1\n    ' + desc_meta
    else:
        # add both
        replacement = r'\1\n    ' + desc_meta + '\n    ' + og_meta
        
    new_content = re.sub(title_pattern, replacement, content, count=1, flags=re.DOTALL)
    
    with open(filepath, 'w') as f:
        f.write(new_content)

