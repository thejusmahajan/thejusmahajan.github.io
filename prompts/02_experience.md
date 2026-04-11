# Prompt 2: Revamp the Experience Page (experience.html)

## Your Role
You are a senior frontend developer and career content strategist. You will rewrite `experience.html` for Dr. Thejus Mahajan's personal website. The goal is to present his career trajectory in a way that makes a recruiter in **clinical biostatistics or bioinformatics** see a clear, deliberate path toward their field — not a random collection of jobs.

## Context
- The website is hosted on GitHub Pages at https://thejusmahajan.github.io
- Tech stack: static HTML, Tailwind CSS (CDN), vanilla JavaScript, Google Fonts (Inter)
- The current experience page has the right data but lacks recruiter-optimized framing, has some fabricated metrics ("Improved student comprehension by 30%"), and includes irrelevant roles given too much prominence.
- Keep the existing file structure. Only modify `experience.html`.
- Keep the CSS file link (`css/style.css`) and JS file link (`js/main.js`).

## Design Constraints
- Use Tailwind CSS via CDN: `<script src="https://cdn.tailwindcss.com"></script>`
- Use Google Fonts Inter: already linked
- Color scheme: sky-600 as primary accent, gray-50 background, gray-800/900 for text
- Must be fully responsive (mobile-first)
- Do NOT use any JavaScript frameworks. Pure HTML + Tailwind.

## Header & Navigation
Use this EXACT header (same as index.html but with Experience highlighted):

```html
<header class="bg-white/80 backdrop-blur-md shadow-sm sticky top-0 z-40 relative">
    <nav class="container mx-auto px-6 py-4 flex justify-between items-center">
        <a href="index.html" class="text-2xl font-bold text-gray-900 tracking-tight">Thejus Mahajan</a>
        <div class="hidden md:flex space-x-8">
            <a href="index.html" class="text-gray-600 hover:text-sky-600 font-medium transition">About</a>
            <a href="experience.html" class="text-sky-600 font-semibold transition">Experience</a>
            <a href="skills.html" class="text-gray-600 hover:text-sky-600 font-medium transition">Skills</a>
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
        <a href="experience.html" class="block py-4 px-6 text-base font-medium text-sky-600 bg-gray-50">Experience</a>
        <a href="skills.html" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Skills</a>
        <a href="projects.html" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Projects</a>
        <a href="blog.html" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Blog</a>
        <a href="#contact" class="block py-4 px-6 text-base font-medium text-gray-700 hover:bg-gray-50">Contact</a>
    </div>
</header>
```

## Footer
Use this EXACT footer (same as index.html):

```html
<footer id="contact" class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-6 text-center max-w-4xl">
        <h2 class="text-3xl font-bold mb-6">Let's Connect</h2>
        <p class="mb-10 text-gray-300 text-lg">
            I am currently seeking opportunities to apply my expertise in clinical biostatistics and bioinformatics. I would love to connect and discuss how my skills can contribute to your team.
        </p>
        <div class="flex flex-wrap justify-center gap-4 mb-12">
            <a href="mailto:thejusmahajan@gmail.com"
                class="bg-sky-600 hover:bg-sky-500 text-white font-semibold py-3 px-8 rounded-lg shadow-sm transition-colors duration-300">
                Email Me
            </a>
            <a href="https://www.linkedin.com/in/thejusmahajan/" target="_blank" rel="noopener noreferrer"
                class="bg-gray-800 hover:bg-gray-700 border border-gray-700 text-white font-semibold py-3 px-8 rounded-lg transition-colors duration-300">
                LinkedIn
            </a>
            <a href="https://github.com/thejusmahajan" target="_blank" rel="noopener noreferrer"
                class="bg-gray-800 hover:bg-gray-700 border border-gray-700 text-white font-semibold py-3 px-8 rounded-lg transition-colors duration-300">
                GitHub
            </a>
            <a href="https://scholar.google.com/citations?hl=en&user=PJkZwAwAAAAJ" target="_blank" rel="noopener noreferrer"
                class="bg-gray-800 hover:bg-gray-700 border border-gray-700 text-white font-semibold py-3 px-8 rounded-lg transition-colors duration-300">
                Google Scholar
            </a>
        </div>
        <div class="border-t border-gray-800 pt-8">
            <p class="text-gray-500 text-sm">&copy; 2026 Thejus Mahajan. All Rights Reserved.</p>
        </div>
    </div>
</footer>
```

## Page Structure — What to Build

### Page Title
Use: `<title>Experience | Dr. Thejus Mahajan</title>`

### Section 1: Page Header
A simple centered heading at the top of the main content:
- **Title**: "Experience"
- **Subtitle**: "A deliberate career transition from computational physics to clinical bioinformatics"
- Use the same styling pattern as the hero section (large bold title, smaller gray subtitle below)

### Section 2: Professional Experience Timeline
Create a vertical timeline with a thin sky-600 line on the left side. Each entry is a card connected to the timeline. Show entries in reverse chronological order (most recent first).

**IMPORTANT RULES:**
- Do NOT fabricate metrics (no "improved by 30%", no "increased success rate by 15%"). Only use real, verifiable facts.
- Frame every role in terms of skills relevant to clinical bioinformatics/biostatistics.
- Downplay teaching/tutoring roles — keep them brief (2 lines max each, combined into one entry if possible).

Here are the EXACT entries to include, with the EXACT bullet points:

---

**Entry 1: Internship — Clinical Data Analysis & ML in R**
- Organization: HealthTwiSt GmbH, Berlin
- Period: February 2026 — April 2026
- Bullets:
  - Refactored a 1,834-line R data pipeline processing 143,000+ annual patient records from 300+ German radiology clinics (DeGIR registry)
  - Reduced codebase by 26.5% while maintaining byte-identical output, verified with R's identical() function
  - Extracted 257 hardcoded business rules into 8 configuration CSV files, enabling non-programmer rule editing
  - Created the degirtools R package (9 functions) with roxygen2 documentation
  - Built an interactive Shiny dashboard for clinical quality metrics visualization (plotly, DT, bslib)
  - Wrote Tidymodels teaching materials replacing legacy caret framework for ML workflows

---

**Entry 2: Further Training — Bioinformatics & Biostatistics**
- Organization: CQ Beratung + Bildung, Berlin
- Period: August 2025 — April 2026
- Bullets:
  - Intensive program covering Python, Bash scripting, SQL, and object-oriented programming
  - Bioinformatics: sequence analysis, structural bioinformatics, NGS analysis (Nextflow, Galaxy)
  - Biostatistics: ANOVA, PCA, hierarchical clustering, survival analysis using R/Bioconductor
  - Hands-on work with real and simulated clinical patient datasets

---

**Entry 3: Guest Scientist — Computational Biology & Ecosystem Modeling**
- Organization: Helmholtz-Zentrum Hereon, Geesthacht
- Period: May 2025 — October 2025
- Bullets:
  - Modeled evolutionary processes in marine ecosystems using computational simulation techniques
  - Continued collaboration on large-scale environmental data analysis

---

**Entry 4: Post-doctoral Scientist — Marine Ecosystem Modeling**
- Organization: University of Hamburg, Institute of Marine Ecosystem and Fisheries Sciences
- Period: August 2021 — January 2025
- Bullets:
  - Developed the Cyanobacteria Life Cycle (CLC) model within the ERGOM biogeochemical framework
  - Engineered simulation models in Fortran and analyzed large NetCDF datasets using Python
  - Performed statistical analysis and visualization of ecological time-series data using R and ggplot2
  - Managed multi-year hindcast and projection experiments on HPC clusters

---

**Entry 5: Ph.D. Researcher — Astrochemistry**
- Organization: Université Paris-Saclay, Institut des Sciences Moléculaires d'Orsay
- Period: October 2015 — September 2018
- Bullets:
  - Led particle collision experiments on a tandem accelerator, processing terabytes of experimental data
  - Developed signal processing algorithms in C++ for noise cancellation and data conversion
  - Built a molecular fragmentation model contributing to the KIDA astrochemistry database
  - Published 5 peer-reviewed papers in Journal of Physics B and Astronomy & Astrophysics

---

**Entry 6: Teaching & Mentoring** (combine the two teaching roles into ONE compact entry)
- Title: Physics Instructor & Mentor
- Organizations: Tutorwaves Solutions / Self-Employed, Kerala, India
- Period: February 2019 — March 2021
- Bullets (keep it SHORT — max 2 bullets):
  - Provided remote physics tutoring and exam preparation for graduate-level students
  - Coached chess at the competitive level, developing strategic problem-solving skills

---

### Section 3: Education
Below the experience timeline, add an "Education" section. Use 3 cards in a horizontal row (stacked on mobile).

- **Ph.D. in Astrochemistry** — Université Paris-Saclay, France (2015–2018)
- **M.Sc. in Physics** — National Institute of Technology Calicut, India (2012–2015) — CGPA: 8.2/10
- **B.Sc. in Physics** — University of Calicut, India (2009–2012)

### Section 4: Certifications & Training (NEW section)
Add a small section after Education with 2-3 certification cards:

- **Goethe-Zertifikat B1** — Goethe-Institut, July 2025
- **Leben in Deutschland Test** — Passed (German civic integration)
- **HPC Training** — Jülich Supercomputing Centre (JSC)
- **MITx 7.00x** — Introduction to Biology: The Secret of Life

Use a compact grid of small cards (4 columns on desktop, 2 on mobile). Keep these visually smaller than the experience entries.

## Important Notes
- Do NOT fabricate any metrics or percentages that aren't verifiable
- Do NOT include immigration/visa information
- Do NOT use the word "trainee" — this is a "further training program" or "intensive program"
- The teaching roles should take up minimal space — they're real but not the focus
- Frame the career narrative as: Physics PhD → Computational Modeling → Clinical Bioinformatics (deliberate, not accidental)
- The HealthTwiSt internship should be the MOST prominent entry since it's the most relevant to target roles

## Output Format
Output the **complete** `experience.html` file, ready to save. Include all HTML from `<!DOCTYPE html>` to `</html>`. Do not truncate or use placeholders like "...rest of the code". Every single line must be present in your output.
