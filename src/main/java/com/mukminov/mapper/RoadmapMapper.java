package com.mukminov.mapper;

import com.mukminov.api.generated.dto.RoadmapDto;
import com.mukminov.entity.Roadmap;
import org.springframework.stereotype.Component;

import java.time.ZoneOffset;

@Component
public class RoadmapMapper {

    public RoadmapDto toDto(Roadmap entity) {
        if (entity == null) {
            return null;
        }

        RoadmapDto dto = new RoadmapDto();
        dto.setId(entity.getId());
        dto.setUuid(entity.getUuid());
        dto.setTitle(entity.getTitle());
        dto.setDescription(entity.getDescription());
        
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(entity.getCreatedAt().atOffset(ZoneOffset.UTC));
        }
        
        if (entity.getMentor() != null) {
            dto.setMentorId(entity.getMentor().getId());
            dto.setMentorUsername(entity.getMentor().getUsername());
        }
        
        if (entity.getMentee() != null) {
            dto.setMenteeId(entity.getMentee().getId());
            dto.setMenteeUsername(entity.getMentee().getUsername());
        }

        return dto;
    }
}