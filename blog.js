// To add a new blog post, copy an existing post object and paste it at the top of the array.
// Then, change the id, title, date, summary, and content.
// The content should be written as an HTML string.

const blogPosts = [
    {
        id: 'multi-omics-integration',
        title: "The Challenge of Multi-omics Integration: DOGMA-seq and mtscATAC-seq",
        date: "February 28, 2026",
        summary: "As my focus shifts heavily towards single-cell bioinformatics, I'm documenting the critical computational challenges of integrating distinct modalities (like chromatin accessibility and gene expression) from the same cell.",
        content: `
            <h2>The Promise of Single-Cell Multi-omics</h2>
            <p>Traditional bulk RNA-seq gives us an average signal across thousands of cells. Single-cell RNA-seq (scRNA-seq) solved this by profiling individual cells, allowing us to identify rare cell populations. However, to truly understand cellular regulation, we need more than just the transcriptome; we need to see the epigenome.</p>
            <p>This is where multi-omics shines. Technologies like <strong>mtscATAC-seq</strong> (mitochondrial single-cell ATAC-seq) and <strong>DOGMA-seq</strong> allow us to measure chromatin accessibility and gene expression simultaneously in the exact same cell.</p>
            
            <hr class="my-6">
            
            <h2>Computational Hurdles</h2>
            <p>The transition from single-modality to multi-modality data introduces massive computational complexity. Here are the primary challenges I'm currently studying to tackle these datasets:</p>
            
            <h3>1. Massive Dimensionality and Sparsity</h3>
            <p>ATAC-seq data is notoriously sparse (mostly zeros) because we are looking at binary states (open or closed) across hundreds of thousands of peaks across the genome. When combined with transcriptomic data, the feature space explodes. We rely heavily on advanced dimensionality reduction techniques (like LSI for ATAC, and PCA for RNA) before attempting integration.</p>
            
            <h3>2. Modality Integration (The "Anchor" Problem)</h3>
            <p>How do we link an ATAC peak (a regulatory region like an enhancer) to the specific gene it controls? Methods like Seurat's Weighted Nearest Neighbor (WNN) or MOFA+ (Multi-Omics Factor Analysis) are required to build a joint representation of the cell. You have to carefully weight each modality so that a noisy ATAC signal doesn't drown out a clean RNA signal, or vice versa.</p>
            
            <h3>3. Trajectory Inference</h3>
            <p>In cancer evolution or developmental biology, cells exist on a continuum. We want to draw "pseudotime" trajectories. Multi-omics allows us to see if chromatin changes <em>precede</em> transcriptional changes, establishing causality rather than just correlation.</p>
            
            <hr class="my-6">
            
            <h2>Moving Forward</h2>
            <p>The future of computational biology lies not just in generating this data, but in building the AI/ML infrastructures (like autoencoders and graph neural networks) necessary to parse these intertwined biological layers. My current training in Python object-oriented design and R/Bioconductor is strictly focused on mastering these integration workflows.</p>
        `
    },
    {
        id: 'nextflow-dsl2-refactoring',
        title: "Why Moving to Nextflow DSL2 is Mandatory for Clinical Pipelines",
        date: "February 12, 2026",
        summary: "Reflecting on my current pipeline engineering work: why transitioning legacy bash/R scripts into monolithic Nextflow workflows, and specifically utilizing DSL2 modules, is critical for reproducibility.",
        content: `
            <h2>The Fragility of Legacy Pipelines</h2>
            <p>In clinical bioinformatics, a pipeline that produces the "right answer" isn't enough. It must produce the right answer reproducibly, transparently, and robustly across different compute environments. Legacy pipelines—often a tangled web of Bash scripts, custom R scripts, and hardcoded variables—fail this test.</p>
            
            <hr class="my-6">
            
            <h2>The Nextflow Solution</h2>
            <p>Currently, I am heavily engaged in refactoring legacy data processing pipelines. <strong>Nextflow</strong> has been the absolute game-changer in this space, specifically due to the move to DSL2.</p>
            
            <h3>1. Modularity with DSL2</h3>
            <p>Before DSL2, Nextflow pipelines were often monolithic. DSL2 introduced true modularity. You can now define a process (e.g., a quality control step using fastp, or an alignment step using MAFFT) in its own standalone <code>.nf</code> file and import it into multiple different workflows. This mirrors the DRY (Don't Repeat Yourself) principles of standard software engineering.</p>
            
            <h3>2. Environment Encapsulation</h3>
            <p>A pipeline is only as reproducible as its environment. By combining Nextflow with Conda or Docker/Singularity, every single process runs in an isolated, perfectly defined environment. The days of "it works on my machine" are over. If my pipeline runs on a local workstation, it will run identically on an AWS Batch cluster.</p>
            
            <h3>3. Dataflow Programming</h3>
            <p>Nextflow's channel-based architecture means tasks execute the moment their input data is ready. You don't have to write complex loops or wait for an entire batch to finish before starting the next step. It inherently maximizes parallelization on HPC clusters without writing any complex threading code.</p>
            
            <hr class="my-6">
            
            <h2>Takeaway</h2>
            <p>When dealing with hundreds of thousands of clinical records (or gigabytes of NGS reads), pipeline failures are expensive in both time and compute. Investing in a robust, configuration-driven Nextflow architecture upfront prevents catastrophic debugging nightmares down the line.</p>
        `
    },
    {
        id: 'sql-order-of-operations',
        title: "The Definitive Guide to SQL's Order of Operations",
        date: "September 30, 2025",
        summary: "A common source of errors for SQL developers is assuming the database executes commands in the order they are written. This guide breaks down the logical processing order.",
        content: `
            <h2>Why Order Matters</h2>
            <p>One of the most common sources of errors and confusion for SQL developers is the assumption that the database executes commands in the order they are written. In reality, SQL follows a strict, logical order of operations to process a query. Understanding this sequence is the key to writing correct, efficient queries and debugging complex problems.</p>
            <p>This guide breaks down the logical processing order of the main clauses in a <code>SELECT</code> statement.</p>
            
            <hr class="my-6">

            <h2>The Logical Query Processing Order</h2>
            <ol class="list-decimal list-inside space-y-2 mb-4">
                <li><strong><code>FROM</code></strong> and <strong><code>JOIN</code></strong>s</li>
                <li><strong><code>WHERE</code></strong></li>
                <li><strong><code>GROUP BY</code></strong></li>
                <li><strong><code>HAVING</code></strong></li>
                <li><strong><code>SELECT</code></strong></li>
                <li><strong><code>DISTINCT</code></strong></li>
                <li><strong><code>ORDER BY</code></strong></li>
                <li><strong><code>LIMIT</code></strong> / <strong><code>OFFSET</code></strong></li>
            </ol>

            <hr class="my-6">
            
            <h3>Step 1: <code>FROM</code> and <code>JOIN</code>s</h3>
            <p>This is the absolute first step. The database identifies the source tables and performs any joins to assemble a massive, virtual table of all possible row combinations.</p>
            
            <h3>Step 2: <code>WHERE</code></h3>
            <p>The <code>WHERE</code> clause filters the individual rows from the virtual table created in the <code>FROM</code> step. This happens <strong>before</strong> any grouping or aggregation. This is why you cannot use aggregate functions like <code>SUM()</code>, <code>COUNT()</code>, or <code>MIN()</code> here.</p>
            <pre><code>-- This causes an error because MIN() hasn't been calculated yet.
SELECT *
FROM proteins
WHERE Mass = MIN(Mass);</code></pre>

            <h3>Step 3: <code>GROUP BY</code></h3>
            <p>This clause takes the filtered rows and organizes them into groups based on common values. After this step, the query is no longer dealing with individual rows but with these new groups.</p>
            
            <h3>Step 4: <code>HAVING</code></h3>
            <p>The <code>HAVING</code> clause filters the <strong>groups</strong> created by the <code>GROUP BY</code> clause. Because this step operates on groups, you <strong>can</strong> use aggregate functions here.</p>

            <h3>Step 5: <code>SELECT</code></h3>
            <p>Now that the data has been joined, filtered, and grouped, the <code>SELECT</code> clause finally computes the expressions and selects the columns that will be in the final output. Column aliases are created at this stage.</p>

            <h3>Step 6: <code>DISTINCT</code></h3>
            <p>If specified, this keyword is applied to remove any duplicate rows from the result.</p>
            
            <h3>Step 7: <code>ORDER BY</code></h3>
            <p>This clause sorts the final result set. Because it runs after <code>SELECT</code>, you can use column aliases here.</p>

            <h3>Step 8: <code>LIMIT / OFFSET</code></h3>
            <p>This is the very last step, restricting the number of rows returned, which is useful for pagination.</p>
            
            <hr class="my-6">

            <h3>Summary Cheat Sheet</h3>
            <table>
                <thead>
                    <tr><th>Order</th><th>Clause</th><th>Purpose</th><th>Can use Aggregates?</th><th>Can use SELECT Aliases?</th></tr>
                </thead>
                <tbody>
                    <tr><td>1</td><td><strong>FROM / JOIN</strong></td><td>Gathers and combines data.</td><td>No</td><td>No</td></tr>
                    <tr><td>2</td><td><strong>WHERE</strong></td><td>Filters individual rows.</td><td>No</td><td>No</td></tr>
                    <tr><td>3</td><td><strong>GROUP BY</strong></td><td>Aggregates rows into groups.</td><td>No</td><td>No</td></tr>
                    <tr><td>4</td><td><strong>HAVING</strong></td><td>Filters entire groups.</td><td><strong>Yes</strong></td><td>No</td></tr>
                    <tr><td>5</td><td><strong>SELECT</strong></td><td>Determines final columns.</td><td><strong>Yes</strong></td><td>(Aliases are created here)</td></tr>
                    <tr><td>6</td><td><strong>DISTINCT</strong></td><td>Removes duplicate rows.</td><td>N/A</td><td>Yes</td></tr>
                    <tr><td>7</td><td><strong>ORDER BY</strong></td><td>Sorts the final result.</td><td><strong>Yes</strong></td><td><strong>Yes</strong></td></tr>
                    <tr><td>8</td><td><strong>LIMIT / OFFSET</strong></td><td>Restricts rows returned.</td><td>N/A</td><td>Yes</td></tr>
                </tbody>
            </table>
        `
    }
];
