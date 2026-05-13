package com.stockpredictor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String index() {
        return "login";
    }

    @GetMapping("/views/login")
    public String login() {
        return "login";
    }

    @GetMapping("/views/register")
    public String register() {
        return "register";
    }

    @GetMapping("/views/dashboard")
    public String dashboard() {
        return "dashboard";
    }
}
