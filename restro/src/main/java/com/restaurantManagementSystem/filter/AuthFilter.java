package com.restaurantManagementSystem.filter;

import com.restaurantManagementSystem.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthFilter intercepts protected routes and enforces authentication.
 */
@WebFilter(urlPatterns = {"/admin/*", "/kitchen/*", "/staff/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {
        // No initialization needed.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Login/logout endpoints must remain public or they will loop forever.
        if ("/admin/login".equals(path) || "/admin/logout".equals(path)
                || "/kitchen/login".equals(path) || "/kitchen/logout".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        if (user == null) {
            if (path.startsWith("/kitchen")) {
                resp.sendRedirect(req.getContextPath() + "/kitchen/login");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/login");
            }
            return;
        }

        boolean allowed = false;
        if (path.startsWith("/admin") && user.getRole() == User.Role.ADMIN) {
            allowed = true;
        } else if (path.startsWith("/kitchen")
                && (user.getRole() == User.Role.KITCHEN
                || user.getRole() == User.Role.STAFF
                || user.getRole() == User.Role.ADMIN)) {
            allowed = true;
        } else if (path.startsWith("/staff")
                && (user.getRole() == User.Role.STAFF || user.getRole() == User.Role.ADMIN)) {
            allowed = true;
        }

        if (!allowed) {
            resp.sendRedirect(req.getContextPath() + "/pages/errorpages/error403.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed.
    }
}
