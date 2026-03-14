package vn.edu.hcmuaf.fit.doanweb.dao;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.hcmuaf.fit.doanweb.model.SlideShow;

import java.util.List;


public class SlideShowDao extends BaseDao{


    public SlideShow getSlideShowById(int id){
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM slideshows WHERE id = :id")
                .bind("id", id)
                .mapToBean(SlideShow.class)
                .first()
        );
    }
    public List<SlideShow> getSlideShows(){
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM slideshows order by display_order ASC")
                .mapToBean(SlideShow.class)
                .list()
        );
    }
    public List<SlideShow> getActiveSlideShows(){
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM slideshows WHERE status = 1 order by display_order ASC")
                .mapToBean(SlideShow.class)
                .list()
        );
    }


    public void insertSlideShow(SlideShow slideShow) {
        get().useHandle(handle -> {
            handle.createUpdate("INSERT INTO slideshows (title, description, image_url, display_order, start_date, end_date, status, product_id, voucher_code) " +
                            "VALUES (:title, :description, :imageUrl, :displayOrder, :startDate, :endDate, :status, :productId,:voucherCode)")
                    .bind("title", slideShow.getTitle())
                    .bind("description", slideShow.getDescription())
                    .bind("imageUrl", slideShow.getImageUrl())
                    .bind("displayOrder", slideShow.getDisplayOrder())
                    .bind("startDate", slideShow.getStartDate())
                    .bind("endDate", slideShow.getEndDate())
                    .bind("status", slideShow.isStatus())
                    .bind("productId",slideShow.getProductId())
                    .bind("voucherCode",slideShow.getVoucherCode())
                    .execute();
        });
    }

    public void updateSlideShow(SlideShow slideShow) {
        get().useHandle(handle -> {
            handle.createUpdate("UPDATE slideshows SET title = :title, description = :description, image_url = :imageUrl, product_id = :productId, voucher_code = :voucherCode, " +
                            "display_order = :displayOrder, start_date = :startDate, end_date = :endDate, status = :status " +
                            "WHERE id = :id")
                    .bind("title", slideShow.getTitle())
                    .bind("description", slideShow.getDescription())
                    .bind("imageUrl", slideShow.getImageUrl())
                    .bind("displayOrder", slideShow.getDisplayOrder())
                    .bind("startDate", slideShow.getStartDate())
                    .bind("endDate", slideShow.getEndDate())
                    .bind("status", slideShow.isStatus())
                    .bind("productId", slideShow.getProductId())
                    .bind("voucherCode", slideShow.getVoucherCode())
                    .bind("id", slideShow.getId())
                    .execute();
        });
    }

    public void deleteSlideShow(int id) {
        get().useHandle(handle -> {
            handle.createUpdate("Update slideshows SET status = 0 WHERE id = :id")
                    .bind("id", id)
                    .execute();
        });
    }
    public boolean checkDisplayOrderExists(int displayOrder,int currentId) {
        Integer count = get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM slideshows WHERE display_order = :displayOrder and status = 1 and id != :currentId")
                        .bind("displayOrder", displayOrder)
                        .bind("currentId", currentId)
                        .mapTo(Integer.class)
                        .first()
        );
        return count != null && count > 0;
    }

    public List<SlideShow> searchSlideShows(String trim) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM slideshows WHERE id LIKE :trim ORDER BY id DESC")
                .bind("trim", "%" + trim + "%")
                .mapToBean(SlideShow.class)
                .list()
        );
    }
}
