package com.restaurantManagementSystem.controller;

import com.restaurantManagementSystem.dao.*;
import com.restaurantManagementSystem.model.*;
import com.restaurantManagementSystem.model.Reservation;
import com.restaurantManagementSystem.util.ValidationUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

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
@jakarta.servlet.annotation.MultipartConfig(maxFileSize = 5242880, maxRequestSize = 10485760)
public class AdminServlet extends HttpServlet {

    // ── DAOs (Model layer) ────────────────────────────────
    private final OrderDAO orderDAO = new OrderDAO();
    private final MenuItemDAO menuDAO = new MenuItemDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final UserDAO userDAO = new UserDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    // ── GET ───────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        try {
            switch (path) {

                case "/admin/dashboard":
                    List<Order> activeOrders = orderDAO.findActive();
                    if (!activeOrders.isEmpty()) {
                        Order firstOrder = activeOrders.get(0);
                        firstOrder.setItems(orderDAO.findOrderItems(firstOrder.getId()));
                    }
                    req.setAttribute("orders", activeOrders);
                    req.setAttribute("tables", tableDAO.findAll());
                    req.setAttribute("todayRevenue", orderDAO.getTodayRevenue());
                    req.setAttribute("todayOrders", orderDAO.getTodayOrderCount());
                    req.setAttribute("pendingCount", orderDAO.getPendingCount());
                    forward(req, resp, "/pages/admin/dashboard.jsp");
                    break;

                case "/admin/orders":
                    List<Order> allOrders = orderDAO.findAll();
                    for (Order o : allOrders) {
                        o.setItems(orderDAO.findOrderItems(o.getId()));
                    }
                    req.setAttribute("orders", allOrders);
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
                    List<Order> unpaidOrders = orderDAO.findUnpaidOrders();
                    java.util.Map<Integer, Integer> billMap = new java.util.HashMap<>();
                    com.restaurantManagementSystem.dao.BillDAO bDao = new com.restaurantManagementSystem.dao.BillDAO();
                    for (Order o : unpaidOrders) {
                        o.setItems(orderDAO.findOrderItems(o.getId()));
                        com.restaurantManagementSystem.model.Bill b = bDao.findByOrderId(o.getId());
                        if (b != null)
                            billMap.put(o.getId(), b.getId());
                    }
                    req.setAttribute("orders", unpaidOrders);
                    req.setAttribute("billMap", billMap);
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
                    req.setAttribute("reservations",
                            new com.restaurantManagementSystem.dao.ReservationDAO().findUpcoming());
                    forward(req, resp, "/pages/admin/reservations.jsp");
                    break;

                case "/admin/feedback":
                    List<Feedback> feedback = feedbackDAO.findAll();
                    req.setAttribute("feedbackList", feedback);
                    req.setAttribute("averageRating", feedbackDAO.averageRating(feedback));
                    req.setAttribute("positiveCount", feedbackDAO.countPositive(feedback));
                    forward(req, resp, "/pages/admin/feedback.jsp");
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            throw new ServletException("AdminController error on " + path, e);
        }
    }

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
                case "/admin/tables":
                    handleTablePost(req, resp, action);
                    break;
                case "/admin/users":
                    handleUserPost(req, resp, action);
                    break;
                case "/admin/reservations":
                    handleReservationPost(req, resp, action);
                    break;
                case "/admin/feedback":
                    handleFeedbackPost(req, resp, action);
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
                String priceInput = req.getParameter("price");
                if (name == null || name.isBlank() || priceInput == null || priceInput.isBlank()) {
                    setFlash(req, "error", "Name and price are required.");
                    break;
                }
                BigDecimal price = parseMenuPrice(priceInput);
                if (price == null) {
                    setFlash(req, "error", "Price must be a positive number.");
                    break;
                }
                MenuItem item = new MenuItem();
                item.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                item.setName(name.trim());
                item.setDescription(req.getParameter("description"));
                item.setPrice(price);
                item.setEmoji(req.getParameter("emoji"));
                item.setImageUrl(saveUploadedMenuImage(req));
                menuDAO.create(item);
                setFlash(req, "success", "Menu item added: " + name);
                break;
            }

            case "update": {
                String name = req.getParameter("name");
                String priceInput = req.getParameter("price");
                if (name == null || name.isBlank() || priceInput == null || priceInput.isBlank()) {
                    setFlash(req, "error", "Name and price are required.");
                    break;
                }
                BigDecimal price = parseMenuPrice(priceInput);
                if (price == null) {
                    setFlash(req, "error", "Price must be a positive number.");
                    break;
                }
                int id = Integer.parseInt(req.getParameter("id"));
                MenuItem item = menuDAO.findById(id);
                if (item != null) {
                    item.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                    item.setName(name.trim());
                    item.setDescription(req.getParameter("description"));
                    item.setPrice(price);
                    item.setAvailable("1".equals(req.getParameter("available")));
                    item.setEmoji(req.getParameter("emoji"));
                    String imageUrl = saveUploadedMenuImage(req);
                    if (imageUrl != null) {
                        item.setImageUrl(imageUrl);
                    }
                    menuDAO.update(item);
                    setFlash(req, "success", "Item updated successfully.");
                }
                break;
            }

            case "delete": {
                int id = Integer.parseInt(req.getParameter("id"));
                try {
                    if (menuDAO.delete(id)) {
                        setFlash(req, "success", "Item removed from menu.");
                    } else {
                        setFlash(req, "error", "Menu item was not found.");
                    }
                } catch (SQLIntegrityConstraintViolationException e) {
                    setFlash(req, "error", "This item has order history and cannot be permanently removed.");
                }
                break;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/menu");
    }

    private BigDecimal parseMenuPrice(String priceInput) {
        if (!ValidationUtil.isPositiveDecimal(priceInput)) {
            return null;
        }
        return new BigDecimal(priceInput.trim());
    }

    private String saveUploadedMenuImage(HttpServletRequest req) throws IOException, ServletException {
        Part imagePart = req.getPart("imageFile");
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        String originalFileName = imagePart.getSubmittedFileName();
        if (originalFileName == null || originalFileName.isBlank()) {
            return null;
        }
        String submittedName = Paths.get(originalFileName).getFileName().toString();
        String lowerName = submittedName.toLowerCase(Locale.ROOT);
        String extension = ".jpg";
        int dot = lowerName.lastIndexOf('.');
        if (dot >= 0) {
            extension = lowerName.substring(dot);
        }
        if (!extension.matches("\\.(jpg|jpeg|png|gif|webp)$")) {
            throw new ServletException("Only JPG, PNG, GIF, and WEBP images are allowed.");
        }

        String uploadRoot = req.getServletContext().getRealPath("/uploads/menu");
        if (uploadRoot == null) {
            throw new ServletException("Upload directory is not available for this deployment.");
        }

        Files.createDirectories(Paths.get(uploadRoot));
        String fileName = UUID.randomUUID() + extension;
        Path destination = Paths.get(uploadRoot, fileName);
        try (InputStream input = imagePart.getInputStream()) {
            Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
        }
        return "/uploads/menu/" + fileName;
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

    // ── Table management ──────────────────────────────────

    private void handleTablePost(HttpServletRequest req, HttpServletResponse resp, String action)
            throws Exception {
        if ("create".equals(action)) {
            String num = req.getParameter("tableNumber");
            int cap = Integer.parseInt(req.getParameter("capacity"));
            tableDAO.create(num, cap);
            setFlash(req, "success", "Table added successfully.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/tables");
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

    private void handleFeedbackPost(HttpServletRequest req, HttpServletResponse resp, String action)
            throws Exception {
        if ("create".equals(action)) {
            Feedback feedback = new Feedback();
            feedback.setGuestName(required(req, "guestName", "Guest name is required."));
            feedback.setGuestEmail(req.getParameter("guestEmail"));
            feedback.setTableNumber(req.getParameter("tableNumber"));
            feedback.setCuisineRating(rating(req, "cuisineRating"));
            feedback.setServiceRating(rating(req, "serviceRating"));
            feedback.setAmbienceRating(rating(req, "ambienceRating"));
            feedback.setOverallRating(rating(req, "overallRating"));
            feedback.setComments(required(req, "comments", "Feedback comments are required."));
            feedbackDAO.create(feedback);
            setFlash(req, "success", "Feedback added for " + feedback.getGuestName() + ".");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/feedback");
    }

    private String required(HttpServletRequest req, String name, String message) {
        String value = req.getParameter(name);
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(message);
        }
        return value.trim();
    }

    private int rating(HttpServletRequest req, String name) {
        int value = Integer.parseInt(required(req, name, "Rating is required."));
        if (value < 1 || value > 5) {
            throw new IllegalArgumentException("Ratings must be between 1 and 5.");
        }
        return value;
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {
        req.getRequestDispatcher(view).forward(req, resp);
    }

    private void setFlash(HttpServletRequest req, String type, String message) {
        req.getSession().setAttribute("flash" + Character.toUpperCase(type.charAt(0)) + type.substring(1), message);
    }
}
