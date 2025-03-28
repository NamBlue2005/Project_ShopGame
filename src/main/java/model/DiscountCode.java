package model;

import java.sql.Date;

public class DiscountCode {

    private int discountId;
    private String code;
    private String discountType;
    private double discountValue; // double thay vì BigDecimal
    private Date validFrom;
    private Date validTo;
    private int usageLimit;
    private int timesUsed;

    public DiscountCode() {}

    public DiscountCode(String code, String discountType, double discountValue, Date validFrom,
                        Date validTo, int usageLimit, int timesUsed) {
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.usageLimit = usageLimit;
        this.timesUsed = timesUsed;
    }

    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getTimesUsed() {
        return timesUsed;
    }

    public void setTimesUsed(int timesUsed) {
        this.timesUsed = timesUsed;
    }


}