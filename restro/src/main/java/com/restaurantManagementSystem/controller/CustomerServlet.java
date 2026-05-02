package com.restaurantManagementSystem.controller;

import com.restaurantManagementSystem.dao.BillDAO;
import com.restaurantManagementSystem.dao.FeedbackDAO;
import com.restaurantManagementSystem.dao.MenuItemDAO;
import com.restaurantManagementSystem.dao.OrderDAO;
import com.restaurantManagementSystem.dao.ReservationDAO;
import com.restaurantManagementSystem.dao.TableDAO;
import com.restaurantManagementSystem.model.Bill;
import com.restaurantManagementSystem.model.DiningTable;
import com.restaurantManagementSystem.model.Feedback;
import com.restaurantManagementSystem.model.Order;
import com.restaurantManagementSystem.model.OrderItem;
import com.restaurantManagementSystem.model.Reservation;
import com.restaurantManagementSystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CustomerServlet extends HttpServlet {

    private final MenuItemDAO menuDAO = new MenuItemDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final BillDAO billDAO = new BillDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        try {
            switch (path) {
                case "/customer/scan":
                    req.setAttribute("tables", tableDAO.findAll());
                    forward(req, resp, "/pages/customer/scan.jsp");
                    break;

                case "/customer/menu": {
                    String token = req.getParameter("table");
                    req.setAttribute("previewMode", token == null || token.isBlank());
                    if (token != null && !token.isBlank()) {
                        DiningTable table = tableDAO.findByQrToken(token);
                        if (table == null) {
                            req.setAttribute("error", "Invalid QR code. Please scan your table's code again.");
                            req.setAttribute("tables", tableDAO.findAll());
                            forward(req, resp, "/pages/customer/scan.jsp");
                            return;
                        }
                        req.setAttribute("table", table);
                    }
                    req.setAttribute("menuByCategory", menuDAO.findGroupedByCategory());
                    forward(req, resp, "/pages/customer/menu.jsp");
                    break;
                }

                case "/customer/bill": {
                    String tableIdStr = req.getParameter("tableId");
                    if (tableIdStr == null) {
                        resp.sendRedirect(req.getContextPath() + "/customer/scan");
                        return;
                    }

                    int tableId = Integer.parseInt(tableIdStr);
                    DiningTable table = tableDAO.findById(tableId);
                    if (table == null) {
                        req.setAttribute("error", "Table not found.");
                        forward(req, resp, "/pages/customer/scan.jsp");
                        return;
                    }

                    String orderIdStr = req.getParameter("orderId");
                    Order order = null;
                    Bill bill = null;

                    if (orderIdStr != null && !orderIdStr.isBlank()) {
                        int orderId = Integer.parseInt(orderIdStr);
                        order = orderDAO.findByIdWithItems(orderId);
                        if (order != null && order.getTableId() == tableId) {
                            bill = billDAO.findByOrderId(orderId);
                        } else {
                            order = null;
                        }
                    }

                    if (order == null) {
                        List<Order> tableOrders = orderDAO.findActiveByTableId(tableId);
                        if (!tableOrders.isEmpty()) {
                            order = tableOrders.get(0);
                            order.setItems(orderDAO.findOrderItems(order.getId()));
                            bill = billDAO.findByOrderId(order.getId());
                        }
                    }

                    if (order != null) {
                        req.setAttribute("order", order);
                    }
                    if (bill != null) {
                        req.setAttribute("bill", bill);
                    }

                    req.setAttribute("table", table);
                    forward(req, resp, "/pages/customer/bill.jsp");
                    break;
                }

                case "/customer/reservation": {
                    req.setAttribute("tables", tableDAO.findAll());
                    forward(req, resp, "/pages/customer/reservation.jsp");
                    break;
                }

                case "/customer/feedback": {
                    forward(req, resp, "/pages/customer/feedback.jsp");
                    break;
                }

                default:
                    resp.sendRedirect(req.getContextPath() + "/customer/scan");
            }
        } catch (

        NumberFormatException e) {
            req.setAttribute("error", "Invalid parameter.");
            forward(req, resp, "/pages/customer/scan.jsp");
        } catch (Exception e) {
            throw new ServletException("CustomerController GET error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        if ("/customer/reservation".equals(path)) {
            try {
                handleReservationPost(req, resp);
            } catch (Exception e) {
                throw new ServletException("CustomerController reservation error", e);
            }
            return;
        }
        if ("/customer/feedback".equals(path)) {
            try {
                handleFeedbackPost(req, resp);
            } catch (Exception e) {
                throw new ServletException("CustomerController feedback error", e);
            }
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        try {
            String tableIdStr = req.getParameter("tableId");
            String[] itemIds = req.getParameterValues("itemId[]");
            String[] quantities = req.getParameterValues("quantity[]");
            String[] prices = req.getParameterValues("price[]");
            String[] notes = req.getParameterValues("note[]");

            if (tableIdStr == null || tableIdStr.isBlank()) {
                json(resp, false, "tableId is required", -1);
                return;
            }
            if (itemIds == null || itemIds.length == 0) {
                json(resp, false, "No items in order", -1);
                return;
            }
            if (quantities == null || quantities.length != itemIds.length) {
                json(resp, false, "Quantity array length mismatch", -1);
                return;
            }

            int tableId = Integer.parseInt(tableIdStr);

            Order order = new Order();
            order.setTableId(tableId);

            HttpSession session = req.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("currentUser");
                if (user != null && user.getRole() == User.Role.STAFF) {
                    order.setWaiterId(user.getId());
                }
            }

            List<OrderItem> items = new ArrayList<>();
            for (int i = 0; i < itemIds.length; i++) {
                int qty = Integer.parseInt(quantities[i]);
                if (qty <= 0) {
                    continue;
                }

                OrderItem item = new OrderItem();
                item.setMenuItemId(Integer.parseInt(itemIds[i]));
                item.setQuantity(qty);
                item.setUnitPrice(new BigDecimal(prices[i]));
                if (notes != null && notes.length > i && notes[i] != null && !notes[i].isBlank()) {
                    item.setSpecialNote(notes[i].trim());
                }
                items.add(item);
            }

            if (items.isEmpty()) {
                json(resp, false, "All item quantities are zero", -1);
                return;
            }

            order.setItems(items);
            int orderId = orderDAO.createOrder(order);
            resp.getWriter().write("{\"success\":true,\"orderId\":" + orderId + "}");
        } catch (NumberFormatException e) {
            json(resp, false, "Invalid number in request: " + safeMsg(e), -1);
        } catch (Exception e) {
            json(resp, false, safeMsg(e), -1);
        }
    }

    private void handleReservationPost(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String partySizeStr = req.getParameter("partySize");
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String tableIdStr = req.getParameter("tableId");

        if (partySizeStr == null || partySizeStr.isBlank()
                || date == null || date.isBlank() || time == null || time.isBlank()) {
            req.setAttribute("error", "Date, time and party size are required.");
            req.setAttribute("tables", tableDAO.findAll());
            forward(req, resp, "/pages/customer/reservation.jsp");
            return;
        }

        int partySize;
        try {
            partySize = Integer.parseInt(partySizeStr);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Party size must be a valid number.");
            req.setAttribute("tables", tableDAO.findAll());
            forward(req, resp, "/pages/customer/reservation.jsp");
            return;
        }

        Integer tableId = null;
        DiningTable table = null;
        if (tableIdStr != null && !tableIdStr.isBlank()) {
            tableId = Integer.parseInt(tableIdStr);
            table = tableDAO.findById(tableId);
            if (table == null) {
                req.setAttribute("error", "Selected table not found.");
                req.setAttribute("tables", tableDAO.findAll());
                forward(req, resp, "/pages/customer/reservation.jsp");
                return;
            }
            if (table.getStatus() != DiningTable.Status.FREE) {
                req.setAttribute("error", "Please choose a free table or leave the selection blank.");
                req.setAttribute("tables", tableDAO.findAll());
                forward(req, resp, "/pages/customer/reservation.jsp");
                return;
            }
        }

        Reservation reservation = new Reservation();
        reservation.setPartySize(partySize);
        reservation.setReservedAt(java.time.LocalDateTime.parse(date + "T" + time));
        reservation.setNotes(req.getParameter("notes"));
        if (tableId != null) {
            reservation.setTableId(tableId);
        }

        int reservationId = new ReservationDAO().create(reservation);
        if (table != null) {
            tableDAO.updateStatus(tableId, DiningTable.Status.RESERVED);
        }

        req.setAttribute("success", "Reservation request received. Reference #" + reservationId + ".");
        req.setAttribute("tables", tableDAO.findAll());
        forward(req, resp, "/pages/customer/reservation.jsp");
    }

    private void handleFeedbackPost(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String guestName = req.getParameter("guestName");
        String guestEmail = req.getParameter("guestEmail");
        String tableNumber = req.getParameter("tableNumber");
        String cuisineRating = req.getParameter("cuisineRating");
        String serviceRating = req.getParameter("serviceRating");
        String ambienceRating = req.getParameter("ambienceRating");
        String overallRating = req.getParameter("overallRating");
        String comments = req.getParameter("comments");

        if (guestName == null || guestName.isBlank() || guestEmail == null || guestEmail.isBlank()
                || cuisineRating == null || cuisineRating.isBlank()
                || serviceRating == null || serviceRating.isBlank()
                || ambienceRating == null || ambienceRating.isBlank()
                || overallRating == null || overallRating.isBlank()
                || comments == null || comments.isBlank()) {
            req.setAttribute("error", "Name, email, ratings and comments are required.");
            forward(req, resp, "/pages/customer/feedback.jsp");
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setGuestName(guestName.trim());
        feedback.setGuestEmail(guestEmail.trim());
        feedback.setTableNumber(tableNumber != null ? tableNumber.trim() : null);
        feedback.setCuisineRating(parseRating(cuisineRating));
        feedback.setServiceRating(parseRating(serviceRating));
        feedback.setAmbienceRating(parseRating(ambienceRating));
        feedback.setOverallRating(parseRating(overallRating));
        feedback.setComments(comments.trim());

        feedbackDAO.create(feedback);

        req.setAttribute("success", "Thank you! Your feedback has been recorded.");
        forward(req, resp, "/pages/customer/feedback.jsp");
    }

    private int parseRating(String value) {
        try {
            int rating = Integer.parseInt(value);
            if (rating < 1 || rating > 5) {
                throw new NumberFormatException("Rating must be between 1 and 5.");
            }
            return rating;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid rating value.", e);
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String view)
            throws ServletException, IOException {
        req.getRequestDispatcher(view).forward(req, resp);
    }

    private void json(HttpServletResponse resp, boolean success, String error, int id)
            throws IOException {
        if (success) {
            resp.getWriter().write("{\"success\":true,\"orderId\":" + id + "}");
        } else {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + safeMsg2(error) + "\"}");
        }
    }

    private String safeMsg(Exception e) {
        String message = e.getMessage();
        return safeMsg2(message == null ? "Server error" : message);
    }

    private String safeMsg2(String s) {
        if (s == null) {
            return "Server error";
        }
        return s.replace("\\", "\\\\").replace("\"", "'").replace("\n", " ");
    }
}
