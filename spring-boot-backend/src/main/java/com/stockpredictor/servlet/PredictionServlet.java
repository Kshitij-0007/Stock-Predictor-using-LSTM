package com.stockpredictor.servlet;

import com.stockpredictor.dto.PredictionResponse;
import com.stockpredictor.service.PredictionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "PredictionServlet", urlPatterns = "/servlet/predict")
public class PredictionServlet extends HttpServlet {

    @Autowired
    private PredictionService predictionService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String symbol = req.getParameter("symbol");
        if (symbol == null || symbol.isEmpty()) {
            symbol = "^NSEI";
        }

        PredictionResponse prediction = predictionService.getPrediction(symbol);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        PrintWriter out = resp.getWriter();
        out.print("{");
        out.print("\"symbol\": \"" + symbol + "\",");
        
        if (prediction.getError() != null) {
            out.print("\"error\": \"" + prediction.getError() + "\"");
        } else {
            out.print("\"predictionAction\": " + prediction.getPredictionAction() + ",");
            out.print("\"predictedPrice\": " + prediction.getPredictedPrice() + ",");
            out.print("\"currentPrice\": " + prediction.getCurrentPrice() + ",");
            out.print("\"projectedChangePct\": " + prediction.getProjectedChangePct() + ",");
            out.print("\"confidenceMetric\": " + prediction.getConfidenceMetric());
        }
        
        out.print("}");
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
