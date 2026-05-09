package com.example.backend.util;

import com.example.backend.model.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class RememberMeUtil {

    public static final String COOKIE_NAME = "rememberMe";
    public static final int MAX_AGE_SECONDS = 15 * 24 * 60 * 60;
    private static final String DELIMITER = ":";

    private RememberMeUtil() {
    }

    public static String createToken(User user) {
        long expiresAt = System.currentTimeMillis() + (MAX_AGE_SECONDS * 1000L);
        String signature = createSignature(user.getId(), expiresAt, user.getPassword());
        String rawToken = user.getId() + DELIMITER + expiresAt + DELIMITER + signature;
        return Base64.getUrlEncoder().withoutPadding().encodeToString(rawToken.getBytes(StandardCharsets.UTF_8));
    }

    public static Integer getUserId(String token) {
        String[] parts = getParts(token);
        if (parts == null || isExpired(parts[1])) {
            return null;
        }

        try {
            return Integer.parseInt(parts[0]);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static boolean isValidToken(String token, User user) {
        String[] parts = getParts(token);
        if (parts == null || user == null || isExpired(parts[1])) {
            return false;
        }

        try {
            int userId = Integer.parseInt(parts[0]);
            long expiresAt = Long.parseLong(parts[1]);
            if (userId != user.getId()) {
                return false;
            }
            String expectedSignature = createSignature(userId, expiresAt, user.getPassword());
            return MessageDigest.isEqual(expectedSignature.getBytes(StandardCharsets.UTF_8), parts[2].getBytes(StandardCharsets.UTF_8));
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static Cookie createCookie(User user, boolean secure) {
        Cookie cookie = new Cookie(COOKIE_NAME, createToken(user));
        cookie.setPath("/");
        cookie.setMaxAge(MAX_AGE_SECONDS);
        cookie.setHttpOnly(true);
        cookie.setSecure(secure);
        cookie.setAttribute("SameSite", "Lax");
        return cookie;
    }

    public static Cookie clearCookie(boolean secure) {
        Cookie cookie = new Cookie(COOKIE_NAME, "");
        cookie.setPath("/");
        cookie.setMaxAge(0);
        cookie.setHttpOnly(true);
        cookie.setSecure(secure);
        cookie.setAttribute("SameSite", "Lax");
        return cookie;
    }

    public static String getCookieValue(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (COOKIE_NAME.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }

    private static String[] getParts(String token) {
        if (token == null || token.trim().isEmpty()) {
            return null;
        }

        try {
            String rawToken = new String(Base64.getUrlDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = rawToken.split(DELIMITER);
            if (parts.length != 3) {
                return null;
            }
            return parts;
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private static boolean isExpired(String expiresAtValue) {
        try {
            return System.currentTimeMillis() > Long.parseLong(expiresAtValue);
        } catch (NumberFormatException e) {
            return true;
        }
    }

    private static String createSignature(int userId, long expiresAt, String password) {
        String value = userId + DELIMITER + expiresAt + DELIMITER + password;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(value.getBytes(StandardCharsets.UTF_8));
            StringBuilder result = new StringBuilder();
            for (byte b : hash) {
                result.append(String.format("%02x", b));
            }
            return result.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }
}
