# Website Revamp Master Plan
## Target: Clinical Biostatistics / Bioinformatics Recruiter

### Who is Dr. Thejus Mahajan?
- PhD in Astrochemistry (Université Paris-Saclay, 2015-2018) — particle accelerator experiments, C++, terabyte-scale data
- Post-doc in Marine Ecosystem Modelling (University of Hamburg, 2021-2025) — Fortran, Python, R, large-scale simulations
- Guest Scientist at Helmholtz-Zentrum Hereon (2025) — computational biology
- Further Training in Bioinformatics & Biostatistics (CQ Beratung + Bildung, 2025-2026) — NGS, SQL, Python, R/Bioconductor
- Internship at HealthTwiSt GmbH (Feb-Apr 2026) — refactored a medical data pipeline used by 300 German clinics, built Shiny dashboard, Tidymodels teaching
- 5 peer-reviewed publications
- Skills: Python, R (Bioconductor, Tidymodels, ggplot2), Fortran, SQL, Bash, C++
- German B1 (Goethe certified), English proficient, French intermediate
- Based in Hamburg, Germany

### Key Projects (for portfolio)
1. **DeGIR Pipeline Refactoring** — Refactored 1,834-line medical data pipeline for 300+ German radiology clinics (HealthTwiSt GmbH). Config extraction, deprecated function replacement, R package creation. Byte-identical output verification.
2. **DeGIR Dashboard** — Interactive Shiny app (R) visualizing interventional radiology quality metrics. Modular architecture (6 tabs), bilingual (DE/EN), plotly charts, benchmark comparisons. GitHub: thejusmahajan/degir-dashboard
3. **Tidymodels Teaching Script** — Teaching material replacing caret with tidymodels for ML workflows. GitHub: thejusmahajan/Introduction_to_Tidymodels
4. **Cyanobacteria Life Cycle Model** — Developed the CLC model within ERGOM framework. Fortran + Python + R for ecological time-series analysis.
5. **Simulacrum Cancer Data Analysis** — Biostatistical analysis of synthetic NHS cancer data (demographics, tumour sites, staging)
6. **Trees of Berlin** — Urban forestry data analysis for climate resilience
7. **PhD: Molecular Fragmentation Model** — C++ signal processing, particle collision experiments, KIDA database contributions

### Website Architecture (5 Sections)

| # | Section | File(s) | Focus |
|---|---------|---------|-------|
| 1 | Hero + About | index.html | Recruiter-first landing: headline, professional summary, CTA |
| 2 | Experience | experience.html | Timeline redesigned for clinical relevance, impact metrics |
| 3 | Skills | skills.html | Categorized for bioinformatics/biostatistics recruiters |
| 4 | Projects | projects.html + detail pages | Impact-driven project cards with metrics |
| 5 | Blog + Contact + Polish | blog.html, all pages | Professional footer, CV download link, SEO, consistency |

### Design Principles
- Keep Tailwind CSS (CDN) — it's working and lightweight
- Keep the existing sky-600 color scheme — clean and professional
- Single-page sections are fine; no need for SPA framework
- Mobile-responsive (already is, maintain this)
- NO frameworks, NO build tools — static HTML/CSS/JS only
- Recruiter should understand value proposition in <5 seconds
- Every section should answer: "Why hire this person for clinical bioinformatics?"

### Prompt Strategy
- One prompt per section
- Each prompt includes: exact content to use, design instructions, file paths, what to keep vs replace
- Prompts are self-contained so Gemini can execute without ambiguity
