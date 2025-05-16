document.addEventListener('DOMContentLoaded', () => {
    /**
     * Mobile Navigation
     * Handles the mobile menu toggle functionality
     */
    const initMobileNav = () => {
        const menuToggle = document.querySelector('.menu-toggle');
        const navLinks = document.querySelector('.nav-links');
        
        if (!menuToggle || !navLinks) return;

        const toggleMenu = (event) => {
            const isExpanded = navLinks.classList.contains('active');
            navLinks.classList.toggle('active');
            menuToggle.setAttribute('aria-expanded', !isExpanded);
            
            const hamburgerIcon = menuToggle.querySelector('.hamburger-icon');
            if (hamburgerIcon) {
                hamburgerIcon.classList.toggle('active');
            }
        };

        const closeMenu = () => {
            navLinks.classList.remove('active');
            menuToggle.setAttribute('aria-expanded', 'false');
            const hamburgerIcon = menuToggle.querySelector('.hamburger-icon');
            if (hamburgerIcon) {
                hamburgerIcon.classList.remove('active');
            }
        };

        // Event Listeners
        menuToggle.addEventListener('click', toggleMenu);

        // Close menu when clicking outside
        document.addEventListener('click', (event) => {
            if (!event.target.closest('nav') && navLinks.classList.contains('active')) {
                closeMenu();
            }
        });

        // Handle escape key
        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape' && navLinks.classList.contains('active')) {
                closeMenu();
            }
        });
    };

    /**
     * Contact Form
     * Handles form validation and submission
     */
    const initContactForm = () => {
        const contactForm = document.querySelector('.contact-form');
        if (!contactForm) return;

        const formGroups = contactForm.querySelectorAll('.form-group');
        const formFeedback = document.getElementById('formFeedback');
        const submitButton = contactForm.querySelector('.submit-btn');

        const validators = {
            name: (value) => ({
                isValid: value.trim().length > 0,
                message: 'Please enter your name'
            }),
            email: (value) => ({
                isValid: /^\S+@\S+\.\S+$/.test(value.trim()),
                message: 'Please enter a valid email address'
            }),
            message: (value) => ({
                isValid: value.trim().length > 0,
                message: 'Please enter your message'
            })
        };

        const showError = (input, message) => {
            const errorElement = document.getElementById(`${input.id}Error`);
            if (!errorElement) return;
            
            input.classList.add('error');
            input.setAttribute('aria-invalid', 'true');
            errorElement.textContent = message;
            errorElement.classList.add('visible');
        };

        const clearError = (input) => {
            const errorElement = document.getElementById(`${input.id}Error`);
            if (!errorElement) return;
            
            input.classList.remove('error');
            input.setAttribute('aria-invalid', 'false');
            errorElement.textContent = '';
            errorElement.classList.remove('visible');
        };

        const validateField = (input) => {
            const validator = validators[input.id];
            if (!validator) return true;

            const result = validator(input.value);
            if (!result.isValid) {
                showError(input, result.message);
                return false;
            }
            
            clearError(input);
            return true;
        };

        const handleSubmit = async (event) => {
            event.preventDefault();
            let isValid = true;

            // Reset feedback
            formFeedback.textContent = '';
            formFeedback.className = 'form-feedback';

            // Validate all fields
            formGroups.forEach(group => {
                const input = group.querySelector('input, textarea');
                if (input && !validateField(input)) {
                    isValid = false;
                }
            });

            if (!isValid) return;

            // Prepare form data
            const formData = {
                name: contactForm.querySelector('#name').value.trim(),
                email: contactForm.querySelector('#email').value.trim(),
                message: contactForm.querySelector('#message').value.trim()
            };

            // Submit form
            submitButton.disabled = true;
            submitButton.textContent = 'Sending...';

            try {
                const response = await fetch('/api/contact', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(formData)
                });

                if (!response.ok) throw new Error('Server error');

                formFeedback.textContent = 'Thank you, your message has been sent!';
                formFeedback.classList.add('success');
                contactForm.reset();
            } catch (error) {
                formFeedback.textContent = 'Sorry, something went wrong. Please try again later.';
                formFeedback.classList.add('error');
            } finally {
                submitButton.disabled = false;
                submitButton.textContent = 'Send Message';
            }
        };

        // Event Listeners
        contactForm.addEventListener('submit', handleSubmit);

        // Real-time validation
        formGroups.forEach(group => {
            const input = group.querySelector('input, textarea');
            if (input) {
                input.addEventListener('blur', () => validateField(input));
            }
        });
    };

    /**
     * Project Gallery
     * Handles project filtering functionality
     */
    const initProjectGallery = () => {
        const filterButtons = document.querySelectorAll('.filter-btn');
        const projectCards = document.querySelectorAll('.project-card');
        
        if (!filterButtons.length || !projectCards.length) return;

        const updateProjects = (filterValue) => {
            projectCards.forEach(card => {
                const category = card.getAttribute('data-category');
                const shouldShow = filterValue === 'all' || category === filterValue;
                
                card.classList.toggle('hidden', !shouldShow);
                card.setAttribute('aria-hidden', !shouldShow);
            });

            // Announce filter change to screen readers
            const announcement = document.createElement('div');
            announcement.setAttribute('role', 'status');
            announcement.setAttribute('aria-live', 'polite');
            announcement.className = 'sr-only';
            announcement.textContent = `Showing ${filterValue} projects`;
            document.body.appendChild(announcement);
            
            setTimeout(() => announcement.remove(), 1000);
        };

        // Event Listeners
        filterButtons.forEach(button => {
            button.addEventListener('click', () => {
                const filterValue = button.getAttribute('data-filter');
                
                // Update active button state
                filterButtons.forEach(btn => {
                    const isActive = btn === button;
                    btn.classList.toggle('active', isActive);
                    btn.setAttribute('aria-pressed', isActive);
                });

                updateProjects(filterValue);
            });

            // Keyboard navigation
            button.addEventListener('keydown', (event) => {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    button.click();
                }
            });
        });
    };

    // Initialize all modules
    initMobileNav();
    initContactForm();
    initProjectGallery();
}); 