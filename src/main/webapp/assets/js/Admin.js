var elements = {
    navItems: document.querySelectorAll('.sidebar__nav-item'),
    sections: document.querySelectorAll('.main-content'),

};


function togglePopup(popup, show = true) {
    if (!popup) return;
    if (show) {
        popup.classList.remove('hidden');//xoa class hidden de hien thi
    } else {
        popup.classList.add('hidden');// them class hidden de an
    }
}

document.addEventListener("DOMContentLoaded", function () {
    initDeleteConfirmation();
    initUserEvents();      // Quản lý User
    initProductEvents();   // Quản lý Sản phẩm
    initInventoryEvents(); // Quản lý Kho hàng
    initOrderEvents();     // Quản lý Đơn hàng
    initVoucherEvents();   // Quản lý Voucher
    initSlideshowEvents(); // Quản lý Slideshow
    initCategoryEvents();  // Quản lý Category
    initSearchEvents(); // Tìm kiếm người dùng
    initSupplierEvents(); // Quản lý Nhà cung cấp
    initPagination();      // Phân trang bảng sản phẩm

    initNotificationEvent();   // Thông báo
    initInvoiceEvents();        // Quản lý Hóa đơn

});

function initDeleteConfirmation() {
    let formToDelete = null;
    const deletePopup = document.getElementById('confirmDeletePopup');
    if (!deletePopup) return;

    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
    const closeDeletePopup = document.getElementById('closeDeletePopup');

    document.addEventListener('click', function (e) {
        const deleteBtn = e.target.closest('[class*="delete-"]');
        if (deleteBtn && (deleteBtn.matches('.delete-user-btn') || deleteBtn.matches('.delete-product-btn') || deleteBtn.matches('.delete-category-btn') || deleteBtn.matches('.delete-voucher-btn') || deleteBtn.matches('.delete-slideshow-btn'))) {
            e.preventDefault();
            formToDelete = deleteBtn.closest('form');
            if (deletePopup) {
                togglePopup(deletePopup, true);
            }
        }
    });

    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener('click', () => {
            if (formToDelete) {
                formToDelete.submit();
            }
            togglePopup(deletePopup, false);
        });
    }

    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener('click', () => {
            togglePopup(deletePopup, false);
        });
    }

    if (closeDeletePopup) {
        closeDeletePopup.addEventListener('click', () => {
            togglePopup(deletePopup, false);
        });
    }

    deletePopup.addEventListener('click', (e) => {
        if (e.target.id === 'confirmDeletePopup') {
            togglePopup(deletePopup, false);
        }
    });
}

function initUserEvents() {
    document.addEventListener('click', function (e) {
        //edit user
        const editBtn = e.target.closest('.edit-user-btn');
        if (editBtn) {
            e.preventDefault();
            const userPopup = document.getElementById('popupUser');
            const userForm = document.getElementById('addUserForm');

            if (!userPopup || !userForm) return;

            const d = editBtn.dataset;

            document.getElementById('user-id').value = d.id;
            document.getElementById('user-name').value = d.name;
            document.getElementById('user-email').value = d.email;
            document.getElementById('user-phone').value = d.phone;

            const roleSelect = document.getElementById('user-role');
            if (roleSelect) {
                roleSelect.value = d.role || '3';
            }

            const activeSelect = document.getElementById('user-active');
            if (activeSelect) {
                activeSelect.value = (d.active === 'true' || d.active === '1') ? '1' : '0';
                activeSelect.closest('.form-group').style.display = 'block';
            }

            document.getElementById('user-action').value = 'update';
            const title = userPopup.querySelector('.form-title');
            const submitBtn = userPopup.querySelector('.btn-submit');
            if (title) title.textContent = "Cập Nhật Người Dùng";
            if (submitBtn) submitBtn.textContent = "Lưu Thay Đổi";

            togglePopup(userPopup, true);
        }

        //them nguoi dung moi
        const addBtn = e.target.closest('#btnAddUser');
        if (addBtn) {
            e.preventDefault();
            const userPopup = document.getElementById('popupUser');
            const userForm = document.getElementById('addUserForm');

            if (userPopup && userForm) {
                userForm.reset();
                document.getElementById('user-id').value = "";
                document.getElementById('user-action').value = "add";

                const roleSelect = document.getElementById('user-role');
                if(roleSelect) roleSelect.value = '3';

                const activeSelect = document.getElementById('user-active');
                if (activeSelect) {
                    activeSelect.closest('.form-group').style.display = 'none';
                }

                const title = userPopup.querySelector('.form-title');
                const submitBtn = userPopup.querySelector('.btn-submit');
                if (title) title.textContent = "Thêm Người Dùng";
                if (submitBtn) submitBtn.textContent = "+ Thêm Người dùng";

                togglePopup(userPopup, true);
            }
        }

        const closeBtn = e.target.closest('#closePopupUser');
        if (closeBtn) {
            const userPopup = document.getElementById('popupUser');
            togglePopup(userPopup, false);
        }
        //dong popup khi click ngoai popup
        if (e.target.id === 'popupUser') {
            togglePopup(e.target, false);
        }
    });
}

//product
function initProductEvents() {
    document.addEventListener('click', function (e) {
        const prodPopup = document.getElementById('popupOverlay');
        const btnAddProduct = e.target.closest('#btn-addproduct');
        const prodForm = document.getElementById('addProductForm');
        const closeBtn = e.target.closest('#closePopupProduct');
        const editProduct = e.target.closest('.prod-edit-btn');
        const fileInput = document.getElementById('prod-img');
        const preview = document.getElementById('img-preview');

        if (e.target === fileInput && fileInput.files[0]) {
            preview.src = URL.createObjectURL(fileInput.files[0]);
            preview.style.display = 'block';
        }

        //cap nhat san pham
        if (editProduct) {
            e.preventDefault();
            if (!prodForm || !prodPopup) return;
            const d = editProduct.dataset;

            document.getElementById('prod-id').value = d.id;
            document.getElementById('prod-name').value = d.name;
            document.getElementById('prod-category').value = d.cate;
            document.getElementById('prod-price').value = parseFloat(d.price);
            document.getElementById('prod-discount').value = parseFloat(d.discount);
            document.getElementById('prod-unit').value = d.unit;
            document.getElementById('prod-current-img').value = d.img;
            document.getElementById('prod-desc').value = d.desc;
            document.getElementById('prod-nutrition').value = d.nutrition || '';
            document.getElementById('prod-pDate').value = d.pdate;
            document.getElementById('prod-eDate').value = d.edate;

            const isActive = (d.active === 'true');
            const statusSelect = document.getElementById('prod-active');
            statusSelect.value = isActive ? "1" : "0";
            statusSelect.disabled = false;

            document.getElementById('prod-action').value = 'update';
            const title = document.querySelector('.product-form .form-title');
            const submitBtn = document.querySelector('.product-form .btn-submit');
            const imgUrl = d.img || '';
            document.getElementById('prod-current-img').value = imgUrl;

            if (imgUrl && imgUrl.startsWith('http')) {
                preview.src = imgUrl;
                preview.style.display = 'block';
            }
            fileInput.value = '';
            if (title) title.innerText = "Cập nhật Sản phẩm";
            if (submitBtn) submitBtn.innerText = "Lưu Thay Đổi";


            togglePopup(prodPopup, true);
        }
        //them san pham moi
        if (btnAddProduct) {
            e.preventDefault();
            if (prodForm && prodPopup) {
                prodForm.reset();
                document.getElementById('prod-action').value = 'add';
                document.getElementById('prod-id').value = '';
                const title = document.querySelector('.product-form .form-title');
                const submitBtn = document.querySelector('.product-form .btn-submit');

                if (title) title.innerText = "Thêm Sản Phẩm Mới";
                if (submitBtn) submitBtn.innerText = "Lưu Sản Phẩm";
                const statusSelect = document.getElementById('prod-active');
                statusSelect.value = "0";
                statusSelect.disabled = true;

                togglePopup(prodPopup, true);
            }

        }
        if (closeBtn || e.target.id === 'popupOverlay') {
            preview.style.display = 'none';
            preview.src = '';
            togglePopup(prodPopup, false);
        }
    });

}


//inventory
function initInventoryEvents() {
    document.addEventListener('click', function (e) {

        const invPopup = document.getElementById('popupInventory');
        const invPopupStatus = document.getElementById('popupInventoryStatus')
        const invForm = document.getElementById('form-inventory-add');
        const invFormStatus = document.getElementById('inventoryStatusUpdateForm')
        const invAddBtn = e.target.closest('#btn-open-add-inventory');
        const invCloseStatusBtn = e.target.closest('.close-popup')
        const editInvBtn = e.target.closest('.edit-inventory-btn');

        //edit inventory
        if (editInvBtn) {
            e.preventDefault();
            if (!invPopupStatus || !invFormStatus) return;

            const d = editInvBtn.dataset;

            document.getElementById('inv_status_id').value = d.id;
            document.getElementById('inv_status-action').value = 'update';

            togglePopup(invPopupStatus, true);
        }

        //add inventory

        if (invAddBtn) {
            e.preventDefault();
            if (invPopup && invForm) {
                if (invForm)
                    invForm.reset();
                document.getElementById('inv-id').value = '';
                document.getElementById('inv-action').value = 'add';

                togglePopup(invPopup, true);

            }
        }

        if (invCloseStatusBtn || e.target.id === 'popupInventory' || e.target.id === 'popupInventoryStatus') {
            togglePopup(invPopup, false);
            togglePopup(invPopupStatus, false);
        }


    });

}

//voucher
function initVoucherEvents() {
    document.querySelectorAll('.alert-message').forEach(alert => {
        setTimeout(() => {
            alert.style.transition = "opacity 0.5s ease";
            alert.style.opacity = "0";
            setTimeout(() => alert.style.display = "none", 500);
        }, 4000);
    });

    const today = new Date().toISOString().split('T')[0];
    const startDateInput = document.getElementById('start_date');
    const endDateInput = document.getElementById('end_date');
    const typeSelect = document.getElementById("type");
    const maxDiscountWrapper = document.getElementById("max_discount_wrapper");
    const maxOrderValue = document.getElementById("max_order_value");
    const valueInput = document.getElementById("value");
    const voucherPopup = document.getElementById('popupOverlayVoucher');
    const voucherForm = voucherPopup?.querySelector('.voucher-form');

    if (!voucherPopup || !voucherForm) return;

    const updateEndDateConstraint = () => {
        if (!startDateInput.value) return;
        endDateInput.min = startDateInput.value;
        if (endDateInput.value && endDateInput.value < startDateInput.value) {
            endDateInput.value = startDateInput.value;
        }
    };

    if (startDateInput && endDateInput) {
        startDateInput.addEventListener('change', updateEndDateConstraint);
        startDateInput.addEventListener('input', updateEndDateConstraint);
    }

    const togglePopup = (show = true) => {
        voucherPopup.classList.toggle('hidden', !show);
    };

    const toggleMaxDiscount = () => {
        if (!typeSelect || !maxDiscountWrapper) return;
        const isCash = typeSelect.value === "Tiền mặt";
        maxDiscountWrapper.style.display = isCash ? "none" : "block";
        if (isCash && maxOrderValue) maxOrderValue.value = "0";
        if (valueInput) valueInput.placeholder = isCash ? "VD: 50000" : "VD: 10 (tương đương 10%)";
    };

    if (typeSelect) typeSelect.addEventListener('change', toggleMaxDiscount);
    toggleMaxDiscount();

    voucherForm.addEventListener('submit', e => {
        const val = parseFloat(valueInput?.value) || 0;
        const minOrder = parseFloat(document.getElementById('min_order_value')?.value) || 0;
        const maxDiscount = parseFloat(maxOrderValue?.value) || 0;
        const sDate = startDateInput?.value;
        const eDate = endDateInput?.value;

        let error = "";
        if (sDate && eDate && eDate < sDate) error = "Ngày kết thúc không được nhỏ hơn ngày bắt đầu!";
        else if (val <= 0) error = "Mức giảm giá phải lớn hơn 0!";
        else if (minOrder < 0) error = "Giá trị đơn hàng tối thiểu không được âm!";
        else if (typeSelect?.value === "Phần trăm(%)") {
            if (val > 100) error = "Mức giảm phần trăm không được vượt quá 100%!";
            else if (maxDiscount < 0) error = "Giá trị giảm tối đa không được âm!";
        }

        if (error) {
            e.preventDefault();
            alert("Lỗi: " + error);
            if (error.includes("Ngày")) endDateInput?.focus();
        }
    });

    const fillForm = (d = {}) => {
        document.getElementById('voucher_id').value = d.id || '';
        document.getElementById('voucher_code').value = d.code || '';
        document.getElementById('title-voucher').value = d.title || '';
        document.getElementById('description-voucher').value = d.desc || '';
        if (typeSelect) typeSelect.value = d.type || 'Phần trăm(%)';
        if (valueInput) valueInput.value = d.value || '';
        if (maxOrderValue) maxOrderValue.value = d.max_discount || '0';
        document.getElementById('min_order_value').value = d.min_order || '0';
        document.getElementById('usage_limit').value = d.limit || '';
        document.getElementById('limit_per_user').value = d.user_limit || '1';
        document.getElementById('active').value = d.active || '1';
    };

    document.addEventListener('click', e => {
        const addBtn = e.target.closest('#btn-addvoucher');
        const editBtn = e.target.closest('.edit-voucher-btn');
        const closeBtn = e.target.closest('#closePopupVoucher');

        if (addBtn) {
            e.preventDefault();
            voucherForm.reset();
            fillForm();
            voucherPopup.querySelector('.form-title').textContent = 'Thêm mã giảm giá';
            document.getElementById('voucher_action').value = 'add';
            voucherPopup.querySelector('.btn-submit').textContent = 'Thêm mã giảm giá';

            if (startDateInput) {
                startDateInput.min = today;
                startDateInput.value = today;
            }
            if (endDateInput) endDateInput.min = today;

            toggleMaxDiscount();
            togglePopup(true);
        } else if (editBtn) {
            e.preventDefault();
            voucherForm.reset();
            voucherPopup.querySelector('.form-title').textContent = 'Cập nhật mã giảm giá';
            document.getElementById('voucher_action').value = 'update';
            voucherPopup.querySelector('.btn-submit').textContent = 'Lưu Thay Đổi';

            const d = editBtn.dataset;
            fillForm(d);

            if (startDateInput) {
                startDateInput.min = '';
                startDateInput.value = d.start;
            }
            if (endDateInput) {
                endDateInput.min = d.start;
                endDateInput.value = d.end;
            }

            toggleMaxDiscount();
            togglePopup(true);
        } else if (closeBtn || e.target.id === 'popupOverlayVoucher') {
            togglePopup(false);
        }
    });
}


function initSlideshowEvents() {
    document.addEventListener('click', function (e) {
        const slidePopup = document.getElementById('popupOverlayslideshow');
        if (!slidePopup) return;
        const closeBtn = e.target.closest('#closePopupslideshow');
        const slideForm = slidePopup.querySelector('#slideForm');
        const title = slidePopup.querySelector('.form-title');
        const submitBtn = slidePopup.querySelector('.btn-submit');
        const fileInput = document.getElementById('slide-img');
        const preview = document.getElementById('img-preview');
        if (e.target === fileInput && fileInput.files[0]) {
            preview.src = URL.createObjectURL(fileInput.files[0]);
            preview.style.display = 'block';
        }
        // Edit slideshow
        const editBtn = e.target.closest('.edit-slideshow-btn');
        if (editBtn) {
            e.preventDefault();
            if (!slideForm) return;

            const d = editBtn.dataset;
            document.getElementById('slide-id').value = d.id;
            const imgUrl = d.imageurl || '';
            document.getElementById('prod-current-img').value = imgUrl;
            fileInput.value = '';
            fileInput.removeAttribute('required');
            const preview = document.getElementById('img-preview');
            if (imgUrl && imgUrl.startsWith('http')) {
                preview.src = imgUrl;
                preview.style.display = 'block';
            } else {
                preview.removeAttribute('src');
                preview.style.display = 'none';
            }
            document.getElementById('slide-title').value = d.title;
            document.getElementById('slide-desc').value = d.description;
            document.getElementById('slide-order').value = d.displayorder;
            document.getElementById('slide-status').value = d.status;
            document.getElementById('slide-productId').value = d.productid;
            document.getElementById('slide-voucherCode').value = d.vouchercode;
            document.getElementById('slide-startDate').value = d.start_date;
            document.getElementById('slide-endDate').value = d.end_date;
            document.getElementById('slide_action').value = 'update';
            if (title) title.textContent = "Cập nhật Slideshow";
            if (submitBtn) submitBtn.textContent = "Lưu Thay Đổi";

            togglePopup(slidePopup, true);
        }

        // Add slideshow
        const addBtn = e.target.closest('#btn-addslideshow');
        if (addBtn) {
            e.preventDefault();
            if (!slideForm) return;

            slideForm.reset();
            document.getElementById('slide-id').value = "";
            document.getElementById('slide_action').value = 'add';
            fileInput.setAttribute('required', 'required');
            if (title) title.textContent = "Thêm Slideshow";
            if (submitBtn) submitBtn.textContent = "+ Thêm Slideshow";

            togglePopup(slidePopup, true);
        }

        // Close popup
        if (closeBtn || e.target.id === 'popupOverlayslideshow') {
            preview.style.display = 'none';
            preview.src = '';
            togglePopup(slidePopup, false);
        }
    });
}

//order
function initOrderEvents() {
    const orderPopup = document.getElementById('popupOrder');
    const orderForm = document.getElementById('orderUpdateForm');
    const closeBtn = document.getElementById('closePopupOrder');

    if (closeBtn && orderPopup) {
        closeBtn.addEventListener('click', () => togglePopup(orderPopup, false));
    }

    if (orderPopup) {
        orderPopup.addEventListener('click', (event) => {
            if (event.target === orderPopup) {
                togglePopup(orderPopup, false);
            }
        });
    }

    document.addEventListener('click', function (e) {
        const editBtn = e.target.closest('.edit-order-btn');
        if (editBtn && orderPopup) {
            e.preventDefault();
            if (!orderForm) return;

            const d = editBtn.dataset;
            document.getElementById('order_id').value = d.id;

            const statusSelect = document.getElementById('order_status');

            const validTransitions = {
                'Đang xử lý': ['Đang xử lý', 'Đang giao hàng', 'Đã hủy'],
                'Đang giao hàng': ['Đang giao hàng', 'Đã giao', 'Đã hủy'],
                'Đã giao': ['Đã giao'],
                'Đã hủy': ['Đã hủy']
            };

            const allowedStates = validTransitions[d.status] || [d.status];

            Array.from(statusSelect.options).forEach(opt => {
                if (!allowedStates.includes(opt.value)) {
                    opt.disabled = true;
                    opt.style.display = 'none';
                } else {
                    opt.disabled = false;
                    opt.style.display = 'block';
                }
            });

            statusSelect.value = d.status;
            document.getElementById('order-action').value = 'updateOrder';

            const title = orderPopup.querySelector('.form-title');
            const submitBtn = orderPopup.querySelector('.btn-submit');

            if (title) title.innerText = "Cập nhật Đơn hàng";
            if (submitBtn) {
                submitBtn.innerText = "Lưu Thay Đổi";
                submitBtn.disabled = (d.status === 'Đã giao' || d.status === 'Đã hủy');
                submitBtn.style.opacity = submitBtn.disabled ? "0.5" : "1";
            }

            togglePopup(orderPopup, true);
        }
    });
}

//category
function initCategoryEvents() {
    document.addEventListener('click', function (e) {
        const catPopup = document.getElementById('popupOverlaycategory');
        if (!catPopup) return;

        const catForm = catPopup.querySelector('.category-form');
        const modalTitle = document.getElementById('modalTitle');
        const actionInput = document.getElementById('cat_action');
        const catIdInput = document.getElementById('cat_id');
        const closeCateBtn = e.target.closest('#closePopupcategory');
        const fileInput = document.getElementById('category_url');
        const preview = document.getElementById('img-preview');
        if (e.target === fileInput && fileInput.files[0]) {
            preview.src = URL.createObjectURL(fileInput.files[0]);
            preview.style.display = 'block';
        }
        // Edit category
        const editBtn = e.target.closest('.edit-category-btn');
        if (editBtn) {
            e.preventDefault();
            if (!catForm) return;

            actionInput.value = "update";
            modalTitle.innerText = "Cập nhật Category";

            const d = editBtn.dataset;
            catIdInput.value = d.id;
            document.getElementById('category_name').value = d.name;
            document.getElementById('category_desc').value = d.desc;
            const imgUrl = d.url || '';
            document.getElementById('cate-current-img').value = imgUrl;
            fileInput.value = '';
            fileInput.removeAttribute('required');
            const preview = document.getElementById('img-preview');
            if (imgUrl && imgUrl.startsWith('http')) {
                preview.src = imgUrl;
                preview.style.display = 'block';
            } else {
                preview.removeAttribute('src');
                preview.style.display = 'none';
            }

            togglePopup(catPopup, true);
        }
        // Add category
        const addBtn = e.target.closest('#add-category-btn');
        if (addBtn) {
            e.preventDefault();
            if (!catForm) return;

            catForm.reset();
            actionInput.value = "add";
            modalTitle.innerText = "Thêm Category";
            catIdInput.value = "";

            togglePopup(catPopup, true);
        }

        // Close popup
        if (closeCateBtn || e.target.id === 'popupOverlaycategory') {
            preview.style.display = 'none';
            preview.src = '';
            togglePopup(catPopup, false);
        }
    });
}

function initPagination() {
    const tableBody = document.getElementById('productTableBody');
    const paginationControls = document.getElementById('paginationControls');
    const rowsPerPageSelect = document.getElementById('rowsPerPage');
    if (!paginationControls) return;
    const rows = Array.from(tableBody.querySelectorAll('.product-row'));
    let currentPage = 1;
    let rowsPerPage = parseInt(rowsPerPageSelect.value);

    function renderTable() {
        const start = rowsPerPage === -1 ? 0 : (currentPage - 1) * rowsPerPage;
        const end = rowsPerPage === -1 ? rows.length : start + rowsPerPage;

        rows.forEach((row, i) => row.style.display = i >= start && i < end ? "" : "none");

        paginationControls.innerHTML = "";
        if (rowsPerPage === -1 || rows.length <= rowsPerPage) return;

        const pageCount = Math.ceil(rows.length / rowsPerPage);
        const createBtn = (text, onClick, disabled = false) => {
            const btn = document.createElement('button');
            btn.className = 'pagination-btn' + (text == currentPage ? ' active' : '');
            btn.innerText = text;
            btn.disabled = disabled;
            btn.onclick = onClick;
            return paginationControls.appendChild(btn);
        };

        createBtn('<', () => {
            currentPage--;
            renderTable();
        }, currentPage === 1);
        for (let i = 1; i <= pageCount; i++)
            createBtn(i, () => {
                currentPage = i;
                renderTable();
            });
        createBtn('>', () => {
            currentPage++;
            renderTable();
        }, currentPage === pageCount);
    }

    rowsPerPageSelect.addEventListener('change', (e) => {
        rowsPerPage = parseInt(e.target.value);
        currentPage = 1;
        renderTable();
    });

    renderTable();


    //Search
    const search = [{inputId: 'search__user', btnId: 'btn-search-user', targetUrl: 'user'},
        {inputId: 'search__product', btnId: 'btn-search-product', targetUrl: 'product'},
        {inputId: 'search__category', btnId: 'btn-search-category', targetUrl: 'category'},
        {inputId: 'search__voucher', btnId: 'btn-search-voucher', targetUrl: 'voucher'},
        {inputId: 'search__slideshow', btnId: 'btn-search-slideshow', targetUrl: 'slideshow'},
        {inputId: 'search__order', btnId: 'btn-search-order', targetUrl: 'order'},
        {inputId: 'search__inventory', btnId: 'btn-search-inventory', targetUrl: 'inventory'},
        {inputId: 'search__supplier', btnId: 'btn-search-supplier', targetUrl: 'supplier'},
        {inputId: 'search__notification', btnId: 'btn-search-notification', targetUrl: 'notification'},
        {inputId: 'search__invoice', btnId: 'btn-search-invoice', targetUrl: 'invoices'}];

    search.forEach(s => initSearchEvents(s.inputId, s.btnId, s.targetUrl));
}

function initSearchEvents(inputId, btnId, targetUrl) {
    const searchInput = document.getElementById(inputId);
    const searchBtn = document.getElementById(btnId);
    if (!searchInput) return;

    function performSearch() {
        const keyword = searchInput.value.trim();
        const separator = targetUrl.includes('?') ? '&' : '?';
        window.location.href = `${targetUrl}${separator}search=${encodeURIComponent(keyword)}`;
    }

    if (searchBtn) {
        searchBtn.addEventListener('click', function (e) {
            e.preventDefault();
            performSearch();
        });
    }

    searchInput.addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            performSearch();
        }
    });
}

function initSupplierEvents() {
    document.addEventListener('click', function (e) {
        const supPopup = document.getElementById('popupSupplier');
        if (!supPopup) return;

        const supForm = supPopup.querySelector('#addSupplierForm');
        const title = supPopup.querySelector('.form-title');
        const submitBtn = supPopup.querySelector('.btn-submit');

        // Edit supplier
        const editBtn = e.target.closest('.edit-supplier-btn');
        if (editBtn) {
            e.preventDefault();
            if (!supForm) return;

            const d = editBtn.dataset;
            document.getElementById('supplier-id').value = d.id;
            document.getElementById('supplier-name').value = d.name;
            document.getElementById('supplier-phone').value = d.phone;
            document.getElementById('supplier-email').value = d.email;
            document.getElementById('supplier-address').value = d.address;

            document.getElementById('supplier-action').value = 'update';
            if (title) title.textContent = "Cập nhật Nhà cung cấp";
            if (submitBtn) submitBtn.textContent = "Lưu Thay Đổi";

            togglePopup(supPopup, true);
        }

        // Add supplier
        const addBtn = e.target.closest('#btnAddSupplier');
        if (addBtn) {
            e.preventDefault();
            if (!supForm) return;

            supForm.reset();
            document.getElementById('supplier-id').value = "";
            document.getElementById('supplier-action').value = 'add';

            if (title) title.textContent = "Thêm Nhà cung cấp";
            if (submitBtn) submitBtn.textContent = "+ Thêm Nhà cung cấp";

            togglePopup(supPopup, true);
        }

        // Close popup
        const closeBtn = e.target.closest('#closePopupSupplier');
        if (closeBtn) {
            togglePopup(supPopup, false);
        }

        if (e.target.id === 'popupSupplier') {
            togglePopup(e.target, false);
        }

    });

    function dateRangeValidation(formId, startInputId, endInputId) {
        const formObj = document.getElementById(formId);
        const startInput = document.getElementById(startInputId);
        const endInput = document.getElementById(endInputId);

        if (!formObj || !startInput || !endInput) return;

        startInput.addEventListener('change', function () {
            if (this.value) {
                endInput.min = this.value;
                if (endInput.value && endInput.value < this.value) {
                    endInput.value = '';
                }
            } else {
                endInput.removeAttribute('min');
            }
        });
        endInput.addEventListener('change', function () {
            if (this.value) {
                startInput.max = this.value;
                if (startInput.value && startInput.value > this.value) {
                    startInput.value = '';
                }
            } else {
                startInput.removeAttribute('max');
            }
        });

    }

    dateRangeValidation('slideForm', 'slide-startDate', 'slide-endDate');

}

//notification
function initNotificationEvent() {
    const notiPopupOverlay = document.getElementById('notiPopupOverlay');
    const popupAddNoti = document.getElementById('popupAddNoti');
    const popupViewNoti = document.getElementById('popupViewNoti');
    const selectTargetType = document.getElementById('noti-targetType');
    const targetIdWrapper = document.getElementById('targetIdWrapper');
    const inputTargetId = document.getElementById('noti-targetId');

    if (selectTargetType) {
        selectTargetType.addEventListener('change', function () {
            if (this.value === 'user') {
                togglePopup(targetIdWrapper, true);
                inputTargetId.setAttribute('required', 'true');
            } else {
                togglePopup(targetIdWrapper, false);
                inputTargetId.removeAttribute('required');
                inputTargetId.value = '';
            }
        });
    }

    document.addEventListener('click', function (e) {

        if (e.target.closest('#add-notification-btn')) {
            e.preventDefault();
            document.getElementById('addNotiForm').reset();
            togglePopup(targetIdWrapper, false);

            togglePopup(popupViewNoti, false);
            togglePopup(notiPopupOverlay, true);
            togglePopup(popupAddNoti, true);
        }

        if (e.target.closest('.view-notification-btn')) {
            e.preventDefault();
            const btn = e.target.closest('.view-notification-btn');
            const d = btn.dataset;

            document.getElementById('view-title').innerText = d.title;
            document.getElementById('view-date').innerText = d.createdAt.split('.')[0];
            document.getElementById('view-type').innerText = d.type;
            document.getElementById('view-targetType').innerText = d.targetType === 'all' ? 'Tất cả khách hàng' : `Khách hàng (ID: ${d.targetId})`;
            document.getElementById('view-content').innerText = d.content;

            togglePopup(popupAddNoti, false);
            togglePopup(notiPopupOverlay, true);
            togglePopup(popupViewNoti, true);
        }

        if (e.target.closest('.popup-close-btn') || e.target.id === 'notiPopupOverlay') {
            togglePopup(notiPopupOverlay, false);
            togglePopup(popupAddNoti, false);
            togglePopup(popupViewNoti, false);
        }
    });
}

function initInvoiceEvents() {
    document.addEventListener('click', function (e) {
        const invPopup = document.getElementById('invoicePopupOverlay');
        if (!invPopup) return;

        const viewBtn = e.target.closest('.view-invoice-btn');
        if (viewBtn) {
            e.preventDefault();

            const d = viewBtn.dataset;

            const popNumber = invPopup.querySelector('#pop-inv-number');
            const popCustomer = invPopup.querySelector('#pop-inv-customer');
            const popDate = invPopup.querySelector('#pop-inv-date');
            const popTotal = invPopup.querySelector('#pop-inv-total');
            const popStatus = invPopup.querySelector('#pop-inv-status');

            if (popNumber) popNumber.textContent = d.number;
            if (popCustomer) popCustomer.textContent = d.customer;
            if (popDate) popDate.textContent = d.date;
            if (popTotal) popTotal.textContent = d.total;
            if (popStatus) popStatus.textContent = d.status.toLocaleUpperCase();

            togglePopup(invPopup, true);
        }

        const closeBtn = e.target.closest('#closePopupInvoice') || e.target.closest('.close-btn-modal');
        if (closeBtn) {
            togglePopup(invPopup, false);
        }

        if (e.target.id === 'invoicePopupOverlay') {
            togglePopup(e.target, false);
        }
    });
}



