package model;

public class DiscountCodes {
    private String code;
    private String discountType;
    private double discountValue;
    private String validFrom;
    private String validTo;
    private int usageLimit;
    private int timesUsed;

    public DiscountCodes(String code, String discountType, double discountValue, String validFrom, String validTo, int usageLimit, int timesUsed) {
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.usageLimit = usageLimit;
        this.timesUsed = timesUsed;
    }

    public String getCode() {
        return code;
    }

    public String getDiscountType() {
        return discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public String getValidFrom() {
        return validFrom;
    }

    public String getValidTo() {
        return validTo;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public int getTimesUsed() {
        return timesUsed;
    }
}