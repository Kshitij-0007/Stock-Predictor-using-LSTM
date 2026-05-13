package com.stockpredictor.service;

import com.stockpredictor.entity.Holding;
import com.stockpredictor.entity.Portfolio;
import com.stockpredictor.repository.PortfolioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class PortfolioService {

    @Autowired
    private PortfolioRepository portfolioRepository;

    public Map<String, Object> getUserPortfolio(Long userId) {
        Portfolio portfolio = portfolioRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Portfolio not found"));

        double totalHoldingsValue = portfolio.getHoldings().stream()
                .mapToDouble(h -> h.getQuantity() * h.getCurrentPrice())
                .sum();

        double totalValue = portfolio.getBalance() + totalHoldingsValue;
        double pnl = totalValue - 100000.0; // initial balance

        Map<String, Object> response = new HashMap<>();
        response.put("id", portfolio.getId());
        response.put("userId", portfolio.getUserId());
        response.put("balance", portfolio.getBalance());
        response.put("holdings", portfolio.getHoldings().stream().map(h -> {
            Map<String, Object> holdingMap = new HashMap<>();
            holdingMap.put("symbol", h.getSymbol());
            holdingMap.put("quantity", h.getQuantity());
            holdingMap.put("averagePrice", h.getAveragePrice());
            holdingMap.put("currentPrice", h.getCurrentPrice());
            return holdingMap;
        }).toList());
        response.put("totalValue", totalValue);
        response.put("pnl", pnl);

        return response;
    }
}
