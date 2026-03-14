package com.example.backend.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class GoogleOAuthConfig {
    private static final String PROPS_PATH = "/oauth.properties";
    private static final String CLIENT_ID_KEY = "google.clientId";
    private static final String ENV_KEY = "GOOGLE_CLIENT_ID";
    private static final String CLIENT_ID = loadClientId();

    private GoogleOAuthConfig() {
    }

    public static String getClientId() {
        return CLIENT_ID;
    }

    public static boolean hasClientId() {
        return CLIENT_ID != null && !CLIENT_ID.isBlank();
    }

    static String resolveClientId(String envValue, String propValue) {
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }
        if (propValue != null && !propValue.isBlank()) {
            return propValue.trim();
        }
        return null;
    }

    private static String loadClientId() {
        String envValue = System.getenv(ENV_KEY);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }

        Properties props = new Properties();
        try (InputStream in = GoogleOAuthConfig.class.getResourceAsStream(PROPS_PATH)) {
            if (in != null) {
                props.load(in);
                return resolveClientId(null, props.getProperty(CLIENT_ID_KEY));
            }
            System.err.println("Khong tim thay " + PROPS_PATH + " cho Google OAuth.");
        } catch (IOException e) {
            System.err.println("Loi doc " + PROPS_PATH + ": " + e.getMessage());
        }
        return null;
    }
}
