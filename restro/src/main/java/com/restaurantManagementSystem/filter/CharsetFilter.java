package com.restaurantManagementSystem.filter;

import jakarta.servlet.*;
import java.io.IOException;

/**
 * CharsetFilter — Ensures UTF-8 encoding for all requests and responses.
 * MVC Role: Filter (Infrastructure)
 */
public class CharsetFilter implements Filter {

    private String encoding;

    @Override
    public void init(FilterConfig config) {
        encoding = config.getInitParameter("encoding");
        if (encoding == null)
            encoding = "UTF-8";
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        if (req.getCharacterEncoding() == null) {
            req.setCharacterEncoding(encoding);
        }
        res.setCharacterEncoding(encoding);
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}

