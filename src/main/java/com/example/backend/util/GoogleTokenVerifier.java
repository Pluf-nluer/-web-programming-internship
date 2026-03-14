package com.example.backend.util;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;

public final class GoogleTokenVerifier {
    private static final NetHttpTransport HTTP_TRANSPORT = new NetHttpTransport();
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static volatile GoogleIdTokenVerifier verifier;
    private static volatile String cachedClientId;

    private GoogleTokenVerifier() {
    }

    public static GoogleIdToken verify(String idTokenString) throws GeneralSecurityException, IOException {
        if (idTokenString == null || idTokenString.isBlank()) {
            return null;
        }
        GoogleIdTokenVerifier currentVerifier = getVerifier();
        if (currentVerifier == null) {
            return null;
        }
        return currentVerifier.verify(idTokenString);
    }

    private static GoogleIdTokenVerifier getVerifier() {
        String clientId = GoogleOAuthConfig.getClientId();
        if (clientId == null || clientId.isBlank()) {
            return null;
        }
        if (verifier != null && clientId.equals(cachedClientId)) {
            return verifier;
        }
        synchronized (GoogleTokenVerifier.class) {
            if (verifier == null || !clientId.equals(cachedClientId)) {
                verifier = new GoogleIdTokenVerifier.Builder(HTTP_TRANSPORT, JSON_FACTORY)
                        .setAudience(Collections.singletonList(clientId))
                        .build();
                cachedClientId = clientId;
            }
            return verifier;
        }
    }
}
