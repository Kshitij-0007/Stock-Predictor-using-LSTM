package com.stockpredictor.controller;

import com.stockpredictor.dto.TradeRequest;
import com.stockpredictor.entity.Trade;
import com.stockpredictor.entity.User;
import com.stockpredictor.service.AuthService;
import com.stockpredictor.service.TradingService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/trading")
@CrossOrigin(origins = "http://localhost:4200")
public class TradingController {

    @Autowired
    private TradingService tradingService;

    @Autowired
    private AuthService authService;

    @PostMapping("/")
    public ResponseEntity<?> executeTrade(@Valid @RequestBody TradeRequest request,
                                          Authentication authentication) {
        try {
            User user = authService.getUserByEmail(authentication.getName());
            Trade trade = tradingService.executeTrade(user.getId(), request);
            return ResponseEntity.ok(trade);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(java.util.Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/history")
    public ResponseEntity<List<Trade>> getTradeHistory(Authentication authentication) {
        User user = authService.getUserByEmail(authentication.getName());
        return ResponseEntity.ok(tradingService.getTradeHistory(user.getId()));
    }
}
