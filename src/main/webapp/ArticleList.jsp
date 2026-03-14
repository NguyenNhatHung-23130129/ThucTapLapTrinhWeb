
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tin tức | Chay Tươi</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
        integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@500;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ArticleList.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
</head>
<body>
<%@ include file="Header.jsp"%>
<div class="container">


  <div  class="news-list">

    <article class="news-item">
      <div class="news-content">
        <h2 class="news-title">
          <a href="ArticleDetails.jsp">Ra mắt combo chay dinh dưỡng đóng hộp mới</a>
        </h2>
        <p class="news-date">15/11/2024</p>
        <p class="news-excerpt">
          Chay Tươi tự hào giới thiệu dòng sản phẩm combo cơm chay dinh dưỡng
          đóng hộp tiện lợi, đảm bảo đầy đủ chất dinh dưỡng cho bữa ăn lành mạnh.
          Sản phẩm được chế biến từ nguyên liệu hữu cơ, không chất bảo quản...
        </p>
        <a href="ArticleDetails.jsp" class="read-more">Đọc thêm →</a>
      </div>
      <div class="news-image">
        <img src="assest/images/combo-chay.jpg" alt="Combo-chay">
      </div>
    </article>


    <article class="news-item">
      <div class="news-content">
        <h2 class="news-title">
          <a href="ArticleDetails.jsp">Lợi ích của chế độ ăn chay với sức khỏe</a>
        </h2>
        <p class="news-date">12/11/2024</p>
        <p class="news-excerpt">
          Nghiên cứu khoa học đã chứng minh chế độ ăn chay mang lại nhiều lợi ích
          cho sức khỏe như giảm nguy cơ bệnh tim mạch, ổn định huyết áp, kiểm soát
          cân nặng hiệu quả. Cùng tìm hiểu chi tiết hơn...
        </p>
        <a href="ArticleDetails.jsp" class="read-more">Đọc thêm →</a>
      </div>
      <div class="news-image">
        <img src="assest/images/anchaylanhmanh.jpg" alt="Đồ ăn chay lành mạnh">
      </div>
    </article>


    <article class="news-item">
      <div class="news-content">
        <h2 class="news-title">
          <a href="ArticleDetails.jsp">Hướng dẫn bảo quản thực phẩm chay đóng hộp</a>
        </h2>
        <p class="news-date">08/11/2024</p>
        <p class="news-excerpt">
          Để đảm bảo chất lượng và hương vị của thực phẩm chay đóng hộp, việc
          bảo quản đúng cách là vô cùng quan trọng. Bài viết sẽ chia sẻ những
          mẹo bảo quản hiệu quả nhất...
        </p>
        <a href="ArticleDetails.jsp" class="read-more">Đọc thêm →</a>
      </div>
      <div class="news-image">
        <img src="assest/images/do-chay-dong-hop-ngon.jpg" alt="Bảo quản thực phẩm">
      </div>
    </article>

    <article class="news-item">
      <div class="news-content">
        <h2 class="news-title">
          <a href="news-detail.html">Top 5 món ăn chay được yêu thích nhất</a>
        </h2>
        <p class="news-date">05/11/2024</p>
        <p class="news-excerpt">
          Khám phá 5 món ăn chay đóng hộp bán chạy nhất tại Chay Tươi.
          Từ cơm chiên chay đến bún bò chay, mỗi món đều mang hương vị
          đặc trưng và giá trị dinh dưỡng cao...
        </p>
        <a href="news-detail.html" class="read-more">Đọc thêm →</a>
      </div>
      <div class="news-image">
        <img src="assest/images/gaolut.webp" alt="Món ăn chay">
      </div>
    </article>




  </div>


  <div class="pagination">
    <a href="#" class="page-link active">1</a>
    <a href="#" class="page-link">2</a>
    <a href="#" class="page-link">3</a>
    <a href="#" class="page-link">→</a>
  </div>
</div>
<script src="assets/js/Header.js"></script>
</body>
</html>