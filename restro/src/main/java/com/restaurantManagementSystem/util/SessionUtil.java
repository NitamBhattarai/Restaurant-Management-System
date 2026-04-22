package com.restaurantManagementSystem.util;

import com.restaurantManagementSystem.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * SessionUtil — helper methods for reading and managing the HTTP session.
 *
 * Used by controllers to avoid repeated boilerplate session attribute access.
 * MVC Role: Utility
 */
public class SessionUtil {

    private static final String USER_KEY    = "currentUser";
    private static final String FLASH_OK    = "flashSuccess";
    private static final String FLASH_ERR   = "flashError";

    // ── User ───────────────────────────────────────────────

    /**
     * Returns the logged-in User from the session, or null if not authenticated.
     */
    public static User getCurrentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute(USER_KEY);
    }

    /**
     * Stores the authenticated user in the session and sets timeout to 8 hours.
     */
    public static void setCurrentUser(HttpServletRequest req, User user) {
        HttpSession session = req.getSession(true);
        session.setAttribute(USER_KEY, user);
        session.setMaxInactiveInterval(60 * 60 * 8);
    }

    /**
     * Invalidates the current session (logout).
     */
    public static void invalidate(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
    }

    /**
     * Returns true if a user is logged in.
     */
    public static boolean isLoggedIn(HttpServletRequest req) {
        return getCurrentUser(req) != null;
    }

    /**
     * Returns true if the logged-in user has the given role.
     */
    public static boolean hasRole(HttpServletRequest req, User.Role role) {
        User user = getCurrentUser(req);
        return user != null && user.getRole() == role;
    }

    // ── Flash messages ─────────────────────────────────────

    /**
     * Store a success flash message — displayed once on the next page render,
     * then automatically removed by the JSP.
     */
    public static void setSuccess(HttpServletRequest req, String message) {
        req.getSession(true).setAttribute(FLASH_OK, message);
    }

    /**
     * Store an error flash message.
     */
    public static void setError(HttpServletRequest req, String message) {
        req.getSession(true).setAttribute(FLASH_ERR, message);
    }

    /**
     * Read and remove a success flash message (consume-once pattern).
     */
    public static String consumeSuccess(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        String msg = (String) session.getAttribute(FLASH_OK);
        session.removeAttribute(FLASH_OK);
        return msg;
    }

    /**
     * Read and remove an error flash message.
     */
    public static String consumeError(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        String msg = (String) session.getAttribute(FLASH_ERR);
        session.removeAttribute(FLASH_ERR);
        return msg;
    }
}

