package com.restaurantManagementSystem.util;

import java.math.BigDecimal;
import java.util.regex.Pattern;

/**
 * ValidationUtil — centralised input validation methods used across controllers.
 *
 * All methods are static — no instantiation needed.
 * MVC Role: Utility
 */
public class ValidationUtil {

    // ── Regex patterns ─────────────────────────────────────────────────────────
    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$");

    private static final Pattern USERNAME_PATTERN =
        Pattern.compile("^[a-zA-Z0-9_\\-]{3,60}$");

    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^[0-9+\\-\\s]{7,20}$");

    private static final Pattern TABLE_NUMBER_PATTERN =
        Pattern.compile("^T[0-9]{2}$");   // T01 – T99

    // ── String checks ──────────────────────────────────────────────────────────

    /** True if the string is null or blank. */
    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /** True if the string is non-null, non-blank, and within max length. */
    public static boolean isValidString(String s, int maxLength) {
        return s != null && !s.trim().isEmpty() && s.trim().length() <= maxLength;
    }

    /** True if the string contains only alphabetic characters and spaces (for names). */
    public static boolean isValidName(String s) {
        return s != null && s.trim().matches("[a-zA-Z .'-]{2,100}");
    }

    // ── Email ──────────────────────────────────────────────────────────────────

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    // ── Username ───────────────────────────────────────────────────────────────

    /** Letters, numbers, underscore, hyphen — 3-60 characters. */
    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    // ── Password ───────────────────────────────────────────────────────────────

    /** Minimum 8 characters. */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 8;
    }

    // ── Phone ──────────────────────────────────────────────────────────────────

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    // ── Numeric ────────────────────────────────────────────────────────────────

    /** True if the string can be parsed as a positive integer. */
    public static boolean isPositiveInt(String s) {
        if (isBlank(s)) return false;
        try { return Integer.parseInt(s.trim()) > 0; }
        catch (NumberFormatException e) { return false; }
    }

    /** True if parseable as positive decimal (for prices). */
    public static boolean isPositiveDecimal(String s) {
        if (isBlank(s)) return false;
        try { return new BigDecimal(s.trim()).compareTo(BigDecimal.ZERO) > 0; }
        catch (NumberFormatException e) { return false; }
    }

    /** True if in range [min, max] inclusive. */
    public static boolean isInRange(int value, int min, int max) {
        return value >= min && value <= max;
    }

    /** True if decimal is in range [min, max] inclusive. */
    public static boolean isInRange(BigDecimal value, BigDecimal min, BigDecimal max) {
        return value.compareTo(min) >= 0 && value.compareTo(max) <= 0;
    }

    // ── Domain-specific ────────────────────────────────────────────────────────

    /** Table number format: T01 – T99. */
    public static boolean isValidTableNumber(String tableNumber) {
        return tableNumber != null && TABLE_NUMBER_PATTERN.matcher(tableNumber.trim()).matches();
    }

    /** Item price must be between Rs 1 and Rs 100,000. */
    public static boolean isValidMenuPrice(BigDecimal price) {
        if (price == null) return false;
        return isInRange(price, new BigDecimal("1.00"), new BigDecimal("100000.00"));
    }

    /** Discount percent: 0–100. */
    public static boolean isValidDiscountPct(BigDecimal pct) {
        if (pct == null) return false;
        return isInRange(pct, BigDecimal.ZERO, new BigDecimal("100"));
    }

    /** Party size for reservations: 1–50. */
    public static boolean isValidPartySize(int size) {
        return isInRange(size, 1, 50);
    }

    // ── Sanitisation ───────────────────────────────────────────────────────────

    /**
     * Strip leading/trailing whitespace and limit length.
     * Returns empty string if input is null.
     */
    public static String sanitize(String s, int maxLength) {
        if (s == null) return "";
        String trimmed = s.trim();
        return trimmed.length() > maxLength ? trimmed.substring(0, maxLength) : trimmed;
    }

    /** Sanitize for HTML display — escape angle brackets. */
    public static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}

