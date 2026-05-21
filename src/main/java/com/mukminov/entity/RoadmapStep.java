package com.mukminov.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "roadmap_steps")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class RoadmapStep {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @EqualsAndHashCode.Include
    @Column(updatable = false, nullable = false, unique = true)
    @Builder.Default
    private UUID uuid = UUID.randomUUID();

    @Column(name = "step_order", nullable = false)
    private Integer stepOrder;

    @Column(nullable = false)
    private String title;

    @Column(name = "content_link")
    private String contentLink;

    @Column(name = "required_commits")
    private Integer requiredCommits;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StepStatus status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "roadmap_id", nullable = false)
    private Roadmap roadmap;

    @OneToOne(mappedBy = "roadmapStep", cascade = CascadeType.ALL)
    private ReviewFeedback reviewFeedback;

    public enum StepStatus {
        LOCKED, IN_PROGRESS, REVIEW, DONE
    }
}