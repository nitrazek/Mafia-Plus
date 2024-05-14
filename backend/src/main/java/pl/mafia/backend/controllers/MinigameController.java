package pl.mafia.backend.controllers;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.services.MinigameService;

@RestController
@RequestMapping("/minigame")
public class MinigameController {
  @Autowired
  private MinigameService minigameService;
  private Object object;

  @PostMapping("/{minigameId}")
  public ResponseEntity<?> finishMinigame(
    @PathVariable Long minigameId,
    @AuthenticationPrincipal AccountDetails accountDetails,
    @RequestBody FinishMinigameRequest request
  ) {
    try {
      String username = accountDetails.getUsername();
      boolean lastMinigameFinished = minigameService.finishMinigame(minigameId, username, request.score);
      if(lastMinigameFinished) {
        minigameService.summarizeMinigame(minigameId);
      }
      return ResponseEntity.noContent().build();
    } catch(IllegalArgumentException ex) {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
    } catch(Exception ex) {
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
    }
  }

  @Data
  static class FinishMinigameRequest {
    private int score;
  }
}
