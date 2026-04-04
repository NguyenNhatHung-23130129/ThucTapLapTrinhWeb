document.addEventListener("DOMContentLoaded", function () {
    let imageFeature = document.querySelector('.image-feature');
    let listImages = document.querySelectorAll('.list-image img');
    let prevButton = document.querySelector('.prev');
    let nextButton = document.querySelector('.next');
    let heroTitle = document.querySelector('.hero-title');
    let heroDesc = document.querySelector('.hero-description');

    let currentIndex = 0;

    function updateImage(index) {
        if (!listImages || listImages.length === 0) return;
        if (index >= listImages.length) index = 0;
        if (index < 0) index = listImages.length - 1;
        currentIndex = index;

        const img = listImages[currentIndex];
        if (!imageFeature || !img) return;
        imageFeature.style.opacity = 0;
        if (heroTitle) heroTitle.style.opacity = 0;
        if (heroDesc) heroDesc.style.opacity = 0;

        imageFeature.src = img.src;
        imageFeature.alt = img.alt;
        if (heroTitle) heroTitle.textContent = img.dataset.title || '';
        if (heroDesc) heroDesc.textContent = img.dataset.desc || '';
        imageFeature.style.opacity = 1;
        if (heroTitle) heroTitle.style.opacity = 1;
        if (heroDesc) heroDesc.style.opacity = 1;

    }

    if (prevButton) prevButton.addEventListener('click', function (e) {
        e.preventDefault();
        updateImage(currentIndex - 1)
    });
    if (nextButton) nextButton.addEventListener('click', function (e) {
        e.preventDefault();
        updateImage(currentIndex + 1)
    });

//suggest search
    const input = document.getElementById("searchInput");
    const box = document.getElementById("suggestBox");
    const contextPath = window.contextPath || "";
    let debounceTimer = null;

    if (input && box) {

        function fetchSuggestions(keyword) {
            if (!keyword) {
                box.style.display = 'none';
                box.innerHTML = '';
                return;
            }

            fetch(contextPath + '/search-suggest?keyword=' + encodeURIComponent(keyword))
                .then(res => res.json())
                .then(data => renderSuggestions(data))
                .catch(err => console.error('Lỗi API Search:', err));
        }

        function renderSuggestions(products) {
            box.innerHTML = '';

            if (!products || products.length === 0) {
                box.innerHTML = '<div class="suggest-item suggest-noresult">Không có kết quả</div>';
                box.style.display = 'block';
                return;
            }

            products.slice(0, 10).forEach(item => {
                const div = document.createElement('div');
                div.className = 'suggest-item';

                let imgUrl = item.imageUrl || item.image || '';
                if (imgUrl && !imgUrl.startsWith('http')) {
                    imgUrl = contextPath + '/' + imgUrl.replace(/^\/+/, '');
                }
                if (!imgUrl) imgUrl = contextPath + '/assets/images/anchaylanhmanh.jpg';

                const flexContainer = document.createElement('div');
                flexContainer.style.cssText = "display:flex;align-items:center;gap:10px;";

                const img = document.createElement('img');
                img.src = imgUrl;
                img.onerror = function () {
                    this.src = contextPath + '/assets/images/anchaylanhmanh.jpg';
                };

                const spanName = document.createElement('span');
                spanName.style.cssText = "flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;";
                spanName.textContent = item.name || '';

                flexContainer.appendChild(img);
                flexContainer.appendChild(spanName);
                div.appendChild(flexContainer);

                div.onclick = function () {
                    input.value = item.name;
                    box.style.display = 'none';
                    window.location.href = contextPath + '/home?search=' + encodeURIComponent(item.name);
                };

                box.appendChild(div);
            });

            box.style.display = 'block';
        }

        input.addEventListener('input', function () {
            clearTimeout(debounceTimer);
            const keyword = this.value.trim();

            debounceTimer = setTimeout(() => {
                fetchSuggestions(keyword);
            }, 300);
        });

        document.addEventListener('click', function (e) {
            if (!e.target.closest('.header__search')) {
                box.style.display = 'none';
            }
        });

        input.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' || e.key === 'Escape') {
                box.style.display = 'none';
            }
        });
    }


});