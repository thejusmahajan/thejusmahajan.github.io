// To add a new blog post, copy an existing post object and paste it at the top of the array.
// Then, change the id, title, date, summary, and content.
// The content should be written as an HTML string.

const blogPosts = [
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
    },
    {
        id: 'placeholder-post',
        title: "Understanding BLAST: A Bioinformatician's First Tool",
        date: "October 15, 2025",
        summary: "A practical guide to the Basic Local Alignment Search Tool (BLAST). We'll cover the core concepts, different BLAST programs, and how to interpret the results.",
        content: `
            <h2>Introduction to BLAST</h2>
            <p>This is a placeholder for a future article about BLAST. Come back soon for more content!</p>
        `
    }
];
