# Prompt 5: Revamp Blog Page + Final Polish (blog.html)

## Your Role
You are a senior frontend developer doing the final pass on Dr. Thejus Mahajan's personal website. You will rewrite `blog.html` to match the new design system, and ensure consistency across all pages.

## Context
- The website is hosted on GitHub Pages at https://thejusmahajan.github.io
- Tech stack: static HTML, Tailwind CSS (CDN), vanilla JavaScript, Google Fonts (Inter)
- The current blog page loads posts dynamically from `blog.js` using JavaScript in `js/main.js`. We will KEEP this system — it works and allows easy addition of new posts.
- Only modify `blog.html`. Do NOT modify `blog.js` or `js/main.js`.

## Design Constraints
- Use Tailwind CSS via CDN: `<script src="https://cdn.tailwindcss.com"></script>`
- Use Google Fonts Inter: already linked
- Color scheme: sky-600 as primary accent, gray-50 background, gray-800/900 for text
- Must be fully responsive (mobile-first)
- Do NOT use any JavaScript frameworks. Pure HTML + Tailwind.

## Header
Use the EXACT same header structure as other pages, with Blog highlighted (sky-600 font-semibold on blog.html link, sky-600 bg-gray-50 on mobile). Use the same format from pages 1-4.

## Footer
Use the EXACT same footer as all other pages (bg-gray-900, four buttons: Email, LinkedIn, GitHub, Google Scholar, 2026 copyright).

## Page Structure — What to Build

### Page Title
Use: `<title>Blog | Dr. Thejus Mahajan</title>`

### Section 1: Page Header
Centered heading:
- **Title**: "Blog & Technical Notes"
- **Subtitle**: "Notes on bioinformatics, biostatistics, and data science from my learning journey"

### Section 2: Blog Posts Container
The existing JavaScript in `js/main.js` dynamically creates blog post cards and inserts them into a container element. You need to provide the container that the JS expects.

Looking at the current blog.html, the JS looks for an element to populate with blog cards. Keep a `<div id="blog-posts-container">` (or whatever ID the current JS uses) with the same structure so the existing JavaScript continues to work.

Based on the current blog.html, the blog section uses:
```html
<div id="blog-posts" class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
    <!-- Posts are dynamically loaded here by main.js -->
</div>
```

Keep this exact ID (`blog-posts`) so `main.js` can find it. Update the Tailwind classes to match the new design:
```html
<div id="blog-posts" class="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-5xl mx-auto">
    <!-- Posts are dynamically loaded here by main.js -->
</div>
```

### Section 3: Blog Modal Container
The current blog system uses a modal to display full blog post content. Keep the modal container so the JS can use it:

```html
<!-- Blog Modal -->
<div id="blog-modal" class="fixed inset-0 z-50 hidden items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
    <div class="bg-white rounded-2xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto p-8 relative">
        <button id="close-blog-modal" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 text-2xl font-bold">&times;</button>
        <div id="blog-modal-content" class="prose max-w-none">
            <!-- Modal content populated by JS -->
        </div>
    </div>
</div>
```

### Section 4: Meta Tags for SEO
Add these meta tags to the `<head>` section:
```html
<meta name="description" content="Dr. Thejus Mahajan - Computational scientist specializing in clinical bioinformatics and biostatistics. Blog and technical notes on R, Python, NGS analysis, and data science.">
<meta name="keywords" content="bioinformatics, biostatistics, clinical data analysis, R, Python, NGS, data science, Hamburg">
<meta name="author" content="Dr. Thejus Mahajan">
```

## Important Notes
- The blog.js file and js/main.js file must NOT be modified. The blog page must work with the existing JavaScript that dynamically loads posts.
- Keep the same container IDs that main.js expects so blog functionality is preserved.
- The blog currently has 2 posts (SQL Order of Operations, Understanding BLAST). This is fine — the system allows easy addition of more posts later.
- Make sure the `<script src="blog.js"></script>` tag is included BEFORE `<script src="js/main.js"></script>` in the HTML (this is how the current page works — blog.js defines the data, main.js renders it).

## Output Format
Output the **complete** `blog.html` file, ready to save. Include all HTML from `<!DOCTYPE html>` to `</html>`. Do not truncate or use placeholders. Every single line must be present.
