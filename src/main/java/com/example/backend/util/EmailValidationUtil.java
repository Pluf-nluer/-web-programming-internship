package com.example.backend.util;

public class EmailValidationUtil {

    private static final String[] BLOCKED_DOMAINS = {
            "example.com", "example.org", "example.net",
            "test.com", "test.org", "test.net"
    };

    private EmailValidationUtil() {
    }

    public static String normalize(String email) {
        if (email == null) {
            return "";
        }
        return email.trim().toLowerCase();
    }

    public static boolean isValidEmail(String email) {
        String normalizedEmail = normalize(email);

        if (normalizedEmail.isEmpty() || !normalizedEmail.matches("^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)+$")) {
            return false;
        }

        String[] parts = normalizedEmail.split("@");
        if (parts.length != 2) {
            return false;
        }

        String localPart = parts[0];
        String domain = parts[1];

        if (localPart.startsWith(".") || localPart.endsWith(".") || localPart.contains("..")) {
            return false;
        }

        if (isOnlyDigits(localPart)) {
            return false;
        }

        if (isBlockedDomain(domain)) {
            return false;
        }

        return !domain.contains("..");
    }

    private static boolean isOnlyDigits(String value) {
        for (int i = 0; i < value.length(); i++) {
            if (!Character.isDigit(value.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    private static boolean isBlockedDomain(String domain) {
        for (String blockedDomain : BLOCKED_DOMAINS) {
            if (blockedDomain.equals(domain)) {
                return true;
            }
        }
        return false;
    }
}
