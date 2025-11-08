package com.klef.fsd.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
public class RootController {

    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> welcome() {
        Map<String, Object> response = new HashMap<>();
        response.put("application", "E-Store Management System");
        response.put("version", "1.0.0");
        response.put("status", "Running");
        response.put("message", "Welcome to LL-CART Backend API");
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("endpoints", Map.of(
            "health", "/health",
            "api_docs", "/api",
            "admin", "/admin/*",
            "buyer", "/buyer/*",
            "seller", "/seller/*",
            "products", "/products/*",
            "orders", "/orders/*",
            "cart", "/cart/*",
            "payments", "/payments/*"
        ));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("application", "E-Store Management System");
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("message", "Backend service is healthy and running");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api")
    public ResponseEntity<Map<String, Object>> apiInfo() {
        Map<String, Object> response = new HashMap<>();
        response.put("application", "E-Store Management System API");
        response.put("version", "1.0.0");
        response.put("description", "RESTful API for E-Store Management System with features for user authentication, product management, orders, payments, and delivery tracking");
        
        Map<String, String> endpoints = new HashMap<>();
        endpoints.put("Admin APIs", "/admin/* - Admin management endpoints");
        endpoints.put("Buyer APIs", "/buyer/* - Buyer/Customer management endpoints");
        endpoints.put("Seller APIs", "/seller/* - Seller management endpoints");
        endpoints.put("Product APIs", "/products/* - Product catalog endpoints");
        endpoints.put("Order APIs", "/orders/* - Order management endpoints");
        endpoints.put("Cart APIs", "/cart/* - Shopping cart endpoints");
        endpoints.put("Payment APIs", "/payments/* - Payment processing endpoints");
        endpoints.put("Address APIs", "/address/* - Address management endpoints");
        
        response.put("endpoints", endpoints);
        response.put("timestamp", LocalDateTime.now().toString());
        
        return ResponseEntity.ok(response);
    }
}
