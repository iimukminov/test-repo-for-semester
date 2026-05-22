package com.mukminov.controller.ui;

import com.mukminov.security.CustomUserDetails;
import com.mukminov.service.core.ConsultationService;
import io.swagger.v3.oas.annotations.Hidden;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
@Hidden
public class ConsultationUiController {

    private final ConsultationService consultationService;

    @GetMapping("/consultations")
    public String getConsultationsPage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        Long userId = userDetails.getUser().getId();
        boolean isMentor = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("MENTOR"));
        
        model.addAttribute("currentUserId", userId);
        model.addAttribute("isMentor", isMentor);
        model.addAttribute("consultations", consultationService.getConsultations(
                isMentor ? userId : null, 
                !isMentor ? userId : null
        ));
        
        return "consultations";
    }
}