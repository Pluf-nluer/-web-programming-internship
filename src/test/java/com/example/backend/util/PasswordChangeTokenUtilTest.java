package com.example.backend.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PasswordChangeTokenUtilTest {

    @Test
    void generateTokenReturnsDifferentValues() {
        String first = PasswordChangeTokenUtil.generateToken();
        String second = PasswordChangeTokenUtil.generateToken();

        assertNotNull(first);
        assertNotNull(second);
        assertNotEquals(first, second);
    }

    @Test
    void isValidReturnsTrueForMatchingTokenBeforeExpiresAt() {
        assertTrue(PasswordChangeTokenUtil.isValid("abc", "abc", 2000, 1000));
    }

    @Test
    void isValidReturnsFalseForExpiredToken() {
        assertFalse(PasswordChangeTokenUtil.isValid("abc", "abc", 1000, 2000));
    }

    @Test
    void isValidReturnsFalseForDifferentToken() {
        assertFalse(PasswordChangeTokenUtil.isValid("abc", "other", 2000, 1000));
    }

    @Test
    void isValidReturnsFalseForMissingToken() {
        assertFalse(PasswordChangeTokenUtil.isValid(null, "abc", 2000, 1000));
        assertFalse(PasswordChangeTokenUtil.isValid("abc", null, 2000, 1000));
    }
}
