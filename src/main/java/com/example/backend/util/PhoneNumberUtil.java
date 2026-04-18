package com.example.backend.util;

public class PhoneNumberUtil {

    private static final String[] VALID_PREFIXES = {
            "032", "033", "034", "035", "036", "037", "038", "039",
            "052", "055", "056", "058", "059",
            "070", "076", "077", "078", "079",
            "081", "082", "083", "084", "085", "086", "087", "088", "089",
            "090", "091", "092", "093", "094",
            "096", "097", "098", "099"
    };

    private PhoneNumberUtil() {
    }

    public static String normalize(String phone) {
        if (phone == null) {
            return "";
        }

        StringBuilder digits = new StringBuilder();
        for (int i = 0; i < phone.length(); i++) {
            char currentChar = phone.charAt(i);
            if (Character.isDigit(currentChar)) {
                digits.append(currentChar);
            }
        }
        return digits.toString();
    }

    public static boolean isValidVietnamMobileNumber(String phone) {
        String normalizedPhone = normalize(phone);

        if (normalizedPhone.length() != 10 || normalizedPhone.charAt(0) != '0') {
            return false;
        }

        String prefix = normalizedPhone.substring(0, 3);
        for (String validPrefix : VALID_PREFIXES) {
            if (validPrefix.equals(prefix)) {
                return true;
            }
        }

        return false;
    }
}
