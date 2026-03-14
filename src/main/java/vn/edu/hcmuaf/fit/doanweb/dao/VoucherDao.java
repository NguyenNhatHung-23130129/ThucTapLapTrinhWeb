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

    public List<Voucher> getAvailableVouchers() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM vouchers WHERE start_date <= NOW() AND end_date >= NOW() AND usage_limit > 0 AND is_active = 1 ORDER BY end_date ASC")
                .mapToBean(Voucher.class)
                .list()
        );
    }


    public List<Voucher> getAllVouchers() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM vouchers ORDER BY id DESC")
                .mapToBean(Voucher.class)
                .list()
        );
    }

    public List<Voucher> getSavedVouchers() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM vouchers ORDER BY start_date DESC LIMIT 2")
                .mapToBean(Voucher.class)
                .list()
        );
    }

    public void updateVoucher(Voucher voucher) {
        get().useHandle(handle -> handle.createUpdate("UPDATE vouchers SET voucher_code = :voucherCode, title = :title, description = :description, type = :type, apply_scope = :applyScope, value = :value, min_order_value = :minOrderValue, max_discount_amount = :maxDiscountAmount, start_date = :startDate, end_date = :endDate, usage_limit = :usageLimit, limit_per_user = :limitPerUser, is_active = :isActive WHERE id = :id")
                .bindBean(voucher)
                .execute()
        );
    }

    public void insertVoucher(Voucher voucher) {
        get().useHandle(handle -> handle.createUpdate("INSERT INTO vouchers (voucher_code, title, description, type, apply_scope, value, min_order_value, max_discount_amount, start_date, end_date, usage_limit, limit_per_user, is_active) VALUES (:voucherCode, :title, :description, :type, :applyScope, :value, :minOrderValue, :maxDiscountAmount, :startDate, :endDate, :usageLimit, :limitPerUser, :isActive)")
                .bindBean(voucher)
                .execute()
        );
    }

    public void deleteVoucher(int id) {
        get().useHandle(handle -> handle.createUpdate("UPDATE vouchers SET is_active = 0 WHERE id = :id")
                .bind("id", id)
                .execute()
        );
    }

    public List<Voucher> searchVouchers(String keyword) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM vouchers WHERE voucher_code LIKE :keyword OR title LIKE :keyword ORDER BY id DESC")
                .bind("keyword", "%" + keyword + "%")
                .mapToBean(Voucher.class)
                .list()
        );
    }
}