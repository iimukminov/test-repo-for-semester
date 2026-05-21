package com.mukminov.repository;

import com.mukminov.entity.RoadmapStep;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoadmapStepRepository extends JpaRepository<RoadmapStep, Long> {
    List<RoadmapStep> findAllByRoadmapIdOrderByStepOrderAsc(Long roadmapId);
}