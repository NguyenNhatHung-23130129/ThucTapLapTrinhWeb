package vn.edu.hcmuaf.fit.doanweb.utils;

import vn.edu.hcmuaf.fit.doanweb.model.SlideShow;

import java.sql.Date;

public class ValidateDate {
    private ValidateDate() {
        throw new UnsupportedOperationException("Utility class");
    }
    public static String validateDateRange(Date startDate, Date endDate, String errorMessage) {
        if (startDate != null && endDate != null) {
            if (endDate.before(startDate)) {
                return (errorMessage != null && !errorMessage.isEmpty()) ? errorMessage : "Lỗi: Ngày kết thúc phải lớn hơn ngày bắt đầu!";
            }
        }
        return null;
    }
}
