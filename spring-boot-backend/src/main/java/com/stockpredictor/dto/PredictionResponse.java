package com.stockpredictor.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PredictionResponse {
    private int predictionAction;      // 1=Up, 0=Down
    private double predictedPrice;
    private double currentPrice;
    private double projectedChangePct;
    private double confidenceMetric;
    private java.util.Map<String, Object> history;
    private boolean simulation;
    private String error;
}
