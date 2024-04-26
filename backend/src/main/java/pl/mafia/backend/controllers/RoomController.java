package pl.mafia.backend.controllers;

import jdk.javadoc.doclet.Reporter;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.models.db.RoomSettings;
import pl.mafia.backend.models.dto.RoomSettingsUpdate;
import pl.mafia.backend.models.dto.RoomUpdate;
import pl.mafia.backend.services.RoomService;

import java.util.List;

@RestController
@RequestMapping("/room")
public class RoomController {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    @Autowired
    private RoomService roomService;

    @GetMapping("/public")
    public ResponseEntity<?> getPublicRooms() {
        try {
            return ResponseEntity.ok(roomService.getPublicRooms());
        } catch(Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @PostMapping("/{id}")
    public ResponseEntity<?> joinRoomById(@PathVariable String id, @AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            String username = accountDetails.getUsername();
            RoomUpdate roomUpdate = roomService.joinRoomById(Long.parseLong(id), username);
            messagingTemplate.convertAndSend("/topic/" + id + "/room", roomUpdate);
            return ResponseEntity.ok(roomUpdate);
        } catch(IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch(IllegalAccessException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(ex.getMessage());
        } catch(Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @PostMapping("/code/{accessCode}")
    public ResponseEntity<?> joinRoomByAccessCode(@PathVariable String accessCode, @AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            String username = accountDetails.getUsername();
            RoomUpdate roomUpdate = roomService.joinRoomByAccessCode(accessCode, username);
            messagingTemplate.convertAndSend("/topic/" + roomUpdate.id() + "/room", roomUpdate);
            return ResponseEntity.ok(roomUpdate);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (IllegalAccessException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @PostMapping("/leave")
    public ResponseEntity<?> leaveRoom(@AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            String username = accountDetails.getUsername();
            roomService.leaveRoom(username);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (IllegalAccessException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @PostMapping()
    public ResponseEntity<?> createRoom(@AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            String username = accountDetails.getUsername();
            return ResponseEntity.ok(roomService.createRoom(username));
        } catch(IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(ex.getMessage());
        } catch(Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @PutMapping("{roomId}/settings")
    public ResponseEntity<?> updateRoomSettings(@PathVariable String roomId, @RequestBody RoomSettingsUpdate roomSettingsUpdate) {
        try {
            RoomUpdate roomUpdate = roomService.updateRoomSettings(roomSettingsUpdate, Long.parseLong(roomId));
            messagingTemplate.convertAndSend("/topic/" + roomId + "/room", roomUpdate);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }
}
