package com.mukminov.repository;

import com.mukminov.entity.RoadmapStep;
import com.mukminov.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    @Query("""
            SELECT DISTINCT u FROM User u WHERE u.id IN (
            SELECT r.mentee.id FROM Roadmap r JOIN r.steps s
            WHERE s.status = :status AND s.startedAt < :deadline)
           """)
    List<User> findMenteesWithOverdueSteps(
            @Param("status") RoadmapStep.StepStatus status,
            @Param("deadline") LocalDateTime deadline
    );
}