package com.mukminov.repository;

import com.mukminov.entity.ReviewFeedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReviewFeedbackRepository extends JpaRepository<ReviewFeedback, Long> {
}