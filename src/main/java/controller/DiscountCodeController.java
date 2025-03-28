package controller;

import model.DiscountCode;
import service.IDiscountCodeService;
import service.DiscountCodeService;

import java.sql.Date;
import java.util.List;

public class DiscountCodeController {
    private final IDiscountCodeService service = new DiscountCodeService();

    public List<DiscountCode> getAllDiscountCodes() {
        return service.getAllDiscountCodes();
    }

    public DiscountCode getDiscountCode(String code) {
        return service.getDiscountCodeByCode(code);
    }

    public String createDiscountCode(String code, String discountType, double discountValue, Date validFrom, Date validTo, int usageLimit, int timesUsed) {
        DiscountCode discountCode = new DiscountCode(code, discountType, discountValue, validFrom, validTo, usageLimit, timesUsed);
        return service.createDiscountCode(discountCode) ? "Mã giảm giá đã được thêm thành công!" : "Thêm mã giảm giá thất bại!";
    }

    public String updateDiscountCode(int discountId, String code, String discountType, double discountValue, Date validFrom, Date validTo, int usageLimit, int timesUsed) {
        DiscountCode discountCode = new DiscountCode(code, discountType, discountValue, validFrom, validTo, usageLimit, timesUsed);
        discountCode.setDiscountId(discountId);
        return service.updateDiscountCode(discountCode) ? "Cập nhật mã giảm giá thành công!" : "Cập nhật mã giảm giá thất bại!";
    }

    public String deleteDiscountCode(int discountId) {
        return service.removeDiscountCode(discountId) ? "Xóa mã giảm giá thành công!" : "Xóa mã giảm giá thất bại!";
    }
}