package com.example.backend.util;

import java.security.MessageDigest;
import java.security.SecureRandom;

public class PasswordUtil {

    public static String encrypt(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(chars.length());
            password.append(chars.charAt(index));
        }
        return password.toString();
    }

    public static boolean isValidPassword(String password) {
        return "Mạnh".equals(getPasswordStrength(password));
    }

    public static String getPasswordStrength(String password) {
        if (password == null || password.isBlank()) {
            return "";
        }

        int types = 0;
        if (hasLowerCase(password)) {
            types++;
        }
        if (hasUpperCase(password)) {
            types++;
        }
        if (hasDigit(password)) {
            types++;
        }
        if (hasSpecialCharacter(password)) {
            types++;
        }

        if (password.length() < 8 || types <= 2) {
            return "Yếu";
        }
        if (types == 3) {
            return "Trung bình";
        }
        return "Mạnh";
    }

    public static String getPasswordRequirementMessage() {
        return "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.";
    }

    private static boolean hasLowerCase(String password) {
        for (char ch : password.toCharArray()) {
            if (Character.isLowerCase(ch)) {
                return true;
            }
        }
        return false;
    }

    private static boolean hasUpperCase(String password) {
        for (char ch : password.toCharArray()) {
            if (Character.isUpperCase(ch)) {
                return true;
            }
        }
        return false;
    }

    private static boolean hasDigit(String password) {
        for (char ch : password.toCharArray()) {
            if (Character.isDigit(ch)) {
                return true;
            }
        }
        return false;
    }

    private static boolean hasSpecialCharacter(String password) {
        for (char ch : password.toCharArray()) {
            if (!Character.isLetterOrDigit(ch) && !Character.isWhitespace(ch)) {
                return true;
            }
        }
        return false;
    }
}
