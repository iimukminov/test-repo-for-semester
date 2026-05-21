package com.mukminov.service;

import com.mukminov.entity.Roadmap;

import java.util.List;

public interface RoadmapService {
    Roadmap createRoadmap(Long mentorId, Long menteeId, String title, String description);
    Roadmap getRoadmapById(Long id);
    List<Roadmap> getRoadmapsByMenteeId(Long menteeId);
    List<Roadmap> getRoadmapsByMentorId(Long mentorId);
    void deleteRoadmap(Long id);
}