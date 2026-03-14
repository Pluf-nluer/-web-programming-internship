package com.example.backend.service;

import com.example.backend.dao.UserDAO;
import com.example.backend.model.User;
import com.example.backend.util.PasswordUtil;

public class AuthService {

    private UserDAO userDAO = new UserDAO();
    private EmailService emailService = new EmailService();

    public boolean handleForgotPassword(String email) {
        User user = userDAO.findByEmailOrPhone(email);

        if (user == null) {
            System.out.println("Forgot password request for non-existent email: " + email);
            return false; 
        }

        String newPassword = PasswordUtil.generateRandomPassword(10); 
        String hashedPassword = PasswordUtil.encrypt(newPassword);

        if (hashedPassword == null) {
            System.err.println("Failed to hash the new password.");
            return false;
        }
        boolean updateSuccess = userDAO.updatePassword(user.getId(), hashedPassword);

        if (!updateSuccess) {
            System.err.println("Failed to update password in DB for user: " + email);
            return false;
        }
        boolean emailSent = emailService.sendNewPasswordEmail(user.getEmail(), newPassword);

        return emailSent;
    }
}
