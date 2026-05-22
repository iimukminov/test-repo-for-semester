package com.mukminov.exception;

import io.swagger.v3.oas.annotations.Hidden;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.Map;

@Slf4j
@Hidden
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NoResourceFoundException.class)
    public Object handleResourceNotFound(NoResourceFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    @ExceptionHandler(Exception.class)
    public Object handleAllExceptions(Exception ex, HttpServletRequest request) {
        log.error("Unhandled exception caught: ", ex);

        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");

        boolean isAjax = "XMLHttpRequest".equals(requestedWith) ||
                (accept != null && accept.contains("application/json"));

        if (isAjax) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of(
                            "error", true,
                            "message", "Произошла внутренняя ошибка сервера. Попробуйте повторить позже"
                    ));
        }

        ModelAndView modelAndView = new ModelAndView("error/500");
        modelAndView.addObject("errorMessage", ex.getMessage());
        return modelAndView;
    }
}