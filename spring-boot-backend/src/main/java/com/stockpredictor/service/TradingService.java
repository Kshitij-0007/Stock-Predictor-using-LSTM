package com.stockpredictor.service;

import com.stockpredictor.dto.TradeRequest;
import com.stockpredictor.entity.Holding;
import com.stockpredictor.entity.Portfolio;
import com.stockpredictor.entity.Trade;
import com.stockpredictor.repository.PortfolioRepository;
import com.stockpredictor.repository.TradeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TradingService {

    @Autowired
    private PortfolioRepository portfolioRepository;

    @Autowired
    private TradeRepository tradeRepository;

    @Transactional
    public Trade executeTrade(Long userId, TradeRequest request) {
        Portfolio portfolio = portfolioRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Portfolio not found"));

        double totalCost = request.getPrice() * request.getQuantity();
        List<Holding> holdings = portfolio.getHoldings();

        if ("buy".equalsIgnoreCase(request.getAction())) {
            // Check funds
            if (portfolio.getBalance() < totalCost) {
                throw new RuntimeException("Insufficient funds");
            }

            portfolio.setBalance(portfolio.getBalance() - totalCost);

            // Update or create holding
            Holding existing = holdings.stream()
                    .filter(h -> h.getSymbol().equals(request.getSymbol()))
                    .findFirst()
                    .orElse(null);

            if (existing != null) {
                double newTotalCost = (existing.getQuantity() * existing.getAveragePrice()) + totalCost;
                existing.setQuantity(existing.getQuantity() + request.getQuantity());
                existing.setAveragePrice(newTotalCost / existing.getQuantity());
                existing.setCurrentPrice(request.getPrice());
            } else {
                Holding newHolding = Holding.builder()
                        .symbol(request.getSymbol())
                        .quantity(request.getQuantity())
                        .averagePrice(request.getPrice())
                        .currentPrice(request.getPrice())
                        .portfolio(portfolio)
                        .build();
                holdings.add(newHolding);
            }

        } else if ("sell".equalsIgnoreCase(request.getAction())) {
            Holding existing = holdings.stream()
                    .filter(h -> h.getSymbol().equals(request.getSymbol()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Do not hold this stock"));

            if (existing.getQuantity() < request.getQuantity()) {
                throw new RuntimeException("Insufficient shares");
            }

            existing.setQuantity(existing.getQuantity() - request.getQuantity());
            portfolio.setBalance(portfolio.getBalance() + totalCost);

            // Remove empty holdings
            if (existing.getQuantity() == 0) {
                holdings.remove(existing);
            }
        }

        portfolioRepository.save(portfolio);

        // Record trade
        Trade trade = Trade.builder()
                .userId(userId)
                .symbol(request.getSymbol())
                .action(request.getAction())
                .quantity(request.getQuantity())
                .price(request.getPrice())
                .status("executed")
                .build();

        return tradeRepository.save(trade);
    }

    public List<Trade> getTradeHistory(Long userId) {
        return tradeRepository.findByUserIdOrderByTimestampDesc(userId);
    }
}
