package com.mukminov.service;

import com.mukminov.api.generated.dto.ReviewFeedbackCreateDto;
import com.mukminov.api.generated.dto.ReviewFeedbackDto;

public interface ReviewFeedbackService {
    ReviewFeedbackDto addFeedbackToStep(Long stepId, ReviewFeedbackCreateDto createDto);
    ReviewFeedbackDto getFeedbackByStepId(Long stepId);
}