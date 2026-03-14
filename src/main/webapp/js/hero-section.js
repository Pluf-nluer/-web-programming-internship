




document.addEventListener('DOMContentLoaded', function() {
    
    const container = document.getElementById('categoriesContainer');
    const prevBtn = document.getElementById('prevButton');
    const nextBtn = document.getElementById('nextButton');
    const items = document.querySelectorAll('.category-item');

    if (!container || !prevBtn || !nextBtn || items.length === 0) return;

    
    const GAP = 40;

    


    function getScrollStep() {
        const itemWidth = items[0].offsetWidth;
        return itemWidth + GAP;
    }

    
    nextBtn.addEventListener('click', () => {
        const step = getScrollStep();
        container.scrollBy({
            left: step,
            behavior: 'smooth'
        });
    });

    
    prevBtn.addEventListener('click', () => {
        const step = getScrollStep();
        container.scrollBy({
            left: -step,
            behavior: 'smooth'
        });
    });

    
    function updateButtonState() {
        const tolerance = 5;
        const scrollLeft = container.scrollLeft;
        const maxScrollLeft = container.scrollWidth - container.clientWidth;

        
        if (scrollLeft <= tolerance) {
            prevBtn.disabled = true;
            prevBtn.style.opacity = '0.5';
        } else {
            prevBtn.disabled = false;
            prevBtn.style.opacity = '1';
        }

        
        if (scrollLeft >= maxScrollLeft - tolerance) {
            nextBtn.disabled = true;
            nextBtn.style.opacity = '0.5';
        } else {
            nextBtn.disabled = false;
            nextBtn.style.opacity = '1';
        }
    }

    
    container.addEventListener('scroll', updateButtonState);
    window.addEventListener('resize', updateButtonState);

    
    updateButtonState();

    
    items.forEach(item => {
        item.addEventListener('click', function() {
            const category = this.getAttribute('data-category');
            const contextPath = document.body.getAttribute('data-context-path') || '';

            if (category) {
                window.location.href = contextPath + '/products?category_id=' + category;
            } else {
                window.location.href = contextPath + '/products';
            }
        });

        item.style.cursor = 'pointer';
    });

    console.log('Hero Carousel initialized.');
});
