package vn.edu.hcmuaf.fit.doanweb.Admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.doanweb.dao.SlideShowDao;
import vn.edu.hcmuaf.fit.doanweb.model.SlideShow;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.services.PermissionService;
import vn.edu.hcmuaf.fit.doanweb.utils.CloudinaryUpload;
import vn.edu.hcmuaf.fit.doanweb.utils.ValidateDate;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminSlideShowManage", value = "/admin/slideshow")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class AdminSlideShowManage extends HttpServlet {
    SlideShowDao slideShowDao = new SlideShowDao();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {

        String search = request.getParameter("search");
        List<SlideShow> slideShows;
        if (search != null && !search.trim().isEmpty()) {
            slideShows = slideShowDao.searchSlideShows(search.trim());
        } else {
            slideShows = slideShowDao.getSlideShows();
        }
        request.setAttribute("searchKeyword", search);


        request.setAttribute("slideShowList", slideShows);
        request.setAttribute("activeTab", "slideshows");
        request.getRequestDispatcher("Admin.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";


        switch (action) {
            case "add":
                addSlideShow(request, response);
                break;
            case "delete":
                deleteSlideShow(request, response);
                break;
            case "update":
                updateSlideShow(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/slideshow");
        }


    }

    private SlideShow getSlideShowForm(HttpServletRequest request) {


        String imageUrl = (String) request.getAttribute("cloudinary_url");
        int displayOrder = Integer.parseInt(request.getParameter("displayOrder"));
        Date startDate = Date.valueOf(request.getParameter("startDate"));
        Date endDate = Date.valueOf(request.getParameter("endDate"));
        boolean status = "1".equals(request.getParameter("status"));
        SlideShow slideShow = new SlideShow();


        slideShow.setImageUrl(imageUrl);
        slideShow.setStatus(status);
        slideShow.setDisplayOrder(displayOrder);
        slideShow.setStartDate(startDate);
        slideShow.setEndDate(endDate);
//        slideShow.setProductId(productId);
//        slideShow.setVoucherCode(voucherCode);


        return slideShow;
    }

    private void addSlideShow(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String imagelUrl = CloudinaryUpload.handleUpload(request, "fileImage", "slideshows", "image_url");
        request.setAttribute("cloudinary_url", imagelUrl);
        SlideShow slideShow = getSlideShowForm(request);
        String errorMsg = ValidateDate.validateDateRange(slideShow.getStartDate(), slideShow.getEndDate(), "Lỗi: Ngày kết thúc phải lớn hơn ngày bắt đầu!");
        if (slideShowDao.checkDisplayOrderExists(slideShow.getDisplayOrder(), 0)) {
            errorMsg = "Thứ tự hiển thị số " + slideShow.getDisplayOrder() + " đã tồn tại! Vui lòng chọn số khác.";
        }
        if (errorMsg != null) {
            request.setAttribute("errorMessage", errorMsg);
            doGet(request, response);
            return;
        }
        slideShowDao.insertSlideShow(slideShow);
        response.sendRedirect(request.getContextPath() + "/admin/slideshow");
    }

    private void updateSlideShow(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String imagelUrl = CloudinaryUpload.handleUpload(request, "fileImage", "slideshows", "image_url");
        request.setAttribute("cloudinary_url", imagelUrl);
        SlideShow slideShow = getSlideShowForm(request);
        int id = Integer.parseInt(request.getParameter("id"));
        String errorMsg = ValidateDate.validateDateRange(slideShow.getStartDate(), slideShow.getEndDate(), "Lỗi: Ngày kết thúc phải lớn hơn ngày bắt đầu!");
        if (slideShowDao.checkDisplayOrderExists(slideShow.getDisplayOrder(), id)) {
            errorMsg = "Thứ tự hiển thị số " + slideShow.getDisplayOrder() + " đã tồn tại! Vui lòng chọn số khác.";
        }
        if (errorMsg != null) {
            request.setAttribute("errorMessage", errorMsg);
            doGet(request, response);
            return;
        }

        slideShow.setId(id);
        slideShowDao.updateSlideShow(slideShow);
        response.sendRedirect(request.getContextPath() + "/admin/slideshow");
    }

    private void deleteSlideShow(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        slideShowDao.deleteSlideShow(id);
        response.sendRedirect(request.getContextPath() + "/admin/slideshow");
    }


}