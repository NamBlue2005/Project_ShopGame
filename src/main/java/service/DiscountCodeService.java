package service;

import model.DiscountCode;
import repository.IDiscountCodeRepository;
import repository.DiscountCodeRepository;

import java.util.List;

public class DiscountCodeService implements IDiscountCodeService {
    private final IDiscountCodeRepository repository = new DiscountCodeRepository();

    @Override
    public List<DiscountCode> getAllDiscountCodes() {
        return repository.findAll();
    }

    @Override
    public DiscountCode getDiscountCodeByCode(String code) {
        return repository.findByCode(code);
    }

    @Override
    public boolean createDiscountCode(DiscountCode discountCode) {
        return repository.addDiscountCode(discountCode);
    }

    @Override
    public boolean updateDiscountCode(DiscountCode discountCode) {
        return repository.updateDiscountCode(discountCode);
    }

    @Override
    public boolean removeDiscountCode(int discountId) {
        return repository.deleteDiscountCode(discountId);
    }
}