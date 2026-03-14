package vn.edu.hcmuaf.fit.doanweb.dao;

import vn.edu.hcmuaf.fit.doanweb.model.Voucher;

import java.util.List;

public class VoucherDao extends BaseDao {
    private static VoucherDao instance;

    public VoucherDao() {
        super();
    }

    public static VoucherDao getInstance() {
        if (instance == null) {
            instance = new VoucherDao();
        }
        return instance;
    }

    // Lấy tất cả voucher từ cơ sở dữ liệu
    public List<Voucher> getAvailableVouchers() {
        String sql = "SELECT " +
                "id, " +
                "voucher_code as voucherCode, " +
                "title, " +
                "description, " +
                "type, " +
                "apply_scope as applyScope, " +
                "value, " +
                "min_order_value as minOrderValue, " +
                "max_discount_amount as maxDiscountAmount, " +
                "start_date as startDate, " +
                "end_date as endDate, " +
                "usage_limit as usageLimit,  " +
                "usage_count as usageCount,  " +
                "limit_per_user as limitPerUser, " +
                "is_active as isActive " +
                "FROM vouchers " +
                "WHERE start_date <= NOW() AND end_date >= NOW() AND usage_limit > 0" +
                " ORDER BY end_date ASC";

        return this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    // Lấy danh sách tất cả voucher
    public List<Voucher> getAllVouchers() {
        String sql = "SELECT " +
                "id, " +
                "voucher_code as voucherCode, " +
                "title, " +
                "description, " +
                "type, " +
                "apply_scope as applyScope, " +
                "value, " +
                "min_order_value as minOrderValue, " +
                "max_discount_amount as maxDiscountAmount, " +
                "start_date as startDate, " +
                "end_date as endDate, " +
                "usage_limit as usageLimit, " +
                "usage_count as usageCount, " +
                "limit_per_user as limitPerUser, " +
                "is_active as isActive " +
                "FROM vouchers order by id desc";

        return this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    // Lấy danh sách voucher đã lưu của người dùng (giả sử lấy 2 cái mới nhất)
    public List<Voucher> getSavedVouchers() {
        String sql = "SELECT " +
                "id, " +
                "voucher_code as voucherCode, " +
                "title, " +
                "description, " +
                "type, " +
                "apply_scope as applyScope, " +
                "value, " +
                "min_order_value as minOrderValue, " +
                "max_discount_amount as maxDiscountAmount, " +
                "start_date as startDate, " +
                "end_date as endDate, " +
                "usage_limit as usageLimit, " +
                "usage_count as usageCount, " +
                "limit_per_user as limitPerUser, " +
                "is_active as isActive " +
                "FROM vouchers " +
                "ORDER BY start_date DESC LIMIT 2";


        return this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Voucher.class)
                        .list()
        );
    }

    public void updateVoucher(Voucher voucher) {
        get().useHandle(handle -> {
            handle.createUpdate("UPDATE vouchers SET voucher_code = :voucherCode, title = :title, description = :description, type = :type, apply_scope = :applyScope, value = :value, min_order_value = :minOrderValue, max_discount_amount = :maxDiscountAmount, start_date = :startDate, end_date = :endDate, usage_limit = :usageLimit, limit_per_user = :limitPerUser, is_active = :isActive WHERE id = :id")
                    .bind("voucherCode", voucher.getVoucherCode())
                    .bind("title", voucher.getTitle())
                    .bind("description", voucher.getDescription())
                    .bind("type", voucher.getType())
                    .bind("applyScope", voucher.getApplyScope())
                    .bind("value", voucher.getValue())
                    .bind("minOrderValue", voucher.getMinOrderValue())
                    .bind("maxDiscountAmount", voucher.getMaxDiscountAmount())
                    .bind("startDate", voucher.getStartDate())
                    .bind("endDate", voucher.getEndDate())
                    .bind("usageLimit", voucher.getUsageLimit())
                    .bind("limitPerUser", voucher.getLimitPerUser())
                    .bind("isActive", voucher.getIsActive())
                    .bind("id", voucher.getId())
                    .execute();
        });
    }
    public void insertVoucher(Voucher voucher) {
        get().useHandle(handle -> {
            handle.createUpdate("INSERT INTO vouchers (voucher_code, title, description, type, apply_scope, value, min_order_value, max_discount_amount, start_date, end_date, usage_limit, limit_per_user, is_active) " +
                            "VALUES (:voucherCode, :title, :description, :type, :applyScope, :value, :minOrderValue, :maxDiscountAmount, :startDate, :endDate, :usageLimit, :limitPerUser, :isActive)")
                    .bind("voucherCode", voucher.getVoucherCode())
                    .bind("title", voucher.getTitle())
                    .bind("description", voucher.getDescription())
                    .bind("type", voucher.getType())
                    .bind("applyScope", voucher.getApplyScope())
                    .bind("value", voucher.getValue())
                    .bind("minOrderValue", voucher.getMinOrderValue())
                    .bind("maxDiscountAmount", voucher.getMaxDiscountAmount())
                    .bind("startDate", voucher.getStartDate())
                    .bind("endDate", voucher.getEndDate())
                    .bind("usageLimit", voucher.getUsageLimit())
                    .bind("limitPerUser", voucher.getLimitPerUser())
                    .bind("isActive", voucher.getIsActive())
                    .execute();
        });
    }
    public void deleteVoucher(int id) {
        get().useHandle(handle -> {
            handle.createUpdate("Update vouchers set is_active = 0 WHERE id = :id")
                    .bind("id", id)
                    .execute();
        });
    }

    public List<Voucher> searchVouchers(String keyword) {
        
        String sql = "SELECT " +
                "id, " +
                "voucher_code as voucherCode, " +
                "title, " +
                "description, " +
                "type, " +
                "apply_scope as applyScope, " +
                "value, " +
                "min_order_value as minOrderValue, " +
                "max_discount_amount as maxDiscountAmount, " +
                "start_date as startDate, " +
                "end_date as endDate, " +
                "usage_limit as usageLimit, " +
                "usage_count as usageCount, " +
                "limit_per_user as limitPerUser, " +
                "is_active as isActive " +
                "FROM vouchers " +
                "WHERE voucher_code LIKE :keyword OR title LIKE :keyword " +
                "ORDER BY id DESC";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%")
                        .mapToBean(Voucher.class)
                        .list()
        );
    }
}