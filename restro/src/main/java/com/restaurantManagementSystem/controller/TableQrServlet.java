package com.restaurantManagementSystem.controller;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.restaurantManagementSystem.dao.TableDAO;
import com.restaurantManagementSystem.model.DiningTable;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.EnumMap;
import java.util.Map;

public class TableQrServlet extends HttpServlet {

    private static final int DEFAULT_SIZE = 260;
    private final TableDAO tableDAO = new TableDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "QR token is required.");
            return;
        }

        try {
            DiningTable table = tableDAO.findByQrToken(token);
            if (table == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid QR token.");
                return;
            }

            int size = parseSize(req.getParameter("size"));
            String menuUrl = buildMenuUrl(req, table.getQrToken());

            Map<EncodeHintType, Object> hints = new EnumMap<>(EncodeHintType.class);
            hints.put(EncodeHintType.CHARACTER_SET, StandardCharsets.UTF_8.name());
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
            hints.put(EncodeHintType.MARGIN, 1);

            BitMatrix matrix = new QRCodeWriter().encode(menuUrl, BarcodeFormat.QR_CODE, size, size, hints);
            resp.setContentType("image/png");
            resp.setHeader("Cache-Control", "public, max-age=86400");
            MatrixToImageWriter.writeToStream(matrix, "PNG", resp.getOutputStream());
        } catch (Exception e) {
            throw new ServletException("Could not generate table QR code", e);
        }
    }

    private int parseSize(String rawSize) {
        if (rawSize == null || rawSize.isBlank()) {
            return DEFAULT_SIZE;
        }
        try {
            int size = Integer.parseInt(rawSize);
            return Math.max(120, Math.min(size, 600));
        } catch (NumberFormatException e) {
            return DEFAULT_SIZE;
        }
    }

    private String buildMenuUrl(HttpServletRequest req, String token) {
        StringBuilder url = new StringBuilder();
        url.append(req.getScheme()).append("://").append(req.getServerName());
        int port = req.getServerPort();
        if ((req.getScheme().equals("http") && port != 80)
                || (req.getScheme().equals("https") && port != 443)) {
            url.append(':').append(port);
        }
        url.append(req.getContextPath())
                .append("/customer/menu?table=")
                .append(URLEncoder.encode(token, StandardCharsets.UTF_8));
        return url.toString();
    }
}
