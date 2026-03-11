// Language Switcher for Epidemica Website
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

    // Get the current page path and convert between EN/VN versions
    function getAlternateLanguagePath(currentLang) {
        const currentPath = window.location.pathname;
        
        if (currentLang === 'en') {
            // Switch to Vietnamese version
            return currentPath.replace('/index.html', '/index-vn.html').replace(/\/$/, '/index-vn.html');
        } else {
            // Switch to English version
            return currentPath.replace('/index-vn.html', '/index.html');
        }
    }

    // Create and inject the language switcher button
    function createLanguageSwitcher() {
        const currentPath = window.location.pathname;
        const isVietnamesePage = currentPath.includes('-vn.html');
        const displayLang = isVietnamesePage ? 'vn' : 'en';
        
        // Create button container
        const switcherDiv = document.createElement('div');
        switcherDiv.id = 'language-switcher';
        switcherDiv.className = 'language-switcher';
        
        // Create button
        const button = document.createElement('button');
        button.className = 'language-button';
        button.innerHTML = `
            <span class="lang-flag">${displayLang === 'en' ? '🇬🇧' : '🇻🇳'}</span>
            <span class="lang-text">${displayLang.toUpperCase()}</span>
            <span class="lang-arrow">▼</span>
        `;
        
        // Create dropdown menu
        const dropdown = document.createElement('div');
        dropdown.className = 'language-dropdown';
        dropdown.innerHTML = `
            <a href="#" class="lang-option" data-lang="en">
                <span class="lang-flag">🇬🇧</span>
                <span class="lang-text">English</span>
            </a>
            <a href="#" class="lang-option" data-lang="vn">
                <span class="lang-flag">🇻🇳</span>
                <span class="lang-text">Tiếng Việt</span>
            </a>
        `;
        
        switcherDiv.appendChild(button);
        switcherDiv.appendChild(dropdown);
        
        // Add to page
        document.body.appendChild(switcherDiv);
        
        // Toggle dropdown
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('show');
        });
        
        // Handle language selection
        dropdown.querySelectorAll('.lang-option').forEach(function(option) {
            option.addEventListener('click', function(e) {
                e.preventDefault();
                const selectedLang = this.getAttribute('data-lang');
                setLanguage(selectedLang);
                
                // Navigate to the appropriate page
                if (selectedLang !== displayLang) {
                    window.location.href = getAlternateLanguagePath(displayLang);
                }
            });
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function() {
            dropdown.classList.remove('show');
        });
    }

    // Initialize on page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            createLanguageSwitcher();
        });
    } else {
        createLanguageSwitcher();
    }
})();
