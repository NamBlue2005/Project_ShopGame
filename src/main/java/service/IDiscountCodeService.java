package service;

import model.DiscountCode;
import java.util.List;

public interface IDiscountCodeService {
    List<DiscountCode> getAllDiscountCodes();
    DiscountCode getDiscountCodeByCode(String code);
    boolean createDiscountCode(DiscountCode discountCode);
    boolean updateDiscountCode(DiscountCode discountCode);
    boolean removeDiscountCode(int discountId);
}