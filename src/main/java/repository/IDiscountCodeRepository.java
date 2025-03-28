package repository;

import model.DiscountCode;
import java.util.List;

public interface IDiscountCodeRepository {
    List<DiscountCode> findAll();
    DiscountCode findByCode(String code);
    boolean addDiscountCode(DiscountCode discountCode);
    boolean updateDiscountCode(DiscountCode discountCode);
    boolean deleteDiscountCode(int discountId);
}