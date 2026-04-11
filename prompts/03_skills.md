# Prompt 3: Revamp the Skills Page (skills.html)

## Your Role
You are a senior frontend developer specializing in recruiter-optimized portfolio sites. You will rewrite `skills.html` for Dr. Thejus Mahajan's personal website. The goal is to present skills **categorized by relevance to clinical bioinformatics and biostatistics recruiters**, not as a generic programming showcase.

## Context
- The website is hosted on GitHub Pages at https://thejusmahajan.github.io
- Tech stack: static HTML, Tailwind CSS (CDN), vanilla JavaScript, Google Fonts (Inter)
- The current skills page has dark-themed programming cards with percentage bars — this looks like a generic developer portfolio, not a clinical scientist's page.
- We need to reorganize skills into categories that map to what bioinformatics/biostatistics recruiters actually look for.
- Keep the existing file structure. Only modify `skills.html`.
- Keep the CSS file link (`css/style.css`) and JS file link (`js/main.js`).
- You can keep the Devicon CDN link for programming language icons.

## Design Constraints
- Use Tailwind CSS via CDN: `<script src="https://cdn.tailwindcss.com"></script>`
- Use Google Fonts Inter: already linked
- Color scheme: sky-600 as primary accent, gray-50 background, gray-800/900 for text
- Must be fully responsive (mobile-first)
- Do NOT use any JavaScript frameworks. Pure HTML + Tailwind.
- Do NOT use dark-themed cards. Use white/light backgrounds consistent with index.html and experience.html.
- Do NOT use percentage progress bars — they're subjective and unverifiable. Instead, list specific packages/tools under each language.

## Header
Use this EXACT header (same structure as other pages, with Skills highlighted):

```html
<header class="bg-white/80 backdrop-blur-md shadow-sm sticky top-0 z-40 relative">
    <nav class="container mx-auto px-6 py-4 flex justify-between items-center">
        <a href="index.html" class="text-2xl font-bold text-gray-900 tracking-tight">Thejus Mahajan</a>
        <div class="hidden md:flex space-x-8">
            <a href="index.html" class="text-gray-600 hover:text-sky-600 font-medium transition">About</a>
            <a href="experience.html" class="text-gray-600 hover:text-sky-600 font-medium transition">Experience</a>
            <a href="skills.html" class="text-sky-600 font-semibold transition">Skills</a>
            <a href="projects.html" class="text-gray-600 hover:text-sky-600 font-medium transition">Projects</a>
            <a href="blog.html" class="text-gray-600 hover:text-sky-600 font-medium transition">Blog</a>
            <a href="#contact" class="text-gray-600 hover:text-sky-600 font-medium transition">Contact</a>
        </div>
        <button id="mobile-menu-button" class="md:hidden flex items-center text-gray-900 focus:outline-none">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7">
                </path>
            </svg>
        </button>
    </nav>
    <div id="mobile-menu" class="hidden md:hidden bg-white border-t border-gray-100 absolute w-full left-0 shadow-lg">
        <a href="index.html" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">About</a>
        <a href="experience.html" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Experience</a>
        <a href="skills.html" class="block py-4 px-6 text-base font-medium text-sky-600 bg-gray-50">Skills</a>
        <a href="projects.html" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Projects</a>
        <a href="blog.html" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Blog</a>
        <a href="#contact" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Contact</a>
    </div>
</header>
```

## Footer
Use the EXACT same footer as index.html and experience.html (the one with bg-gray-900, Google Scholar link, 2026 copyright).

## Page Structure — What to Build

### Page Title
Use: `<title>Skills | Dr. Thejus Mahajan</title>`

### Section 1: Page Header
Centered heading:
- **Title**: "Technical Skills"
- **Subtitle**: "Tools and methods for clinical bioinformatics, biostatistics, and computational research"

### Section 2: Biostatistics & Data Analysis (THE MOST IMPORTANT SECTION — put it first)
This is what clinical biostatistics recruiters look for. Create a white card with sky-600 left border containing:

**Title**: "Biostatistics & Statistical Methods"

List these as pill/tag items organized in a flowing layout:
- ANOVA
- PCA (Principal Component Analysis)
- Hierarchical Clustering
- Survival Analysis (Kaplan-Meier, Cox regression)
- Multivariate Analysis
- Dimensionality Reduction
- Multiple Testing Correction (Bonferroni, FDR)
- Linear & Logistic Regression
- Mixed-Effects Models
- Markov Chain Monte Carlo

### Section 3: Bioinformatics
Another white card:

**Title**: "Bioinformatics"

List as pills:
- NGS Analysis
- Sequence Alignment (BLAST)
- Structural Bioinformatics
- Nextflow
- Galaxy
- Bioconductor (R)
- Biopython
- NCBI Databases
- Gene Expression Analysis (DESeq2, edgeR)

### Section 4: Programming Languages
Use a grid of 6 cards (3 columns on desktop, 2 on mobile). Each card should be white with a subtle shadow. Show the language name, a brief context line, and a list of key libraries/packages. Do NOT use percentage bars.

**Card 1: R**
- Context: "Primary language for biostatistics and clinical data analysis"
- Packages: Bioconductor, Tidymodels, ggplot2, dplyr/tidyr, Shiny, survival, DT, plotly, devtools/roxygen2

**Card 2: Python**
- Context: "Data science, automation, and bioinformatics pipelines"
- Packages: Pandas, NumPy, scikit-learn, matplotlib, seaborn, Biopython, xarray

**Card 3: SQL**
- Context: "Relational databases and clinical data querying"
- Tools: PostgreSQL, SQLite, database design, complex joins and aggregations

**Card 4: Fortran**
- Context: "Scientific computing and numerical simulation"
- Used for: ERGOM biogeochemical model, GOTM-FABM framework, HPC applications

**Card 5: Bash**
- Context: "Linux system administration and pipeline automation"
- Used for: Shell scripting, HPC job management, Nextflow pipelines, data preprocessing

**Card 6: C++**
- Context: "Signal processing and algorithm development"
- Used for: Particle accelerator data processing, noise cancellation algorithms, ROOT framework

### Section 5: Tools & Platforms
A compact grid of small cards (4 columns desktop, 2 mobile):

- **Git/GitHub** — Version control, collaborative development
- **Linux/Unix** — Primary development environment
- **HPC Clusters** — Job scheduling, parallel computing
- **LaTeX** — Scientific publications, technical documents
- **Quarto/R Markdown** — Reproducible reports and presentations
- **Shiny** — Interactive web applications in R
- **Docker** — Containerized environments (basic)
- **Conda** — Environment and package management

### Section 6: Languages (Human Languages)
A small horizontal row of language badges:
- **English** — Proficient (professional working language)
- **German** — B1 (Goethe certified), actively studying B2
- **French** — Intermediate (PhD in France, 3 years)
- **Malayalam** — Native
- **Hindi** — Proficient

Use simple inline badges, not large cards. This section should be compact.

## Important Notes
- Do NOT use percentage bars for skill levels — they are subjective and recruiters don't trust them
- Do NOT use dark-themed cards — keep the page visually consistent with the rest of the site
- The Devicon CDN can be kept for programming language icons if you want, but it's optional
- Biostatistics should be the FIRST and MOST PROMINENT section since that's what recruiters for these roles look for
- Frame everything through the lens of "clinical bioinformatics applicant", not "generic developer"

## Output Format
Output the **complete** `skills.html` file, ready to save. Include all HTML from `<!DOCTYPE html>` to `</html>`. Do not truncate or use placeholders. Every single line must be present.
