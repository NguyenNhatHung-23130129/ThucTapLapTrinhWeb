package vn.edu.hcmuaf.fit.doanweb.dao;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.hcmuaf.fit.doanweb.model.Category;

import java.util.List;

public class CategoryDao extends BaseDao {

    public List<Category> getListCategory() {

        return get().withHandle(handle -> handle.createQuery("SELECT * FROM categories ORDER BY id DESC")
                .mapToBean(Category.class)
                .list()
        );
    }
    public boolean hasProducts(int categoryId) {
        return get().withHandle(handle -> {
            int count = handle.createQuery("SELECT COUNT(*) FROM products WHERE category_id = :id")
                    .bind("id", categoryId)
                    .mapTo(Integer.class)
                    .one();
            return count > 0;
        });
    }

    public Category getCategoryById(int id) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM categories WHERE id = :id")
                .bind("id", id)
                .mapToBean(Category.class)
                .first()
        );
    }


    public void insert(Category category) {
        get().useHandle(handle -> {
            handle.createUpdate("INSERT INTO categories (name, description, image_url) VALUES (:name, :description, :imageUrl)")
                    .bind("name", category.getName())
                    .bind("description", category.getDescription())
                    .bind("imageUrl", category.getImageUrl())
                    .execute();
        });


    }

    public boolean delete(int id) {
        return get().withHandle(handle -> {
            Integer productCount = handle.createQuery("SELECT COUNT(*) FROM products WHERE category_id = :id")
                    .bind("id", id)
                    .mapTo(Integer.class)
                    .one();
            //con san pham trong category khong the xoa
            if (productCount != null && productCount > 0) {
                return false;
            }

            int rowsDeleted = handle.createUpdate("DELETE FROM categories WHERE id = :id")
                    .bind("id", id)
                    .execute();

            return rowsDeleted > 0;
        });
    }
    public void updateCategory(Category c) {
        get().useHandle(handle -> {
            handle.createUpdate("UPDATE categories SET name = :name, description = :description, image_url = :imageUrl WHERE id = :id")
                    .bind("name", c.getName())
                    .bind("description", c.getDescription())
                    .bind("imageUrl", c.getImageUrl())
                    .bind("id", c.getId())
                    .execute();
        });

    }

    public List<Category> searchCategories(String trim) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM categories WHERE name LIKE :trim ORDER BY id DESC")
                .bind("trim", "%" + trim + "%")
                .mapToBean(Category.class)
                .list()
        );
    }

//    public static void main(String[] args) {
//        CategoryDao dao = new CategoryDao();
//        Category c1 = new Category(0, "Rau củ quả", "Rau củ quả tươi sạch", "https://example.com/images/raucuqua.jpg");
//        Category c2 = new Category(0, "Trái cây", "Trái cây nhiệt đới", "https://example.com/images/traicay.jpg");
//        Category c3 = new Category(0, "Thịt cá", "Thịt cá tươi ngon", "https://example.com/images/thitca.jpg");
//        dao.insert(List.of(c1, c2, c3));
//    }
}
