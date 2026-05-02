package com.restaurantManagementSystem.controller;

import com.restaurantManagementSystem.dao.OrderDAO;
import com.restaurantManagementSystem.model.Order;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * KitchenController — live kitchen order display and AJAX status updates.
 *
 * Routes (protected by AuthFilter — KITCHEN or ADMIN role required):
 *   GET  /kitchen/display → forward to display.jsp with live orders
 *   POST /kitchen/update  → AJAX update order status, returns JSON
 *
 * MVC Role: Controller
 */
public class KitchenServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    // ── GET: render kitchen display ───────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Support optional filter parameter: ?status=PENDING|PREPARING|READY|ALL
        String filterStatus = req.getParameter("status");

        try {
            List<Order> orders = orderDAO.findActive();

            // Load items for every order — needed by ticket rendering in JSP
            for (Order o : orders) {
                o.setItems(orderDAO.findOrderItems(o.getId()));
            }

            // Apply filter if requested (AJAX partial refresh)
            if (filterStatus != null && !filterStatus.equals("ALL")) {
                orders.removeIf(o -> !o.getStatus().name().equals(filterStatus));
            }

            req.setAttribute("orders",       orders);
            req.setAttribute("filterStatus", filterStatus != null ? filterStatus : "ALL");

            req.getRequestDispatcher("/pages/kitchen/display.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("KitchenController: error loading orders", e);
        }
    }

    // ── POST: AJAX status update ──────────────────────────

    /**
     * Accepts: orderId (int), status (String enum name)
     * Returns: {"success": true} or {"success": false, "error": "..."}
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        try {
            String orderIdStr  = req.getParameter("orderId");
            String statusStr   = req.getParameter("status");

            // Validate
            if (orderIdStr == null || statusStr == null) {
                resp.getWriter().write("{\"success\":false,\"error\":\"Missing parameters\"}");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            Order.Status newStatus = Order.Status.valueOf(statusStr.toUpperCase());

            boolean updated = orderDAO.updateStatus(orderId, newStatus);

            if (updated) {
                resp.getWriter().write("{\"success\":true,\"status\":\"" + newStatus.name() + "\"}");
            } else {
                resp.getWriter().write("{\"success\":false,\"error\":\"Order not found or not updated\"}");
            }

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\":false,\"error\":\"Invalid order ID\"}");
        } catch (IllegalArgumentException e) {
            resp.getWriter().write("{\"success\":false,\"error\":\"Invalid status value\"}");
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + safeMsg(e) + "\"}");
        }
    }

    private String safeMsg(Exception e) {
        String msg = e.getMessage();
        return (msg == null ? "Server error" : msg).replace("\"", "'");
    }
}

