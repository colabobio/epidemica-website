// Language Switcher for Epidemica Main Website
(function() {
    'use strict';

    // Get current language from localStorage or default to 'en'
    function getCurrentLanguage() {
        return localStorage.getItem('epidemica-language') || 'en';
    }

    // Save language preference
    function setLanguage(lang) {
        localStorage.setItem('epidemica-language', lang);
    }

    // Apply translations to the page
    function applyTranslations(lang) {
        // Handle data-en/data-vn attributes
        const dataElements = document.querySelectorAll('[data-en], [data-vn]');
        dataElements.forEach(element => {
            if (lang === 'en' && element.hasAttribute('data-en')) {
                element.innerHTML = element.getAttribute('data-en');
            } else if (lang === 'vn' && element.hasAttribute('data-vn')) {
                element.innerHTML = element.getAttribute('data-vn');
            }
        });

        // Handle .lang-en and .lang-vn CSS classes
        const langEnElements = document.querySelectorAll('.lang-en');
        const langVnElements = document.querySelectorAll('.lang-vn');

        if (lang === 'en') {
            langEnElements.forEach(element => element.style.display = 'block');
            langVnElements.forEach(element => element.style.display = 'none');
        } else if (lang === 'vn') {
            langEnElements.forEach(element => element.style.display = 'none');
            langVnElements.forEach(element => element.style.display = 'block');
        }
    }

    // Create and inject the language switcher button
    function createLanguageSwitcher() {
        // Get stored language preference
        const storedLang = getCurrentLanguage();
        
        // Apply translations based on stored language
        applyTranslations(storedLang);
        
        // Create button container
        const switcherDiv = document.createElement('div');
        switcherDiv.id = 'language-switcher';
        switcherDiv.className = 'language-switcher';
        
        // Create button
        const button = document.createElement('button');
        button.className = 'language-button';
        button.setAttribute('aria-label', 'Select language');
        button.innerHTML = `
            <span class="lang-flag">${storedLang === 'en' ? '🇬🇧' : '🇻🇳'}</span>
            <span class="lang-text">${storedLang.toUpperCase()}</span>
            <span class="lang-arrow">▼</span>
        `;
        
        // Create dropdown menu
        const dropdown = document.createElement('div');
        dropdown.className = 'language-dropdown';
        dropdown.innerHTML = `
            <a href="#" class="lang-option ${storedLang === 'en' ? 'active' : ''}" data-lang="en">
                <span class="lang-flag">🇬🇧</span>
                <span class="lang-text">English</span>
            </a>
            <a href="#" class="lang-option ${storedLang === 'vn' ? 'active' : ''}" data-lang="vn">
                <span class="lang-flag">🇻🇳</span>
                <span class="lang-text">Tiếng Việt</span>
            </a>
        `;
        
        switcherDiv.appendChild(button);
        switcherDiv.appendChild(dropdown);
        
        // Add to header
        const header = document.querySelector('header');
        if (header) {
            header.appendChild(switcherDiv);
        } else {
            document.body.appendChild(switcherDiv);
        }
        
        // Toggle dropdown
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('show');
        });
        
        // Keyboard accessibility
        button.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                e.stopPropagation();
                dropdown.classList.toggle('show');
            } else if (e.key === 'Escape') {
                dropdown.classList.remove('show');
            }
        });
        
        // Handle language selection
        dropdown.querySelectorAll('.lang-option').forEach(function(option) {
            option.addEventListener('click', function(e) {
                e.preventDefault();
                const selectedLang = this.getAttribute('data-lang');
                
                // Save preference
                setLanguage(selectedLang);
                
                // Apply translations
                applyTranslations(selectedLang);
                
                // Update button display
                button.innerHTML = `
                    <span class="lang-flag">${selectedLang === 'en' ? '🇬🇧' : '🇻🇳'}</span>
                    <span class="lang-text">${selectedLang.toUpperCase()}</span>
                    <span class="lang-arrow">▼</span>
                `;
                
                // Update active state
                dropdown.querySelectorAll('.lang-option').forEach(opt => opt.classList.remove('active'));
                this.classList.add('active');
                
                // Close dropdown
                dropdown.classList.remove('show');
            });
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function() {
            dropdown.classList.remove('show');
        });
    }

    // Initialize on page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', createLanguageSwitcher);
    } else {
        createLanguageSwitcher();
    }
})();
