package com.stockpredictor.service;

import com.stockpredictor.dto.PredictionResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class PredictionService {

    @Value("${app.lstm.service.url}")
    private String lstmServiceUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    @SuppressWarnings("unchecked")
    public PredictionResponse getPrediction(String symbol) {
        try {
            String url = lstmServiceUrl + "/predict/" + symbol;
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);

            if (response == null) {
                return PredictionResponse.builder()
                        .error("No response from LSTM service")
                        .build();
            }

            if (response.containsKey("error")) {
                return PredictionResponse.builder()
                        .error(response.get("error").toString())
                        .build();
            }

            return PredictionResponse.builder()
                    .predictionAction(((Number) response.get("prediction_action")).intValue())
                    .predictedPrice(((Number) response.get("predicted_price")).doubleValue())
                    .currentPrice(((Number) response.get("current_price")).doubleValue())
                    .projectedChangePct(((Number) response.get("projected_change_pct")).doubleValue())
                    .confidenceMetric(((Number) response.get("confidence_metric")).doubleValue())
                    .history((Map<String, Object>) response.get("history"))
                    .simulation(response.containsKey("simulation") && (Boolean) response.get("simulation"))
                    .build();
        } catch (Exception e) {
            return PredictionResponse.builder()
                    .error("LSTM service unavailable: " + e.getMessage())
                    .build();
        }
    }
}
