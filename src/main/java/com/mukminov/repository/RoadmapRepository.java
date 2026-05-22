package com.mukminov.repository;

import com.mukminov.entity.Roadmap;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoadmapRepository extends JpaRepository<Roadmap, Long>, RoadmapRepositoryCustom {
    List<Roadmap> findAllByMenteeId(Long menteeId);
    List<Roadmap> findAllByMentorId(Long mentorId);
}