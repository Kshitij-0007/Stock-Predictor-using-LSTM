package com.stockpredictor.controller;

import com.stockpredictor.entity.User;
import com.stockpredictor.service.AuthService;
import com.stockpredictor.service.PortfolioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/portfolio")
@CrossOrigin(origins = "http://localhost:4200")
public class PortfolioController {

    @Autowired
    private PortfolioService portfolioService;

    @Autowired
    private AuthService authService;

    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> getPortfolio(Authentication authentication) {
        User user = authService.getUserByEmail(authentication.getName());
        return ResponseEntity.ok(portfolioService.getUserPortfolio(user.getId()));
    }
}
