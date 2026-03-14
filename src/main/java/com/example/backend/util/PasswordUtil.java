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
        if (password == null) {
            return false;
        }

        
        if (password.length() < 6) {
            return false;
        }

        return true;
    }
}
