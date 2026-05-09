package com.example.backend.service;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class EmailService {

    private static String RESEND_API_KEY;
    private static String RESEND_FROM_EMAIL;
    private static final String RESEND_API_URL = "https://api.resend.com/emails";
    private final HttpClient httpClient = HttpClient.newHttpClient();

    static {
        try (InputStream input = EmailService.class.getClassLoader().getResourceAsStream("oauth.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("Sorry, unable to find oauth.properties");
            } else {
                prop.load(input);
                RESEND_API_KEY = prop.getProperty("resend.api.key");
                RESEND_FROM_EMAIL = prop.getProperty("resend.from.email");
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public boolean sendNewPasswordEmail(String toEmail, String newPassword) {
        if (RESEND_API_KEY == null || RESEND_API_KEY.startsWith("REPLACE")) {
            System.err.println("Resend API Key is not configured.");
            return false;
        }

        String from = (RESEND_FROM_EMAIL != null) ? RESEND_FROM_EMAIL : "onboarding@resend.dev";
        String subject = "Mật khẩu mới của bạn tại Sun Craft";
        
        String htmlBody = "<div style=\"font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;\">"
                + "<div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);\">"
                + "<div style=\"background-color: #2c3e50; padding: 20px; text-align: center;\">"
                + "<h1 style=\"color: #ffffff; margin: 0; font-size: 24px;\">Sun Craft</h1>"
                + "</div>"
                + "<div style=\"padding: 30px;\">"
                + "<h2 style=\"color: #333333; margin-top: 0;\">Khôi phục mật khẩu</h2>"
                + "<p style=\"color: #666666; line-height: 1.6;\">Xin chào,</p>"
                + "<p style=\"color: #666666; line-height: 1.6;\">Mật khẩu của bạn đã được đặt lại theo yêu cầu. Dưới đây là mật khẩu mới của bạn:</p>"
                + "<div style=\"background-color: #f8f9fa; border: 1px solid #e9ecef; border-radius: 4px; padding: 15px; margin: 20px 0; text-align: center;\">"
                + "<span style=\"font-family: monospace; font-size: 24px; font-weight: bold; color: #2c3e50; letter-spacing: 2px;\">" + newPassword + "</span>"
                + "</div>"
                + "<p style=\"color: #666666; line-height: 1.6;\">Vui lòng đăng nhập và đổi mật khẩu này ngay lập tức để đảm bảo an toàn.</p>"
                + "<p style=\"color: #666666; line-height: 1.6; margin-top: 30px;\">Trân trọng,<br>Đội ngũ Sun Craft</p>"
                + "</div>"
                + "<div style=\"background-color: #f4f4f4; padding: 15px; text-align: center; font-size: 12px; color: #999999;\">"
                + "<p style=\"margin: 0;\">&copy; 2026 Sun Craft. All rights reserved.</p>"
                + "</div>"
                + "</div>"
                + "</div>";

        return sendHtmlEmail(toEmail, subject, htmlBody);
    }

    public boolean sendVerificationCodeEmail(String toEmail, String fullName, String code) {
        String safeName = fullName == null || fullName.trim().isEmpty() ? "bạn" : escapeHtml(fullName.trim());
        String subject = "Mã xác thực đăng ký tài khoản Sun Craft";
        String htmlBody = "<div style=\"font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;\">"
                + "<div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);\">"
                + "<div style=\"background-color: #c0392b; padding: 20px; text-align: center;\">"
                + "<h1 style=\"color: #ffffff; margin: 0; font-size: 24px;\">Sun Craft</h1>"
                + "</div>"
                + "<div style=\"padding: 30px;\">"
                + "<h2 style=\"color: #333333; margin-top: 0;\">Xác thực email đăng ký</h2>"
                + "<p style=\"color: #666666; line-height: 1.6;\">Xin chào " + safeName + ",</p>"
                + "<p style=\"color: #666666; line-height: 1.6;\">Vui lòng dùng mã dưới đây để hoàn tất đăng ký tài khoản:</p>"
                + "<div style=\"background-color: #fff8f1; border: 1px solid #f1dcc8; border-radius: 6px; padding: 18px; margin: 20px 0; text-align: center;\">"
                + "<span style=\"font-family: monospace; font-size: 30px; font-weight: bold; color: #c0392b; letter-spacing: 6px;\">" + code + "</span>"
                + "</div>"
                + "<p style=\"color: #666666; line-height: 1.6;\">Mã này sẽ hết hạn sau 10 phút.</p>"
                + "<p style=\"color: #666666; line-height: 1.6; margin-top: 30px;\">Trân trọng,<br>Đội ngũ Sun Craft</p>"
                + "</div>"
                + "<div style=\"background-color: #f4f4f4; padding: 15px; text-align: center; font-size: 12px; color: #999999;\">"
                + "<p style=\"margin: 0;\">&copy; 2026 Sun Craft. All rights reserved.</p>"
                + "</div>"
                + "</div>"
                + "</div>";

        return sendHtmlEmail(toEmail, subject, htmlBody);
    }

    private boolean sendHtmlEmail(String toEmail, String subject, String htmlBody) {
        if (RESEND_API_KEY == null || RESEND_API_KEY.startsWith("REPLACE")) {
            System.err.println("Resend API Key is not configured.");
            return false;
        }

        String from = (RESEND_FROM_EMAIL != null) ? RESEND_FROM_EMAIL : "onboarding@resend.dev";
        String jsonPayload = String.format("{\"from\":\"Sun Craft <%s>\",\"to\":\"%s\",\"subject\":\"%s\",\"html\":\"%s\"}",
                from, toEmail, subject, escapeJson(htmlBody));

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(RESEND_API_URL))
                .header("Authorization", "Bearer " + RESEND_API_KEY)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonPayload, StandardCharsets.UTF_8))
                .build();

        try {
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                System.out.println("Email sent successfully! Response: " + response.body());
                return true;
            } else {
                System.err.println("Failed to send email. Status: " + response.statusCode() + ", Body: " + response.body());
                return false;
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private String escapeHtml(String value) {
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}