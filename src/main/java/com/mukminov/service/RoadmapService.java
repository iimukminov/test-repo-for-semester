package com.mukminov.service;

import com.mukminov.api.generated.dto.RoadmapDto;
import com.mukminov.entity.Roadmap;

import java.util.List;

public interface RoadmapService {
    RoadmapDto createRoadmap(Long mentorId, Long menteeId, String title, String description);
    RoadmapDto getRoadmapById(Long id);
    List<RoadmapDto> getRoadmaps(Long mentorId, Long menteeId);
    void deleteRoadmap(Long id);
}