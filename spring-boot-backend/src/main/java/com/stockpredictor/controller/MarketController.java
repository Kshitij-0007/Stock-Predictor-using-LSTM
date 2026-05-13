package com.stockpredictor.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/market")
@CrossOrigin(origins = "http://localhost:4200")
public class MarketController {

    // Cached market data
    private static final Map<String, Double> defaultPrices = Map.of(
            "^NSEI", 22500.00,
            "RELIANCE.NS", 2850.00,
            "TCS.NS", 3950.00
    );

    @GetMapping("/prices")
    public ResponseEntity<Map<String, Double>> getMarketPrices() {
        // Returns default/cached prices
        // In production, you'd integrate with a real market data API
        Map<String, Double> prices = new HashMap<>(defaultPrices);

        // Add slight randomization to simulate live data
        prices.replaceAll((symbol, price) -> 
            price + (Math.random() - 0.5) * price * 0.002
        );

        return ResponseEntity.ok(prices);
    }

    @GetMapping("/watchlist")
    public ResponseEntity<?> getWatchlist() {
        return ResponseEntity.ok(java.util.List.of(
                Map.of("symbol", "^NSEI", "name", "NIFTY 50"),
                Map.of("symbol", "RELIANCE.NS", "name", "Reliance Ind."),
                Map.of("symbol", "TCS.NS", "name", "TCS")
        ));
    }
}
