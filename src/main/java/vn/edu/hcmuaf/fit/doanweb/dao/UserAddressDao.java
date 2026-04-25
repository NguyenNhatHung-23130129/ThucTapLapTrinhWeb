package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.UserAdderss;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import java.util.List;

public class UserAddressDao extends BaseDao{
    public UserAdderss getOneAddressByUserId(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM user_address WHERE user_id = :userId ORDER BY is_default DESC, id DESC LIMIT 1")
                        .bind("userId", userId)
                        .mapToBean(UserAdderss.class)
                        .findFirst()
                        .orElse(null)
        );
    }
    public int saveAddress(int userId, String address, String ward, String city) {
        return get().withHandle(handle -> {
            Integer currentAddressId = handle.createQuery("SELECT id FROM user_address WHERE user_id = :uid LIMIT 1")
                    .bind("uid", userId)
                    .mapTo(Integer.class)
                    .findOne()
                    .orElse(null);

            if (currentAddressId != null) {
                handle.createUpdate("UPDATE user_address SET address_line = :addr, ward = :ward, city = :city WHERE id = :id")
                        .bind("addr", address)
                        .bind("ward", ward)
                        .bind("city", city)
                        .bind("id", currentAddressId)
                        .execute();
                return currentAddressId;
            } else {
                return handle.createUpdate("INSERT INTO user_address (user_id, address_line, ward, city) VALUES (:uid, :addr, :ward, :city)")
                        .bind("uid", userId)
                        .bind("addr", address)
                        .bind("ward", ward)
                        .bind("city", city)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();
            }
        });
    }
    // Lấy tất cả địa chỉ của user theo userId
    public List<UserAdderss> getAllAddressesByUserId(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM user_address WHERE user_id = :userId")
                        .bind("userId", userId)
                        .mapToBean(UserAdderss.class)
                        .list()
        );
    }
    // Cập nhật thông tin user (name, phone)
    public void updateUserInfor(User u) {
        String sql = "UPDATE users SET name = :name, phone = :phone WHERE id = :id";

        this.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("name", u.getName())
                        .bind("phone", u.getPhone())
                        .bind("id", u.getId())
                        .execute()
        );
    }
    // Thêm địa chỉ mới cho user
    public int addAddress(int userId, String address, String ward, String city, String orderName, String orderPhone) {
        return get().withHandle(handle -> {
            int count = handle.createQuery("SELECT COUNT(*) FROM user_address WHERE user_id = :uid")
                    .bind("uid", userId)
                    .mapTo(Integer.class)
                    .one();
            int isDefault = (count == 0) ? 1 : 0;
            String sql = "INSERT INTO user_address (user_id, address_line, ward, city, is_default, order_name, order_sdt) VALUES (:uid, :addr, :ward, :city, :isDefault, :orderName, :orderPhone)";

            return handle.createUpdate(sql)
                    .bind("uid", userId)
                    .bind("addr", address)
                    .bind("ward", ward)
                    .bind("city", city)
                    .bind("isDefault", isDefault)
                    .bind("orderName", orderName)
                    .bind("orderPhone", orderPhone)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }


    // Xóa địa chỉ theo id
    public void deleteAddress(int id) {
        get().useHandle(handle ->
                handle.createUpdate("DELETE FROM user_address WHERE id = :id AND is_default = 0")
                        .bind("id", id)
                        .execute()
        );
    }
    // Cập nhật địa chỉ theo id
    public void updateAddress(int id, String address, String ward, String city) {
        get().useHandle(handle ->
                handle.createUpdate("UPDATE user_address SET address_line = :addr, ward = :ward, city = :city WHERE id = :id")
                        .bind("addr", address)
                        .bind("ward", ward)
                        .bind("city", city)
                        .bind("id", id)
                        .execute()
        );
    }


    public void setDefaultAddress(int userId, int addressId) {
        get().useTransaction(handle -> {
            handle.createUpdate("UPDATE user_address SET is_default = 0 WHERE user_id = :uid")
                    .bind("uid", userId)
                    .execute();
            handle.createUpdate("UPDATE user_address SET is_default = 1 WHERE id = :id AND user_id = :uid")
                    .bind("id", addressId)
                    .bind("uid", userId)
                    .execute();
        });
    }
    public UserAdderss getAddressById(int id) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM user_address WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(UserAdderss.class)
                        .findFirst()
                        .orElse(null)
        );
    }
}