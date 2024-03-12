package pl.mafia.backend.controllers;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;
import pl.mafia.backend.services.VotingService;

@RestController
@RequestMapping("/voting")
public class VotingController {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    @Autowired
    private VotingService votingService;

    @PostMapping("/vote/{votingId}")
    public ResponseEntity<?> saveVote(@PathVariable Long votingId, @RequestBody VoteRequest voteRequest) {
        try {
            boolean lastVote = votingService.saveVote(votingId, voteRequest.voterUsername, voteRequest.votedUsername);
            if(lastVote)
                votingService.endVoting(votingId);
            return ResponseEntity.noContent().build();
        } catch(IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch(Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @Data
    static class VoteRequest {
        private String voterUsername;
        private String votedUsername;
    }
}