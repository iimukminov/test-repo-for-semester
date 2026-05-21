package com.mukminov.service.impl;

import com.mukminov.api.generated.dto.RoadmapDto;
import com.mukminov.entity.Roadmap;
import com.mukminov.entity.User;
import com.mukminov.mapper.RoadmapMapper;
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
    private final RoadmapMapper roadmapMapper;

    @Override
    @Transactional
    public RoadmapDto createRoadmap(Long mentorId, Long menteeId, String title, String description) {
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

        Roadmap savedRoadmap = roadmapRepository.save(roadmap);
        return roadmapMapper.toDto(savedRoadmap);
    }

    @Override
    @Transactional(readOnly = true)
    public RoadmapDto getRoadmapById(Long id) {
        Roadmap roadmap = roadmapRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Roadmap not found"));
        return roadmapMapper.toDto(roadmap);
    }

    @Override
    @Transactional(readOnly = true)
    public List<RoadmapDto> getRoadmaps(Long mentorId, Long menteeId) {
        List<Roadmap> roadmaps;
        if (mentorId != null) {
            roadmaps = roadmapRepository.findAllByMentorId(mentorId);
        } else if (menteeId != null) {
            roadmaps = roadmapRepository.findAllByMenteeId(menteeId);
        } else {
            roadmaps = roadmapRepository.findAll();
        }

        return roadmaps.stream()
                .map(roadmapMapper::toDto)
                .toList();
    }


    @Override
    @Transactional
    public void deleteRoadmap(Long id) {
        roadmapRepository.deleteById(id);
    }
}