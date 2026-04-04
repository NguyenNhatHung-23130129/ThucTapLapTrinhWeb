document.addEventListener("DOMContentLoaded", function() {
    const passwordInput = document.getElementById("password");
    const confirmPasswordInput = document.getElementById("password_confirm");
    const confirmPasswordError = document.getElementById("confirm-password-error");

    const reqLength = document.getElementById("req-length");
    const reqUpper = document.getElementById("req-upper");
    const reqLower = document.getElementById("req-lower");
    const reqNumber = document.getElementById("req-number");
    const reqSpecial = document.getElementById("req-special");
    const reqSpace = document.getElementById("req-space");

    if (!passwordInput || !confirmPasswordInput) return;

    // Kiem tra xem co khop hay khong
    function checkPasswordMatch() {
        if (confirmPasswordInput.value === "") {
            confirmPasswordInput.setCustomValidity("");
            if (confirmPasswordError) confirmPasswordError.style.display = "none";
        } else if (passwordInput.value !== confirmPasswordInput.value) {
            confirmPasswordInput.setCustomValidity("Bạn nhập lại chưa chính xác!");
            if (confirmPasswordError) confirmPasswordError.style.display = "block";
        } else {
            confirmPasswordInput.setCustomValidity("");
            if (confirmPasswordError) confirmPasswordError.style.display = "none";
        }
    }

    // Kiem tra dieu kien mat khau khi nguoi dung nhap
    passwordInput.addEventListener("input", function() {
        const val = passwordInput.value;
        checkPasswordMatch();

        if (val.length === 0) {
            if (reqLength) reqLength.classList.remove("valid");
            if (reqUpper) reqUpper.classList.remove("valid");
            if (reqLower) reqLower.classList.remove("valid");
            if (reqNumber) reqNumber.classList.remove("valid");
            if (reqSpecial) reqSpecial.classList.remove("valid");
            if (reqSpace) reqSpace.classList.remove("valid");
            return;
        }

        if (reqLength) reqLength.classList.toggle("valid", val.length >= 8 && val.length <= 16);
        if (reqUpper) reqUpper.classList.toggle("valid", /[A-Z]/.test(val));
        if (reqLower) reqLower.classList.toggle("valid", /[a-z]/.test(val));
        if (reqNumber) reqNumber.classList.toggle("valid", /[0-9]/.test(val));
        if (reqSpecial) reqSpecial.classList.toggle("valid", /[@#$%*?^&+=!._-]/.test(val));
        if (reqSpace) reqSpace.classList.toggle("valid", !/\s/.test(val));
    });

    confirmPasswordInput.addEventListener("input", checkPasswordMatch);

    // Xu ly su kien click vao icon de hien thi/ an mat khau
    const togglePasswordIcon = document.getElementById('toggle-password-icon');
    const toggleConfirmPasswordIcon = document.getElementById('toggle-confirm-password-icon');

    if (togglePasswordIcon) {
        togglePasswordIcon.addEventListener('click', function() {
            const isPasswordType = passwordInput.type === 'password';
            passwordInput.type = isPasswordType ? 'text' : 'password';
            togglePasswordIcon.className = isPasswordType ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
        });
    }

    if (toggleConfirmPasswordIcon) {
        toggleConfirmPasswordIcon.addEventListener('click', function() {
            const isPasswordType = confirmPasswordInput.type === 'password';
            confirmPasswordInput.type = isPasswordType ? 'text' : 'password';
            toggleConfirmPasswordIcon.className = isPasswordType ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
        });
    }
});