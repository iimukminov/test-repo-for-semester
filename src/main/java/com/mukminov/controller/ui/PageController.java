package com.mukminov.controller.ui;

import com.mukminov.service.core.RoadmapService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class PageController {

    private final RoadmapService roadmapService;

    @GetMapping("/")
    public String index() {
        return "redirect:/roadmap";
    }

    @GetMapping("/roadmap")
    public String getRoadmapsPage(Model model) {
        model.addAttribute("roadmaps", roadmapService.getRoadmaps(null, null));
        return "roadmaps";
    }

    @GetMapping("/test-error")
    public String testError() {
        throw new RuntimeException("Это тестовая ошибка для проверки HTML-хендлера!");
    }
}