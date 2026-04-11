# Prompt 4: Revamp the Projects Page (projects.html)

## Your Role
You are a senior frontend developer and portfolio strategist. You will rewrite `projects.html` for Dr. Thejus Mahajan's personal website. The goal is to showcase projects that demonstrate **direct relevance to clinical biostatistics and bioinformatics roles**, with the most impactful clinical project front and center.

## Context
- The website is hosted on GitHub Pages at https://thejusmahajan.github.io
- Tech stack: static HTML, Tailwind CSS (CDN), vanilla JavaScript, Google Fonts (Inter)
- The current projects page has 8 projects with equal visual weight, including toy projects (flashcards, Mendel's experiment) mixed with serious work. We need to prioritize by recruiter impact.
- Keep the existing file structure. Only modify `projects.html`.
- Keep the CSS file link (`css/style.css`) and JS file link (`js/main.js`).
- Do NOT load 3Dmol.js on this page (remove it — it was for the protein viewer modal which we won't use).

## Design Constraints
- Use Tailwind CSS via CDN: `<script src="https://cdn.tailwindcss.com"></script>`
- Use Google Fonts Inter: already linked
- Color scheme: sky-600 as primary accent, gray-50 background, gray-800/900 for text
- Must be fully responsive (mobile-first)
- Do NOT use any JavaScript frameworks. Pure HTML + Tailwind.
- Do NOT include modal-based interactive demos (protein folding, Mendel, flashcards). These are fun but distract from the professional portfolio narrative.

## Header
Use the EXACT same header structure as other pages, with Projects highlighted (sky-600 font-semibold). Include both desktop nav and mobile menu. Use the same format from the previous pages.

## Footer
Use the EXACT same footer as index.html/experience.html/skills.html (bg-gray-900, Google Scholar, 2026 copyright).

## Page Structure — What to Build

### Page Title
Use: `<title>Projects | Dr. Thejus Mahajan</title>`

### Section 1: Page Header
Centered heading:
- **Title**: "Projects"
- **Subtitle**: "Applied work in clinical data analysis, biostatistics, and computational modeling"

### Section 2: Featured Project (FULL-WIDTH, visually prominent)
Create ONE large featured project card that takes full width. This should be visually distinct from the grid below — larger, more detail, eye-catching.

**Featured Project: DeGIR Pipeline Refactoring & Dashboard**

Layout: Two-column on desktop (description left, metrics right), stacked on mobile.

Left side content:
- **Title**: "Medical Data Pipeline Refactoring"
- **Subtitle**: "HealthTwiSt GmbH | DeGIR Quality Registry"
- **Description** (use this EXACT text): "Led the refactoring of a critical R data pipeline serving Germany's interventional radiology quality registry (DeGIR). The system processes 143,000+ annual procedure records from 300+ hospitals, generating PDF quality reports for the DeGIR board. Reduced 1,834 lines of complex R code to 1,349 lines while maintaining byte-identical output. Built an interactive Shiny dashboard for clinical quality metrics visualization."
- **Tech tags** (as small pills): R, Shiny, plotly, tidyverse, devtools, roxygen2, Quarto
- **Links**:
  - "View Dashboard on GitHub" → https://github.com/thejusmahajan/degir-dashboard (sky-600 button)
  - "View Tidymodels Script" → https://github.com/thejusmahajan/Introduction_to_Tidymodels (gray outlined link)

Right side: A metrics panel showing key numbers in a 2x2 grid:
- **143,000+** — Patient records processed annually
- **300+** — German clinics served
- **26.5%** — Code reduction achieved
- **9** — Functions packaged (degirtools)

Style the featured card with: white background, rounded-2xl, larger shadow (shadow-lg), sky-600 top or left border (4px), generous padding (p-8 or p-10).

### Section 3: Other Projects Grid
Below the featured project, show the remaining projects in a 2-column grid on desktop, 1-column on mobile. Each project card should have:
- Title
- 1-2 sentence description
- Tech stack pills
- A link (if available)

Here are the projects to include, in this order:

**Project 2: Simulacrum Cancer Data Analysis**
- Description: "Biostatistical analysis of the Simulacrum v2.1.0 synthetic cancer dataset from England's National Disease Registration Service. Explored patient demographics, tumour site distributions, and staging patterns."
- Tech: R, ggplot2, dplyr, Biostatistics
- Link: "View Analysis" → simulacrum-analysis.html

**Project 3: Cyanobacteria Life Cycle Model**
- Description: "Developed a novel computational model for cyanobacteria population dynamics within the ERGOM biogeochemical framework. Performed multi-year hindcast simulations validated against observational data."
- Tech: Fortran, Python, R, GOTM-FABM, NetCDF, HPC
- Link: none (no public repo)

**Project 4: Molecular Fragmentation Model (PhD)**
- Description: "Built a molecular fragmentation model from particle accelerator collision data, contributing to the KIDA astrochemistry database. Processed terabytes of experimental data using C++ signal processing pipelines."
- Tech: C++, ROOT, Python, Monte Carlo methods
- Link: none

**Project 5: Trees of Berlin**
- Description: "Data analysis of tree plantings (2020–2025) in Berlin's Steglitz-Zehlendorf district, examining species diversity and climate resilience strategies."
- Tech: R, ggplot2, Data Visualization
- Link: "View Analysis" → trees-of-berlin.html

**Project 6: Tidymodels Teaching Script**
- Description: "Comprehensive teaching material for transitioning from caret to tidymodels in R. Covers the full ML pipeline: data splitting, preprocessing, model specification, tuning, and evaluation."
- Tech: R, Tidymodels, Quarto
- Link: "View on GitHub" → https://github.com/thejusmahajan/Introduction_to_Tidymodels

### Section 4: Publications
Add a small "Publications" section after the projects grid. Keep it compact.

**Title**: "Publications"
**Subtitle**: "5 peer-reviewed papers in physics and astrochemistry"

List the publications:
1. T. Mahajan, et al. *Journal of Physics: Conference Series*, 1412:142026, 2020.
2. T. Idbarkach, et al. *Astronomy & Astrophysics*, 628:A75, 2019.
3. T. Mahajan, et al. *Journal of Physics B*, 2019.
4. T. Idbarkach, et al. *Journal of Physics B*, 51(24):245201, 2018.
5. T. Idbarkach, et al. *Journal of Physics: Conference Series*, 1412(11):112028, 2020.

Add a link: "View all on Google Scholar" → https://scholar.google.com/citations?hl=en&user=PJkZwAwAAAAJ

Style this section simply — white card, compact text, not too prominent.

## Important Notes
- The DeGIR project is the STAR of this page — it should take 40% of the visual space above the fold
- Remove all toy/demo projects (flashcards, Mendel's experiment, protein folding modal) — they dilute the professional narrative
- Do NOT include any project images from the images/ folder for now — use clean text-based cards
- Every project description should be factual and verifiable — no exaggerations
- Tech pills should use the same sky-50/sky-700 style as the skills page biostatistics pills

## Output Format
Output the **complete** `projects.html` file, ready to save. Include all HTML from `<!DOCTYPE html>` to `</html>`. Do not truncate or use placeholders. Every single line must be present.
