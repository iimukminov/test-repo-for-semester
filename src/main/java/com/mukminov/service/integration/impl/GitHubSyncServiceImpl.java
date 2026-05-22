package com.mukminov.service.integration.impl;

import com.mukminov.client.GitHubClient;
import com.mukminov.entity.RoadmapStep;
import com.mukminov.repository.RoadmapStepRepository;
import com.mukminov.service.integration.GitHubSyncService;
import com.mukminov.util.GitHubUrlParser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class GitHubSyncServiceImpl implements GitHubSyncService {

    private final RoadmapStepRepository stepRepository;
    private final GitHubClient gitHubClient;

    @Override
    public void syncActiveSteps() {
        List<RoadmapStep> activeSteps = stepRepository.findAllByStatus(RoadmapStep.StepStatus.IN_PROGRESS);
        
        if (activeSteps.isEmpty()) {
            log.debug("No active roadmap steps found for GitHub sync.");
            return;
        }

        log.info("Processing {} active steps for GitHub sync.", activeSteps.size());

        for (RoadmapStep step : activeSteps) {
            processStep(step);
        }
    }

    private void processStep(RoadmapStep step) {
        String repoUrl = step.getContentLink();
        String githubUsername = step.getRoadmap().getMentee().getGithubUsername();

        if (githubUsername == null || githubUsername.isEmpty()) {
            log.debug("Step ID {} skipped: Mentee has no GitHub username linked.", step.getId());
            return;
        }

        if (step.getStartedAt() == null) {
            log.warn("Step ID {} skipped: IN_PROGRESS but missing 'startedAt' timestamp.", step.getId());
            return;
        }

        String[] ownerAndRepo = GitHubUrlParser.extractOwnerAndRepo(repoUrl);
        if (ownerAndRepo == null) {
            log.warn("Step ID {} skipped: Invalid GitHub URL '{}'.", step.getId(), repoUrl);
            return;
        }

        String owner = ownerAndRepo[0];
        String repo = ownerAndRepo[1];
        String sinceIso = step.getStartedAt().atOffset(ZoneOffset.UTC).format(DateTimeFormatter.ISO_INSTANT);

        int actualCommits = gitHubClient.getCommitsCount(owner, repo, githubUsername, sinceIso);

        log.info("Step ID: {} | Required: {} | Found: {}", step.getId(), step.getRequiredCommits(), actualCommits);

        if (actualCommits >= step.getRequiredCommits()) {
            log.info("Step ID: {} completed required commits. Moving to REVIEW.", step.getId());
            step.setStatus(RoadmapStep.StepStatus.REVIEW);
            stepRepository.save(step);
        }
    }
}