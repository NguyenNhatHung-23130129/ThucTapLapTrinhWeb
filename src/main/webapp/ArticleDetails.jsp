
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết bài viết | Chay Tươi</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css"
        integrity="sha512-NhSC1YmyruXifcj/KFRWoC561YpHpc5Jtzgvbuzx5VozKpWvQ+4nXhPdFgmx8xqexRcpAglTj9sIBWINXa8x5w=="
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@500;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ArticleDetails.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Nav.css">
</head>
<body>
<%@ include file="Header.jsp"%>
  <nav class="breadcrumb">
    <a href="ArticleList.jsp">Tin tức</a>
    <span class="separator">›</span>
    <span class="current">Ra mắt combo cơm chay dinh dưỡng đóng hộp mới</span>
  </nav>


  <article class="article-detail">
    <header class="article-header">
      <h1 class="article-title">Ra mắt combo cơm chay dinh dưỡng đóng hộp mới</h1>

      <div class="article-meta">
                    <span class="meta-item">
                        <strong>Ngày đăng:</strong> 15/11/2024
                    </span>
        <span class="meta-item">
                        <strong>Danh mục:</strong> Sản phẩm mới
                    </span>
      </div>
    </header>

    <div class="article-featured-image">
      <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=1200&h=600&fit=crop" alt="Combo cơm chay dinh dưỡng">
    </div>

    <div class="article-content">
      <p class="lead-paragraph">
        Chay Tươi tự hào giới thiệu dòng sản phẩm combo cơm chay dinh dưỡng đóng hộp
        hoàn toàn mới, được chế biến từ nguyên liệu hữu cơ 100%, đảm bảo đầy đủ
        chất dinh dưỡng cho bữa ăn lành mạnh hàng ngày.
      </p>

      <h2>Đặc điểm nổi bật của sản phẩm</h2>
      <p>
        Combo cơm chay mới của chúng tôi được thiết kế dành riêng cho những người
        bận rộn nhưng vẫn muốn duy trì lối sống lành mạnh với chế độ ăn chay. Mỗi
        combo được đóng gói cẩn thận, bảo quản bằng công nghệ hiện đại, giữ trọn
        hương vị và dinh dưỡng.
      </p>

      <h3>1. Nguyên liệu hữu cơ 100%</h3>
      <p>
        Tất cả nguyên liệu đều được tuyển chọn từ các trang trại hữu cơ uy tín,
        không sử dụng hóa chất hay thuốc trừ sâu. Rau củ tươi ngon, đậu hữu cơ
        và các loại ngũ cốc nguyên hạt đảm bảo giá trị dinh dưỡng cao nhất.
      </p>

      <div class="article-image">
        <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&h=500&fit=crop" alt="Nguyên liệu hữu cơ">
        <p class="image-caption">Nguyên liệu hữu cơ tươi ngon được tuyển chọn kỹ lưỡng</p>
      </div>

      <h3>2. Không chất bảo quản</h3>
      <p>
        Chúng tôi áp dụng công nghệ đóng gói chân không hiện đại, giúp bảo quản
        sản phẩm lâu dài mà không cần sử dụng bất kỳ chất bảo quản nào. Điều này
        đảm bảo sức khỏe cho người tiêu dùng và giữ nguyên hương vị tự nhiên của
        món ăn.
      </p>

      <h3>3. Cân đối dinh dưỡng</h3>
      <p>
        Mỗi combo được thiết kế bởi chuyên gia dinh dưỡng, đảm bảo cân bằng giữa
        carbohydrate, protein thực vật, chất xơ, vitamin và khoáng chất. Một bữa
        ăn đầy đủ chỉ cần vài phút hâm nóng.
      </p>

      <div class="article-quote">
        <p>
          "Chúng tôi không chỉ tạo ra sản phẩm thực phẩm, mà còn mang đến giải pháp
          dinh dưỡng toàn diện cho lối sống bận rộn hiện đại."
        </p>
        <cite>- Đại diện Chay Tươi</cite>
      </div>

      <h2>Các combo nổi bật</h2>
      <p>
        Hiện tại, Chay Tươi cung cấp 5 combo cơm chay đa dạng:
      </p>

      <ul class="article-list">
        <li><strong>Combo Dinh Dưỡng Cơ Bản:</strong> Cơm gạo lứt, đậu hũ sốt nấm, rau xào hỗn hợp và canh rau.</li>
        <li><strong>Combo Protein Cao:</strong> Cơm gạo lứt, đậu đen nấu cà ri, tempeh nướng và salad.</li>
        <li><strong>Combo Giảm Cân:</strong> Cơm gạo lứt ít calo, rau củ hấp, đậu hủ luộc và soup rau.</li>
        <li><strong>Combo Năng Lượng:</strong> Cơm gạo lứt, đậu Hà Lan xào, nấm nướng và súp bí đỏ.</li>
        <li><strong>Combo Cao Cấp:</strong> Cơm gạo hữu cơ đặc biệt, nấm truffle, đậu hủ non và rau organic.</li>
      </ul>

      <div class="article-image">
        <img src="assest/images/combo-chay.jpg" alt="Các combo cơm chay">
        <p class="image-caption">Đa dạng combo cơm chay phù hợp với mọi nhu cầu</p>
      </div>

      <h2>Hướng dẫn sử dụng</h2>
      <p>
        Sản phẩm được đóng trong hộp an toàn, có thể bảo quản ở nhiệt độ phòng
        trong 6 tháng hoặc trong tủ lạnh lên đến 12 tháng. Khi sử dụng:
      </p>

      <ul class="article-list">
        <li>Mở nắp hộp ra</li>
        <li>Hâm nóng trong lò vi sóng 2-3 phút</li>
        <li>Hoặc đun nóng trên bếp 5-7 phút</li>
        <li>Thưởng thức ngay khi còn nóng</li>
      </ul>

      <h2>Ưu đãi đặc biệt ra mắt sản phẩm</h2>
      <p>
        Nhân dịp ra mắt sản phẩm mới, Chay Tươi có chương trình khuyến mãi hấp dẫn:
      </p>

      <ul class="article-list">
        <li>Giảm giá 25% cho đơn hàng đầu tiên</li>
        <li>Mua 5 tặng 1 khi đặt combo theo tuần</li>
        <li>Miễn phí vận chuyển cho đơn hàng trên 500.000đ</li>
        <li>Tặng thêm 1 hộp soup rau khi mua combo Cao Cấp</li>
      </ul>

      <div class="article-image">
        <img src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&h=500&fit=crop" alt="Ưu đãi đặc biệt">
        <p class="image-caption">Nhiều ưu đãi hấp dẫn đang chờ bạn</p>
      </div>

      <h2>Cam kết của Chay Tươi</h2>
      <p>
        Chúng tôi cam kết mang đến sản phẩm chất lượng cao nhất với:
      </p>

      <ul class="article-list">
        <li>Nguồn gốc nguyên liệu minh bạch, rõ ràng</li>
        <li>Quy trình sản xuất đạt chuẩn HACCP và ISO</li>
        <li>Kiểm tra chất lượng nghiêm ngặt trước khi xuất xưởng</li>
        <li>Chính sách đổi trả linh hoạt nếu không hài lòng</li>
        <li>Hỗ trợ tư vấn dinh dưỡng miễn phí</li>
      </ul>

      <h2>Kết luận</h2>
      <p>
        Combo cơm chay dinh dưỡng đóng hộp của Chay Tươi là giải pháp hoàn hảo
        cho những ai muốn duy trì lối sống lành mạnh nhưng không có nhiều thời
        gian nấu nướng. Với giá trị dinh dưỡng cao, hương vị thơm ngon và sự
        tiện lợi vượt trội, đây chắc chắn sẽ là lựa chọn yêu thích của bạn.
      </p>

      <p>
        Hãy truy cập website hoặc liên hệ hotline để đặt hàng ngay hôm nay và
        trải nghiệm sự khác biệt từ Chay Tươi!
      </p>
    </div>


    <div class="article-tags">
      <span class="tag-label">Từ khóa:</span>
      <a href="#" class="tag">Cơm chay</a>
      <a href="#" class="tag">Đồ ăn chay</a>
      <a href="#" class="tag">Sản phẩm mới</a>
      <a href="#" class="tag">Dinh dưỡng</a>
      <a href="#" class="tag">Hữu cơ</a>
    </div>

  </article>


  <section class="related-articles">
    <h2 class="section-title">Bài viết liên quan</h2>
    <div class="related-grid">
      <article class="related-item">
        <div class="related-image">
          <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=250&fit=crop" alt="Bài viết liên quan">
        </div>
        <div class="related-content">
          <h3><a href="#">Lợi ích của chế độ ăn chay với sức khỏe</a></h3>
          <p class="related-date">12/11/2024</p>
        </div>
      </article>

      <article class="related-item">
        <div class="related-image">
          <img src="assest/images/daulangdo.webp" alt="Bài viết liên quan">
        </div>
        <div class="related-content">
          <h3><a href="#">Hướng dẫn bảo quản thực phẩm chay đóng hộp</a></h3>
          <p class="related-date">08/11/2024</p>
        </div>
      </article>

      <article class="related-item">
        <div class="related-image">
          <img src="https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&h=250&fit=crop" alt="Bài viết liên quan">
        </div>
        <div class="related-content">
          <h3><a href="#">Top 5 món ăn chay được yêu thích nhất</a></h3>
          <p class="related-date">05/11/2024</p>
        </div>
      </article>
    </div>
  </section>


<script src="assets/js/Header.js"></script>

</body>
</html>