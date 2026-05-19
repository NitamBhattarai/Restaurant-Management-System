package com.restaurantManagementSystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Serves uploaded menu item images from the external upload directory.
 *
 * Uploaded images are stored outside the webapp root so they survive WAR
 * redeployment. Tomcat cannot serve those as static files, so this servlet
 * streams them through /menu-image?file=<filename>.
 */

public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fileName = req.getParameter("file");
        if (fileName == null || fileName.isBlank()
                || fileName.contains("/") || fileName.contains("\\")
                || fileName.contains("..")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file name.");
            return;
        }

        String uploadRoot = getServletContext().getInitParameter("uploadDir");
        if (uploadRoot == null || uploadRoot.isBlank()) {
            uploadRoot = System.getProperty("restaurant.uploadDir");
        }
        if (uploadRoot == null || uploadRoot.isBlank()) {
            uploadRoot = System.getProperty("user.home") + "/restaurant-uploads/menu";
        }

        Path uploadRootPath = Paths.get(uploadRoot).normalize();
        Path filePath = uploadRootPath.resolve(fileName).normalize();
        if (!filePath.startsWith(uploadRootPath)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!Files.exists(filePath) || !Files.isRegularFile(filePath)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = detectContentType(fileName);
        }

        resp.setContentType(contentType);
        resp.setContentLengthLong(Files.size(filePath));
        resp.setHeader("Cache-Control", "public, max-age=31536000, immutable");

        try (OutputStream out = resp.getOutputStream()) {
            Files.copy(filePath, out);
        }
    }

    private String detectContentType(String fileName) {
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) {
            return "image/jpeg";
        }
        if (lower.endsWith(".png")) {
            return "image/png";
        }
        if (lower.endsWith(".gif")) {
            return "image/gif";
        }
        if (lower.endsWith(".webp")) {
            return "image/webp";
        }
        return "application/octet-stream";
    }
}
