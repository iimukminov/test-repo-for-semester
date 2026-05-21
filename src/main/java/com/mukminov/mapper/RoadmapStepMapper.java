package com.mukminov.mapper;

import com.mukminov.api.generated.dto.RoadmapStepDto;
import com.mukminov.entity.RoadmapStep;
import org.springframework.stereotype.Component;

import java.time.ZoneOffset;

@Component
public class RoadmapStepMapper {

    public RoadmapStepDto toDto(RoadmapStep entity) {
        if (entity == null) {
            return null;
        }

        RoadmapStepDto dto = new RoadmapStepDto();
        dto.setId(entity.getId());
        
        if (entity.getUuid() != null) {
            dto.setUuid(entity.getUuid());
        }
        
        dto.setStepOrder(entity.getStepOrder());
        dto.setTitle(entity.getTitle());
        dto.setContentLink(entity.getContentLink());
        dto.setRequiredCommits(entity.getRequiredCommits());
        
        if (entity.getStatus() != null) {
            dto.setStatus(entity.getStatus().name());
        }
        
        if (entity.getRoadmap() != null) {
            dto.setRoadmapId(entity.getRoadmap().getId());
        }

        if (entity.getStartedAt() != null) {
            dto.setStartedAt(entity.getStartedAt().atOffset(ZoneOffset.UTC));
        }

        return dto;
    }
}