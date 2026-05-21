package com.mukminov.service.impl;

import com.mukminov.entity.Roadmap;
import com.mukminov.entity.User;
import com.mukminov.repository.RoadmapRepository;
import com.mukminov.repository.UserRepository;
import com.mukminov.service.RoadmapService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoadmapServiceImpl implements RoadmapService {

    private final RoadmapRepository roadmapRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public Roadmap createRoadmap(Long mentorId, Long menteeId, String title, String description) {
        User mentor = userRepository.findById(mentorId)
                .orElseThrow(() -> new RuntimeException("Mentor not found"));
        
        User mentee = userRepository.findById(menteeId)
                .orElseThrow(() -> new RuntimeException("Mentee not found"));

        Roadmap roadmap = Roadmap.builder()
                .title(title)
                .description(description)
                .mentor(mentor)
                .mentee(mentee)
                .build();

        return roadmapRepository.save(roadmap);
    }

    @Override
    @Transactional(readOnly = true)
    public Roadmap getRoadmapById(Long id) {
        return roadmapRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Roadmap not found"));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Roadmap> getRoadmapsByMenteeId(Long menteeId) {
        return roadmapRepository.findAllByMenteeId(menteeId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Roadmap> getRoadmapsByMentorId(Long mentorId) {
        return roadmapRepository.findAllByMentorId(mentorId);
    }

    @Override
    @Transactional
    public void deleteRoadmap(Long id) {
        roadmapRepository.deleteById(id);
    }
}