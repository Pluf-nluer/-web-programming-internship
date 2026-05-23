package com.example.backend.util;
import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Random;
public class VnPayConfig {
    public static String vnp_TmnCode = "1OX425KY";
    public static String vnp_HashSecret = "A39RL365YF5TPJPZXHJPUDSAW2HPJ941";
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
    public static String hmacSHA512(final String key, final String data){
        try{
            if(key == null || data == null){
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] keyByte = key.getBytes();
            final SecretKeySpec secret = new SecretKeySpec(keyByte, "HmacSHA512");
            hmac512.init(secret);
            byte[] dataByte = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataByte);
            StringBuilder builder = new StringBuilder(2 * result.length);
            for (byte b: result){
                builder.append(String.format("%02x",b&0xff));
            }
            return builder.toString();
        }catch(Exception exception){
            return "";
        }

    }
    public static String getIpAddress(HttpServletRequest request) {
        String ipAdress;
        try {
            ipAdress = request.getHeader("X-FORWARDED-FOR");
            if(ipAdress == null){
                ipAdress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAdress = "Invalid";
        }
        return ipAdress;
    }

}
