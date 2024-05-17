package pl.mafia.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pl.mafia.backend.models.db.Game;
import pl.mafia.backend.models.db.Round;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.services.GameService;
import pl.mafia.backend.services.RoomService;

import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/game")
public class GameController {
    @Autowired
    private RoomService roomService;
    @Autowired
    private GameService gameService;
    @Autowired
    private ScheduledExecutorService scheduledExecutorService;
    
    @PostMapping("/start/{roomId}")
    public ResponseEntity<?> startGame(@PathVariable Long roomId, @AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            String username = accountDetails.getUsername();
            if(roomService.isHost(username, roomId))
                gameService.startGame(roomId);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (IllegalAccessException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus .INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @GetMapping("/history")
    public ResponseEntity<?> getHistory(@AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            gameService.getHistory();
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus .INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }
}
