package com.restaurantManagementSystem.controller;

import com.restaurantManagementSystem.dao.*;
import com.restaurantManagementSystem.model.*;
import com.restaurantManagementSystem.model.Reservation;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

///**
// * AdminController — handles all admin dashboard pages.
// *
// * Routes (all protected by AuthFilter):
// * GET /admin/dashboard → overview with stats
// * GET /admin/orders → full order list
// * POST /admin/orders → update order status
// * GET /admin/menu → menu items list
// * POST /admin/menu → create/update/delete menu item
// * GET /admin/tables → table map
// * GET /admin/billing → billing page
// * GET /admin/reports → revenue reports
// * GET /admin/payments → payment records
// * GET /admin/users → staff management
// * POST /admin/users → create/deactivate user
// * GET /admin/settings → system settings
// * GET /admin/reservations → reservations list
// *
// * MVC Role: Controller
// */
@WebServlet(name = "AdminController", urlPatterns = {
        "/admin/dashboard", "/admin/orders", "/admin/menu",
        "/admin/tables", "/admin/billing", "/admin/reports",
        "/admin/payments", "/admin/users", "/admin/settings",
        "/admin/reservations"
})
public class AdminController extends HttpServlet {

    // ── DAOs (Model layer) ────────────────────────────────
    private final OrderDAO orderDAO = new OrderDAO();
    private final MenuItemDAO menuDAO = new MenuItemDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final UserDAO userDAO = new UserDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    // ── GET ───────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException{

        String path = req.getServletPath();

        try {
            switch (path) {

                case "/admin/dashboard":
                    req.setAttribute("orders", orderDAO.findActive());
                    req.setAttribute("tables", tableDAO.findAll());
                    req.setAttribute("todayRevenue", orderDAO.getTodayRevenue());
                    req.setAttribute("todayOrders", orderDAO.getTodayOrderCount());
                    req.setAttribute("pendingCount", orderDAO.getPendingCount());
                    forward(req, resp, "/pages/admin/dashboard.jsp");
                    break;

                case "/admin/orders":
                    req.setAttribute("orders", orderDAO.findAll());
                    forward(req, resp, "/pages/admin/orders.jsp");
                    break;

                case "/admin/menu":
                    req.setAttribute("menuItems", menuDAO.findAll());
                    req.setAttribute("categories", new CategoryDAO().findActive());
                    forward(req, resp, "/pages/admin/menu.jsp");
                    break;

                case "/admin/tables":
                    req.setAttribute("tables", tableDAO.findAll());
                    forward(req, resp, "/pages/admin/tables.jsp");
                    break;

                case "/admin/billing":
                    req.setAttribute("orders", orderDAO.findAll());
                    forward(req, resp, "/pages/admin/billing.jsp");
                    break;

                case "/admin/reports":
                    req.setAttribute("todayRevenue", orderDAO.getTodayRevenue());
                    req.setAttribute("todayOrders", orderDAO.getTodayOrderCount());
                    req.setAttribute("paymentMethods", paymentDAO.getMethodCounts());
                    forward(req, resp, "/pages/admin/reports.jsp");
                    break;

                case "/admin/payments":
                    req.setAttribute("payments", paymentDAO.findAll());
                    forward(req, resp, "/pages/admin/payments.jsp");
                    break;

                case "/admin/users":
                    req.setAttribute("users", userDAO.findAll());
                    forward(req, resp, "/pages/admin/users.jsp");
                    break;

                case "/admin/settings":
                    forward(req, resp, "/pages/admin/settings.jsp");
                    break;

                case "/admin/reservations":
                    req.setAttribute("reservations", new com.restaurantManagementSystem.dao.ReservationDAO().findUpcoming());
                    forward(req, resp, "/pages/admin/reservations.jsp");
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            throw new ServletException("AdminController error on " + path, e);
        }
    }

    // ── POST ──────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        String action = req.getParameter("action");

        try {
            switch (path) {
                case "/admin/menu":
                    handleMenuPost(req, resp, action);
                    break;
                case "/admin/orders":
                    handleOrderPost(req, resp, action);
                    break;
                case "/admin/users":
                    handleUserPost(req, resp, action);
                    break;
                case "/admin/reservations":
                    handleReservationPost(req, resp, action);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + path);
            }
        } catch (Exception e) {
            throw new ServletException("AdminController POST error", e);
        }
    }

    // ── Menu CRUD ─────────────────────────────────────────

    private void handleMenuPost(HttpServletRequest req, HttpServletResponse resp, String action)
            throws Exception {

        switch (action == null ? "" : action) {

            case "create": {
                // Validate: name and price must not be blank
                String name = req.getParameter("name");
                String price = req.getParameter("price");
                if (name == null || name.isBlank() || price == null || price.isBlank()) {
                    setFlash(req, "error", "Name and price are required.");
                    break;
                }
                MenuItem item = new MenuItem();
                item.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                item.setName(name.trim());
                item.setDescription(req.getParameter("description"));
                item.setPrice(new BigDecimal(price));
                item.setEmoji(req.getParameter("emoji"));
                menuDAO.create(item);
                setFlash(req, "success", "Menu item added: " + name);
                break;
            }

            case "update": {
                int id = Integer.parseInt(req.getParameter("id"));
                MenuItem item = menuDAO.findById(id);
                if (item != null) {
                    item.setName(req.getParameter("name"));
                    item.setDescription(req.getParameter("description"));
                    item.setPrice(new BigDecimal(req.getParameter("price")));
                    item.setAvailable("1".equals(req.getParameter("available")));
                    item.setEmoji(req.getParameter("emoji"));
                    menuDAO.update(item);
                    setFlash(req, "success", "Item updated successfully.");
                }
                break;
            }

            case "delete": {
                int id = Integer.parseInt(req.getParameter("id"));
                menuDAO.delete(id);
                setFlash(req, "success", "Item removed from menu.");
                break;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/menu");
    }

    // ── Order status update ───────────────────────────────

    private void handleOrderPost(HttpServletRequest req, HttpServletResponse resp, String action)
            throws Exception {

        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            Order.Status status = Order.Status.valueOf(req.getParameter("status"));
            orderDAO.updateStatus(orderId, status);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }

    // ── User management ───────────────────────────────────

    private void handleUserPost(HttpServletRequest req, HttpServletResponse resp, String action)
            throws Exception {

        switch (action == null ? "" : action) {

            case "create": {
                String username = req.getParameter("username");
                String email = req.getParameter("email");
                String password = req.getParameter("password");

                // Validation
                if (username == null || username.isBlank()) {
                    setFlash(req, "error", "Username is required.");
                    break;
                }
                if (password == null || password.length() < 8) {
                    setFlash(req, "error", "Password must be at least 8 characters.");
                    break;
                }
                if (userDAO.usernameExists(username.trim())) {
                    setFlash(req, "error", "Username already exists.");
                    break;
                }
                if (userDAO.emailExists(email.trim())) {
                    setFlash(req, "error", "Email already in use.");
                    break;
                }

                User u = new User();
                u.setFullName(req.getParameter("fullName"));
                u.setEmail(email.trim());
                u.setUsername(username.trim());
                u.setPassword(password);
                u.setRole(User.Role.valueOf(req.getParameter("role")));
                u.setActive(true);
                userDAO.create(u);
                setFlash(req, "success", "User created: " + u.getFullName());
                break;
            }

            case "deactivate": {
                int userId = Integer.parseInt(req.getParameter("userId"));
                User current = (User) req.getSession().getAttribute("currentUser");
                if (current != null && current.getId() == userId) {
                    setFlash(req, "error", "You cannot deactivate your own account.");
                    break;
                }
                userDAO.deactivate(userId);
                setFlash(req, "success", "User deactivated.");
                break;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    // ── Reservation management ────────────────────────────

    private void handleReservationPost(HttpServletRequest req, HttpServletResponse resp, String action)
            throws Exception {
        com.restaurantManagementSystem.dao.ReservationDAO resDAO = new com.restaurantManagementSystem.dao.ReservationDAO();
        switch (action == null ? "" : action) {
            case "create": {
                Reservation res = new Reservation();
                res.setGuestName(req.getParameter("guestName"));
                res.setGuestPhone(req.getParameter("guestPhone"));
                res.setGuestEmail(req.getParameter("guestEmail"));
                String psize = req.getParameter("partySize");
                res.setPartySize(psize != null ? Integer.parseInt(psize) : 2);
                String date = req.getParameter("date");
                String time = req.getParameter("time");
                if (date != null && time != null) {
                    res.setReservedAt(java.time.LocalDateTime.parse(date + "T" + time));
                }
                String tableId = req.getParameter("tableId");
                if (tableId != null && !tableId.isBlank())
                    res.setTableId(Integer.parseInt(tableId));
                res.setNotes(req.getParameter("notes"));
                resDAO.create(res);
                setFlash(req, "success", "Reservation created.");
                break;
            }
            case "cancel": {
                int id = Integer.parseInt(req.getParameter("id"));
                resDAO.cancel(id);
                setFlash(req, "success", "Reservation cancelled.");
                break;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/reservations");
    }

    // ── end of AdminController ────────────────────────────

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {
        req.getRequestDispatcher(view).forward(req, resp);
    }

    private void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + Character.toUpperCase(type.charAt(0)) + type.substring(1), message);
    }
}

