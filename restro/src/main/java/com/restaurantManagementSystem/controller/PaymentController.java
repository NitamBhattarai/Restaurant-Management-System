package com.restaurantManagementSystem.controller;

import com.restaurantManagementSystem.dao.BillDAO;
import com.restaurantManagementSystem.dao.OrderDAO;
import com.restaurantManagementSystem.dao.PaymentDAO;
import com.restaurantManagementSystem.model.Bill;
import com.restaurantManagementSystem.model.Order;
import com.restaurantManagementSystem.model.Payment;
import com.restaurantManagementSystem.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * PaymentController — process a payment for a bill.
 *
 * Routes (protected by AuthFilter — ADMIN or STAFF role):
 *   POST /admin/payment/process
 *
 * Accepts:
 *   billId         — int, required
 *   orderId        — int, required
 *   method         — CASH | ESEWA | KHALTI | CARD
 *   discountPct    — decimal, optional (0–100)
 *   transactionRef — String, optional (eSewa/Khalti reference)
 *
 * Returns JSON:
 *   {"success": true,  "paymentId": 7}
 *   {"success": false, "error": "..."}
 *
 * Side effects:
 *   1. Applies discount to bill (if discountPct > 0)
 *   2. Inserts payment record
 *   3. Updates order status → SERVED
 *
 * MVC Role: Controller
 */
public class PaymentController extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final BillDAO    billDAO    = new BillDAO();
    private final OrderDAO   orderDAO   = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        try {
            // ── Parse parameters ──────────────────────────
            String billIdStr   = req.getParameter("billId");
            String orderIdStr  = req.getParameter("orderId");
            String methodStr   = req.getParameter("method");
            String discStr     = req.getParameter("discountPct");
            String txnRef      = req.getParameter("transactionRef");

            if (billIdStr == null || orderIdStr == null || methodStr == null) {
                write(resp, false, "Missing required parameters", -1);
                return;
            }

            int billId  = Integer.parseInt(billIdStr);
            int orderId = Integer.parseInt(orderIdStr);
            Payment.Method method = Payment.Method.valueOf(methodStr.toUpperCase());

            // ── Step 1: Apply discount (if provided) ──────
            if (discStr != null && !discStr.isBlank()) {
                BigDecimal disc = new BigDecimal(discStr);
                if (disc.compareTo(BigDecimal.ZERO) > 0 && disc.compareTo(new BigDecimal("100")) < 0) {
                    billDAO.applyDiscount(billId, disc);
                }
            }

            // ── Step 2: Load updated bill total ───────────
            Bill bill = billDAO.findById(billId);
            if (bill == null) {
                write(resp, false, "Bill #" + billId + " not found", -1);
                return;
            }

            // ── Step 3: Record payment ─────────────────────
            Payment payment = new Payment();
            payment.setBillId(billId);
            payment.setAmountPaid(bill.getTotal());
            payment.setMethod(method);
            payment.setStatus(Payment.Status.PAID);
            payment.setTransactionRef(txnRef);

            // Attach the staff member who processed this payment
            HttpSession session = req.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("currentUser");
                if (user != null) payment.setProcessedById(user.getId());
            }

            int paymentId = paymentDAO.create(payment);

            // ── Step 4: Mark order as SERVED ──────────────
            orderDAO.updateStatus(orderId, Order.Status.SERVED);

            // ── Return success ─────────────────────────────
            write(resp, true, null, paymentId);

        } catch (NumberFormatException e) {
            write(resp, false, "Invalid numeric parameter", -1);
        } catch (IllegalArgumentException e) {
            write(resp, false, "Invalid payment method", -1);
        } catch (Exception e) {
            String msg = e.getMessage() == null ? "Server error" : e.getMessage().replace("\"", "'");
            write(resp, false, msg, -1);
        }
    }

    private void write(HttpServletResponse resp, boolean success, String error, int paymentId)
            throws IOException {
        if (success) {
            resp.getWriter().write("{\"success\":true,\"paymentId\":" + paymentId + "}");
        } else {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + error + "\"}");
        }
    }
}

