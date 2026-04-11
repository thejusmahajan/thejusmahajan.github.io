# Prompt 1: Revamp the Hero + About Page (index.html)

## Your Role
You are a senior frontend developer and UX writer. You will rewrite `index.html` for Dr. Thejus Mahajan's personal website. The goal is to make a recruiter in **clinical biostatistics or bioinformatics** immediately understand this person's value within 5 seconds of landing on the page.

## Context
- The website is hosted on GitHub Pages at https://thejusmahajan.github.io
- Tech stack: static HTML, Tailwind CSS (CDN), vanilla JavaScript, Google Fonts (Inter)
- The current page exists but is too generic. We need to make it recruiter-targeted.
- Keep the existing file structure. Only modify `index.html`.
- Keep the existing CSS file link (`css/style.css`) and JS file link (`js/main.js`).

## Design Constraints
- Use Tailwind CSS via CDN: `<script src="https://cdn.tailwindcss.com"></script>`
- Use Google Fonts Inter: already linked
- Color scheme: sky-600 as primary accent, gray-50 background, gray-800/900 for text
- Must be fully responsive (mobile-first)
- Keep the sticky header with backdrop blur
- Do NOT use any JavaScript frameworks. Pure HTML + Tailwind.
- Do NOT add any npm/build dependencies.

## Navigation (keep consistent across all pages)
The nav links should be: About (index.html), Experience (experience.html), Skills (skills.html), Projects (projects.html), Blog (blog.html), Contact (#contact)
Include both desktop nav and mobile hamburger menu (same as current structure).

## Page Structure — What to Build

### Section 1: Hero Section
Create a hero section with:
- **Headline**: "Dr. Thejus Mahajan"
- **Subtitle/tagline**: "Computational Scientist Transitioning to Clinical Bioinformatics & Biostatistics"
- **One-liner value proposition** (smaller text below subtitle): "PhD-level researcher with 10+ years in computational modeling, now trained in NGS analysis, applied biostatistics, and clinical data pipelines using R and Python."
- **Two CTA buttons side by side**:
  1. "View My Projects" → links to projects.html (sky-600 filled button)
  2. "Download CV" → links to a PDF (use href="assets/Thejus_Mahajan_CV.pdf" as placeholder, gray-700 outlined button)
- **Do NOT use a profile photo in the hero**. Keep it clean and text-focused.

### Section 2: Professional Summary (with photo)
Below the hero, create an "About Me" section with:
- Profile photo on the left (use `images/faceshot_tilted_01.png`), circular, with shadow
- On the right, a professional summary paragraph. Use this EXACT text:

> I am a computational scientist with a Ph.D. in Astrochemistry (Université Paris-Saclay) and 3.5 years of post-doctoral research in marine ecosystem modeling at the University of Hamburg. After building deep expertise in statistical modeling, large-scale data analysis (terabytes), and scientific computing with R, Python, Fortran, and C++, I made a deliberate career transition into clinical bioinformatics and biostatistics.
>
> I recently completed intensive training in bioinformatics and biostatistics (CQ Beratung + Bildung, Berlin), covering NGS analysis, sequence alignment, SQL, and applied biostatistics with clinical datasets. During my internship at HealthTwiSt GmbH, I refactored a medical data pipeline used by 300+ German radiology clinics and built an interactive Shiny dashboard for clinical quality metrics.
>
> I am now seeking a position in clinical biostatistics, bioinformatics, or health data science where I can apply my computational skills to research that directly impacts patient outcomes.

### Section 3: Key Highlights (quick-scan cards)
Create a row of 3-4 highlight cards that recruiters can scan in seconds. Use icons or emoji sparingly. Each card should have a bold metric/title and a one-line description.

Card 1: **5 Publications** — Peer-reviewed research in physics, astrochemistry, and ecology
Card 2: **300+ Clinics** — Refactored medical data pipeline serving the German DeGIR registry
Card 3: **10+ Years** — Experience in computational modeling and large-scale data analysis
Card 4: **R + Python** — Proficient in Bioconductor, Tidymodels, scikit-learn, Pandas, ggplot2

Use a grid layout: 2 columns on mobile, 4 columns on desktop. Cards should have white background, subtle shadow, rounded corners, and a sky-600 top border or accent.

### Section 4: Footer (Contact)
Keep the existing footer structure but update:
- Change copyright year to 2026
- Add Google Scholar link: https://scholar.google.com/citations?hl=en&user=PJkZwAwAAAAJ
- Keep email (thejusmahajan@gmail.com), LinkedIn (https://www.linkedin.com/in/thejusmahajan/), GitHub (https://github.com/thejusmahajan)
- The footer should have id="contact" so the nav link works

## Important Notes
- Do NOT include any immigration/visa information on the website
- Do NOT mention "trainee" — use "transitioning to" or "specializing in" instead
- Do NOT use phrases like "eager to learn" — use confident language like "applying expertise in"
- The tone should be confident, professional, and results-oriented
- Avoid buzzwords. Be specific with metrics and tools.

## Output Format
Output the **complete** `index.html` file, ready to save. Include all HTML from `<!DOCTYPE html>` to `</html>`. Do not truncate or use placeholders like "...rest of the code". Every line must be present.
