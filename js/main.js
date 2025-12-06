document.addEventListener('DOMContentLoaded', () => {
    // --- Blog Functionality ---
    const blogPostsContainer = document.getElementById('blog-posts-container');
    const blogModal = document.getElementById('blogModal');
    const blogModalTitle = document.getElementById('blogModalTitle');
    const blogModalBody = document.getElementById('blogModalBody');
    const closeBlogModalButton = document.getElementById('closeBlogModalButton');

    // 1. Populate blog post listings
    if (typeof blogPosts !== 'undefined' && blogPostsContainer) {
        // Display the most recent 6 posts
        const recentPosts = blogPosts.slice(0, 6);

        recentPosts.forEach(post => {
            const postElement = document.createElement('div');
            postElement.className = 'blog-card';
            postElement.innerHTML = `
                <div class="p-6">
                    <p class="text-sm text-gray-500 mb-2">${post.date}</p>
                    <h3 class="text-xl font-bold mb-3 text-gray-800">${post.title}</h3>
                    <p class="text-gray-600 mb-4">${post.summary}</p>
                    <button data-post-id="${post.id}" class="read-more-btn text-sky-600 font-semibold hover:underline">Read More &rarr;</button>
                </div>
            `;
            blogPostsContainer.appendChild(postElement);
        });
    }

    // 2. Handle clicks on "Read More" buttons
    if (blogPostsContainer) {
        blogPostsContainer.addEventListener('click', (event) => {
            if (event.target.classList.contains('read-more-btn')) {
                const postId = event.target.getAttribute('data-post-id');
                const post = blogPosts.find(p => p.id === postId);
                if (post) {
                    blogModalTitle.textContent = post.title;
                    blogModalBody.innerHTML = `<div class="blog-modal-content">${post.content}</div>`;
                    blogModal.classList.remove('hidden');
                }
            }
        });
    }

    // 3. Handle closing the blog modal
    const closeBlogModal = () => {
        if (blogModal) blogModal.classList.add('hidden');
    };

    if (closeBlogModalButton) {
        closeBlogModalButton.addEventListener('click', closeBlogModal);
    }
    if (blogModal) {
        blogModal.addEventListener('click', (event) => {
            if (event.target === blogModal) {
                closeBlogModal();
            }
        });
    }

    // --- Mobile Menu Toggle ---
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');

    if (mobileMenuButton && mobileMenu) {
        mobileMenuButton.addEventListener('click', () => {
            mobileMenu.classList.toggle('hidden');
        });
    }

    // --- Placeholder for App Logic ---
    // You would put your app-specific JS here or in separate files.
    // --- Flashcard App Logic ---
    const launchFlashcardButton = document.getElementById('launchFlashcardButton');
    const flashcardModal = document.getElementById('flashcardModal');

    if (launchFlashcardButton && flashcardModal) {

        // Sample Data
        const initialDeck = [
            { id: 1, question: "What is the command to initialize a new Git repository?", answer: "git init" },
            { id: 2, question: "How do you stage files for commit?", answer: "git add <filename> or git add ." },
            { id: 3, question: "What command saves your changes to the local repository?", answer: "git commit -m 'message'" },
            { id: 4, question: "How do you check the status of your working directory?", answer: "git status" },
            { id: 5, question: "What command lists the commit history?", answer: "git log" }
        ];

        let currentCardIndex = 0;
        let isFlipped = false;

        // Render the App Interface
        const renderFlashcardApp = () => {
            flashcardModal.innerHTML = `
                <div class="bg-white rounded-xl shadow-2xl w-full max-w-2xl overflow-hidden relative flex flex-col max-h-[90vh]">
                    <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                        <h3 class="text-2xl font-bold text-gray-800">Git-Spaced Flashcards</h3>
                        <button id="closeFlashcardModal" class="text-gray-400 hover:text-gray-600">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                        </button>
                    </div>
                    
                    <div class="p-8 flex-grow flex flex-col items-center justify-center bg-gray-50 flashcard-app">
                        <div class="w-full max-w-lg perspective-1000">
                            <div id="flashcard" class="card relative w-full h-64 bg-white rounded-xl shadow-lg cursor-pointer transition-transform duration-500 transform-style-3d">
                                <div class="card-face card-face-front absolute inset-0 flex items-center justify-center p-6 backface-hidden">
                                    <p class="text-xl font-medium text-center text-gray-800" id="cardQuestion">Question</p>
                                    <p class="absolute bottom-4 text-sm text-gray-400">Click to flip</p>
                                </div>
                                <div class="card-face card-face-back absolute inset-0 flex items-center justify-center p-6 backface-hidden rotate-y-180 bg-sky-50 rounded-xl">
                                    <p class="text-xl font-medium text-center text-sky-900" id="cardAnswer">Answer</p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-8 flex space-x-4 opacity-0 transition-opacity duration-300" id="ratingButtons">
                            <button class="quality-btn bg-red-100 text-red-600 px-4 py-2 rounded-lg font-semibold hover:bg-red-200 transition" data-quality="hard">Hard</button>
                            <button class="quality-btn bg-yellow-100 text-yellow-600 px-4 py-2 rounded-lg font-semibold hover:bg-yellow-200 transition" data-quality="good">Good</button>
                            <button class="quality-btn bg-green-100 text-green-600 px-4 py-2 rounded-lg font-semibold hover:bg-green-200 transition" data-quality="easy">Easy</button>
                        </div>
                        
                        <p class="mt-6 text-gray-500 text-sm">Card <span id="currentCardNum">1</span> of <span id="totalCards">5</span></p>
                    </div>
                </div>
            `;

            // Re-bind events for the newly created elements
            document.getElementById('closeFlashcardModal').addEventListener('click', closeApp);

            const cardElement = document.getElementById('flashcard');
            cardElement.addEventListener('click', () => {
                isFlipped = !isFlipped;
                cardElement.classList.toggle('is-flipped');

                const ratingButtons = document.getElementById('ratingButtons');
                if (isFlipped) {
                    ratingButtons.classList.remove('opacity-0');
                } else {
                    ratingButtons.classList.add('opacity-0');
                }
            });

            document.querySelectorAll('.quality-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.stopPropagation(); // Prevent card flip
                    handleRating(e.target.dataset.quality);
                });
            });

            showCard(currentCardIndex);
        };

        const showCard = (index) => {
            const card = initialDeck[index];
            document.getElementById('cardQuestion').textContent = card.question;
            document.getElementById('cardAnswer').textContent = card.answer;
            document.getElementById('currentCardNum').textContent = index + 1;
            document.getElementById('totalCards').textContent = initialDeck.length;

            // Reset state
            isFlipped = false;
            const cardElement = document.getElementById('flashcard');
            cardElement.classList.remove('is-flipped');
            document.getElementById('ratingButtons').classList.add('opacity-0');
        };

        const handleRating = (quality) => {
            // In a real app, we would calculate next review date here
            console.log(`Rated card ${currentCardIndex} as ${quality}`);

            // Move to next card
            currentCardIndex = (currentCardIndex + 1) % initialDeck.length;
            showCard(currentCardIndex);
        };

        const closeApp = () => {
            flashcardModal.classList.add('hidden');
            flashcardModal.innerHTML = ''; // Clean up
        };

        launchFlashcardButton.addEventListener('click', () => {
            flashcardModal.classList.remove('hidden');
            renderFlashcardApp();
        });
    }
});
