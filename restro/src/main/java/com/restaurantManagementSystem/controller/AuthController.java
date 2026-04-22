package com.restaurantManagementSystem.controller;

import com.restaurantManagementSystem.dao.UserDAO;
import com.restaurantManagementSystem.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AuthController — handles login (GET=show form, POST=authenticate) and logout.
 *
 * Routes:
 *   GET  /admin/login   → admin login form
 *   POST /admin/login   → authenticate admin/staff
 *   GET  /admin/logout  → invalidate session, redirect to login
 *   GET  /kitchen/login → kitchen login form (PIN pad)
 *   POST /kitchen/login → authenticate kitchen staff
 *   GET  /kitchen/logout→ invalidate session, redirect to kitchen login
 *
 * MVC Role: Controller
 */
@WebServlet(
    name = "AuthController",
    urlPatterns = {"/admin/login", "/admin/logout", "/kitchen/login", "/kitchen/logout"}
)
public class AuthController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ── GET ───────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path    = req.getServletPath();
        String context = req.getContextPath();

        // Handle logout
        if (path.endsWith("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            if (path.startsWith("/kitchen")) {
                resp.sendRedirect(context + "/kitchen/login");
            } else {
                resp.sendRedirect(context + "/admin/login");
            }
            return;
        }

        // Already logged in → redirect to appropriate dashboard
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user != null) {
            if (user.getRole() == User.Role.KITCHEN) {
                resp.sendRedirect(context + "/kitchen/display");
            } else {
                resp.sendRedirect(context + "/admin/dashboard");
            }
            return;
        }

        // Show login form
        if (path.startsWith("/kitchen")) {
            req.getRequestDispatcher("/pages/kitchen/login.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/pages/admin/login.jsp").forward(req, resp);
        }
    }

    // ── POST ──────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path     = req.getServletPath();
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Input validation
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Username and password are required.");
            String view = path.startsWith("/kitchen")
                        ? "/pages/kitchen/login.jsp" : "/pages/admin/login.jsp";
            req.getRequestDispatcher(view).forward(req, resp);
            return;
        }

        try {
            User user = userDAO.authenticate(username.trim(), password);

            if (user == null) {
                req.setAttribute("error", "Invalid username or password.");
                String view = path.startsWith("/kitchen")
                            ? "/pages/kitchen/login.jsp" : "/pages/admin/login.jsp";
                req.getRequestDispatcher(view).forward(req, resp);
                return;
            }

            // Role enforcement
            if (path.startsWith("/kitchen") && user.getRole() == User.Role.STAFF) {
                req.setAttribute("error", "Admin or kitchen staff access required.");
                req.getRequestDispatcher("/pages/kitchen/login.jsp").forward(req, resp);
                return;
            }
            if (!path.startsWith("/kitchen") && user.getRole() == User.Role.KITCHEN) {
                req.setAttribute("error", "Admin or staff access required for this portal.");
                req.getRequestDispatcher("/pages/admin/login.jsp").forward(req, resp);
                return;
            }

            // Create session
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(60 * 60 * 8); // 8 hours

            // Redirect based on role
            String context = req.getContextPath();
            if (user.getRole() == User.Role.KITCHEN) {
                resp.sendRedirect(context + "/kitchen/display");
            } else {
                resp.sendRedirect(context + "/admin/dashboard");
            }

        } catch (Exception e) {
            req.setAttribute("error", "A system error occurred. Please try again.");
            String view = path.startsWith("/kitchen")
                        ? "/pages/kitchen/login.jsp" : "/pages/admin/login.jsp";
            req.getRequestDispatcher(view).forward(req, resp);
        }
    }
}

