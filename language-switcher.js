function applyTranslations(lang) {
    // Show/hide elements based on the selected language using CSS classes
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
