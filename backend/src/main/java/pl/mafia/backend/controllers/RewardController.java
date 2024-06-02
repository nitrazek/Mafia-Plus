package pl.mafia.backend.controllers;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pl.mafia.backend.models.dto.AccountDetails;



@RestController
@RequestMapping("/reward")
public class RewardController {
  @PostMapping("/{roomId}")
  public ResponseEntity<?> reward(
    @PathVariable Long roomId,
    @AuthenticationPrincipal AccountDetails accountDetails,
    @RequestBody String username
      ) {
        try {

            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }


}
