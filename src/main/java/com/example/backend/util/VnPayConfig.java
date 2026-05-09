package com.example.backend.util;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Random;
public class VnPayConfig {
    public static String vnp_TmnCode = "THAY_MA_TMN_CODE_CUA_BAN_VAO_DAY";
    public static String vnp_HashSecret = "THAY_SECRET_CUA_BAN_VAO_DAY";
    public static String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static String vnp_ReturnUrl = "http://localhost:8080/vnpay-return";
    public static String vnp_apiUrl = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";

    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
    public static String getIpAddress(HttpServletRequest request) {
        String ipAdress;
        try {
            ipAdress = request.getHeader("X-FORWARDED-FOR");
            if(ipAdress == null){
                ipAdress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAdress = "Ip Invalid";
        }
        return ipAdress;
    }

}
