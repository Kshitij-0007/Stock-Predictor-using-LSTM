package com.stockpredictor.controller;

import com.stockpredictor.dto.PredictionResponse;
import com.stockpredictor.service.PredictionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/prediction")
@CrossOrigin(origins = "http://localhost:4200")
public class PredictionController {

    @Autowired
    private PredictionService predictionService;

    @GetMapping("/{symbol}")
    public ResponseEntity<PredictionResponse> getPrediction(@PathVariable String symbol) {
        return ResponseEntity.ok(predictionService.getPrediction(symbol));
    }
}
