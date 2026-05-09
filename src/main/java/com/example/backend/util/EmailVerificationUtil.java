package com.example.backend.util;

import java.security.SecureRandom;

public class EmailVerificationUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    private EmailVerificationUtil() {
    }

    public static String generateCode() {
        return String.format("%06d", RANDOM.nextInt(1_000_000));
    }

    public static boolean isValidCode(String code) {
        return code != null && code.matches("[0-9]{4,6}");
    }
}
