package com.example.backend.util;

import java.util.UUID;

public class PasswordChangeTokenUtil {

    private PasswordChangeTokenUtil() {
    }

    public static String generateToken() {
        return UUID.randomUUID().toString();
    }

    public static boolean isValid(String token, String expectedToken, long expiresAt, long now) {
        if (token == null || expectedToken == null) {
            return false;
        }
        return token.equals(expectedToken) && now <= expiresAt;
    }
}
