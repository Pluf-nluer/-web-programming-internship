package com.example.backend.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;

public class MomoConfig {
    public static final String PARTNER_CODE = "MOMOBKUN20180529";
    public static final String ACCESS_KEY = "klm05TvNCyandKxG";
    public static final String SECRET_KEY = "at67qH6mk8g5i1peY2x14P2hX0v91saM";
    public static final String ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";
    public static final String RETURN_URL = "http://localhost:8080/momo-return";
    public static final String NOTIFY_URL = "http://localhost:8080/momo-motify";

    /* Khi thực hiện thanh toán thì momo sẽ bắt chúng ta gửi signature là chữ ký điện tử
     được tạo từ việc băm thông tin đơn hàng của khách hàng ra + thêm cái secret.
     */
    public static String signHmacSHA256(String data, String secretKey) throws Exception{
        Mac hmacSha256 = Mac.getInstance("HmacSHA256");
        SecretKeySpec spec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8),"HmacSHA256");
        hmacSha256.init(spec);
        byte[] hash = hmacSha256.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder builder = new StringBuilder();
        for(byte b: hash){
            String hex = Integer.toHexString(0xff & b);
            if(hex.length() ==1){
                builder.append('0');
            }
            builder.append(hex);
        }
        return builder.toString();
    }

}
