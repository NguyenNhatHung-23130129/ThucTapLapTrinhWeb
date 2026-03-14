package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Voucher;

import java.util.List;

public class UserVoucherDao extends BaseDao {
    private static UserVoucherDao instance;

    public UserVoucherDao() {
        super();
    }

    public static UserVoucherDao getInstance() {
        if (instance == null) {
            instance = new UserVoucherDao();
        }
        return instance;
    }

    // Lưu voucher cho người dùng
    public boolean saveUserVoucher(int userId, String voucherCode) {
        if(checkUserHasVoucher(userId, voucherCode)) {
            return false;
        }

        String sql = "INSERT INTO user_vouchers (user_id, voucher_code, status, assigned_at) " +
                "VALUES (:userId, :voucherCode, 1, NOW())";

        int rows = this.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", userId)
                        .bind("voucherCode", voucherCode)
                        .execute()
        );
        return rows > 0;
    }

    // Kiểm tra người dùng đã có voucher chưa
    public boolean checkUserHasVoucher(int userId, String voucherCode) {
        String sql = "SELECT count(*) FROM user_vouchers WHERE user_id = ? AND voucher_code = ?";

        int count = this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, userId)
                        .bind(1, voucherCode)
                        .mapTo(Integer.class)
                        .one()
        );
        return count > 0;
    }

    // Lấy danh sách voucher của người dùng
    public List<Voucher> getVouchersByUserId(int userId) {
        String sql = "SELECT v.* " +
                "FROM vouchers v JOIN user_vouchers uv ON v.voucher_code = uv.voucher_code " +
                "WHERE uv.user_id = :userId AND uv.status = 1 " +
                "ORDER BY uv.assigned_at DESC";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }
    // Đánh dấu voucher đã được sử dụng
    public void markVoucherAsUsed(int userId, String voucherCode, int orderId) {
        String sql = "UPDATE user_vouchers " +
                "SET status = 0, used_at = NOW(), order_id = :orderId " +
                "WHERE user_id = :userId AND voucher_code = :voucherCode";

        this.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", userId)
                        .bind("voucherCode", voucherCode)
                        .bind("orderId", orderId)
                        .execute()
        );
    }
}