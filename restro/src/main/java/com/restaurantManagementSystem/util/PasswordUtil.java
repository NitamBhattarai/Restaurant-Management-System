package com.restaurantManagementSystem.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * PasswordUtil — Wraps BCrypt for password hashing and verification.
 * MVC Role: Utility
 */
public class PasswordUtil {

    private static final int WORK_FACTOR = 12;

    /** Hash a plain-text password using BCrypt. */
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /** Verify a plain-text password against a BCrypt hash. */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}

