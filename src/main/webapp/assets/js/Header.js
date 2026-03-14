document.addEventListener("DOMContentLoaded", function () {
    let imageFeature = document.querySelector('.image-feature');
    let listImages = document.querySelectorAll('.list-image img');
    let prevButton = document.querySelector('.prev');
    let nextButton = document.querySelector('.next');
    let heroTitle = document.querySelector('.hero-title');
    let heroDesc = document.querySelector('.hero-description');

    let currentIndex = 0;

    function updateImage(index) {
        if (index >= listImages.length) index = 0;
        if (index < 0) index = listImages.length - 1;
        currentIndex = index;

        const img = listImages[currentIndex];
        imageFeature.style.opacity = 0;
        heroTitle.style.opacity = 0;
        heroDesc.style.opacity = 0;

        imageFeature.src = img.src;
        imageFeature.alt = img.alt;
        heroTitle.textContent = img.dataset.title;
        heroDesc.textContent = img.dataset.desc;
        imageFeature.style.opacity = 1;
        heroTitle.style.opacity = 1;
        heroDesc.style.opacity = 1;

    }

    prevButton.addEventListener('click', function (e) {
        e.preventDefault();
        updateImage(currentIndex - 1)
    });
    nextButton.addEventListener('click', function (e) {
        e.preventDefault();
        updateImage(currentIndex + 1)
    });
});