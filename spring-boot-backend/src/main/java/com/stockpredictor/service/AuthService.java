package com.stockpredictor.service;

import com.stockpredictor.config.JwtUtil;
import com.stockpredictor.dto.AuthResponse;
import com.stockpredictor.dto.LoginRequest;
import com.stockpredictor.dto.RegisterRequest;
import com.stockpredictor.entity.Portfolio;
import com.stockpredictor.entity.User;
import com.stockpredictor.repository.PortfolioRepository;
import com.stockpredictor.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PortfolioRepository portfolioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        // Check if user already exists
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("User with this email already exists");
        }

        // Create user
        User user = User.builder()
                .email(request.getEmail())
                .fullName(request.getFullName())
                .hashedPassword(passwordEncoder.encode(request.getPassword()))
                .build();

        user = userRepository.save(user);

        // Initialize portfolio with 100k balance
        Portfolio portfolio = Portfolio.builder()
                .userId(user.getId())
                .balance(100000.0)
                .build();
        portfolioRepository.save(portfolio);

        // Generate JWT
        String token = jwtUtil.generateToken(user.getEmail(), user.getId());

        return AuthResponse.builder()
                .accessToken(token)
                .tokenType("Bearer")
                .userId(user.getId())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Incorrect email or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getHashedPassword())) {
            throw new RuntimeException("Incorrect email or password");
        }

        String token = jwtUtil.generateToken(user.getEmail(), user.getId());

        return AuthResponse.builder()
                .accessToken(token)
                .tokenType("Bearer")
                .userId(user.getId())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .build();
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }
}
