document.addEventListener("DOMContentLoaded", function () {
    const UI = {
        imageFeature: document.querySelector('.image-feature'),
        listImages: document.querySelectorAll('.list-image img'),
        prev: document.querySelector('.prev'),
        next: document.querySelector('.next'),
        title: document.querySelector('.hero-title'),
        desc: document.querySelector('.hero-description')
    };

    const AUTO_SLIDE_DELAY = 4000;
    let currentIndex = 0;
    let slideInterval;

    function updateImage(index) {
        if (!UI.listImages.length || !UI.imageFeature) return;

        currentIndex = (index + UI.listImages.length) % UI.listImages.length;

        const img = UI.listImages[currentIndex];

        UI.imageFeature.src = img.src;
        UI.imageFeature.alt = img.alt;
        if (UI.title) UI.title.textContent = img.dataset.title || '';
        if (UI.desc) UI.desc.textContent = img.dataset.desc || '';

        resetAutoSlide();
    }

    function resetAutoSlide() {
        clearInterval(slideInterval);
        slideInterval = setInterval(() => {
            updateImage(currentIndex + 1);
        }, AUTO_SLIDE_DELAY);
    }

    UI.prev?.addEventListener('click', (e) => {
        e.preventDefault();
        updateImage(currentIndex - 1);
    });

    UI.next?.addEventListener('click', (e) => {
        e.preventDefault();
        updateImage(currentIndex + 1);
    });

    if (UI.listImages.length > 0) {
        resetAutoSlide();
    }

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

            products.forEach(item => {
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
document.addEventListener("DOMContentLoaded", function () {
    const notifList = document.getElementById('notifList');
    const notifCount = document.getElementById('notifCount');
    const notifWrapper = document.querySelector('.notif-wrapper');

    let isFetching = false;

    function fetchNotifications() {
        if (isFetching) return;
        isFetching = true;

        const apiUrl = window.contextPath + "/api/notifications";

        fetch(apiUrl)
            .then(response => {
                if (response.status === 401) throw new Error("unauthorized");
                if (!response.ok) throw new Error("error");
                return response.json();
            })
            .then(data => {
                if (data.unreadCount !== undefined) {
                    notifCount.innerText = data.unreadCount;
                }

                if (data.notifications && data.notifications.length > 0) {
                    notifList.innerHTML = data.notifications.map(n =>
                        `<li class="notif-item ${n.isRead ? '' : 'unread'}">
                            ${n.content}
                            <div style="font-size: 10px; color: #999; margin-top: 4px;">${n.createdAt}</div>
                        </li>`
                    ).join('');
                } else {
                    notifList.innerHTML = `<li class="notif-empty">Không có thông báo nào</li>`;
                }
            })
            .catch(error => {
                if (error.message === "unauthorized") {
                    notifList.innerHTML = `<li class="notif-empty">Vui lòng đăng nhập</li>`;
                } else {
                    notifList.innerHTML = `<li class="notif-empty">Lỗi tải dữ liệu</li>`;
                }
            })
            .finally(() => {
                isFetching = false;
            });
    }

    fetchNotifications();

    if (notifWrapper) {
        notifWrapper.addEventListener('mouseenter', fetchNotifications);
    }
});