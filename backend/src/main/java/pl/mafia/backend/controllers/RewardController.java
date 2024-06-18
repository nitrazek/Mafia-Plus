package pl.mafia.backend.controllers;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.models.dto.UseRewardDTO;
import pl.mafia.backend.services.MinigameService;

@RestController
@RequestMapping("/reward")
public class RewardController {
  @Autowired
  private MinigameService minigameService;

  @PostMapping()
  public ResponseEntity<?> useReward(@AuthenticationPrincipal AccountDetails accountDetails, @RequestBody UseRewardDTO useRewardDTO) {
    try {
        minigameService.useReward(accountDetails.getUsername(), useRewardDTO.username());
        return ResponseEntity.noContent().build();
    } catch (IllegalArgumentException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
    } catch (Exception ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
    }
  }
}
