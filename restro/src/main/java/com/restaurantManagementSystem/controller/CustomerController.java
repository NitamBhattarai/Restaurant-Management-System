package com.restaurantManagementSystem.controller;

import com.restaurantManagementSystem.dao.BillDAO;
import com.restaurantManagementSystem.dao.MenuItemDAO;
import com.restaurantManagementSystem.dao.OrderDAO;
import com.restaurantManagementSystem.dao.TableDAO;
import com.restaurantManagementSystem.model.Bill;
import com.restaurantManagementSystem.model.DiningTable;
import com.restaurantManagementSystem.model.Order;
import com.restaurantManagementSystem.model.OrderItem;
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

public class CustomerController extends HttpServlet {

    private final MenuItemDAO menuDAO = new MenuItemDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final BillDAO billDAO = new BillDAO();

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

                default:
                    resp.sendRedirect(req.getContextPath() + "/customer/scan");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid parameter.");
            forward(req, resp, "/pages/customer/scan.jsp");
        } catch (Exception e) {
            throw new ServletException("CustomerController GET error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
