package pl.mafia.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Room;
import pl.mafia.backend.models.dto.RoomSettingsUpdate;
import pl.mafia.backend.models.dto.RoomUpdate;
import pl.mafia.backend.repositories.AccountRepository;
import pl.mafia.backend.models.db.RoomSettings;
import pl.mafia.backend.repositories.RoomRepository;
import pl.mafia.backend.repositories.RoomSettingsRepository;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

import static pl.mafia.backend.repositories.specifications.RoomSpecifications.isRoomPublic;

@Component
public class RoomService {
    @Autowired
    private AccountService accountService;
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private RoomSettingsRepository roomSettingsRepository;
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    public List<RoomUpdate> getPublicRooms() {
        return roomRepository.findAll(isRoomPublic())
                .stream()
                .map(RoomUpdate::new)
                .toList();
    }

    @Transactional(readOnly = true)
    public Room getRoomById(long id) {
        Optional<Room> fetchedRoom = roomRepository.findById(id);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exists.");
        return fetchedRoom.get();
    }

    @Transactional(readOnly = true)
    public Room getRoomByAccessCode(String accessCode) {
        Optional<Room> fetchedRoom = roomRepository.findByAccessCode(accessCode);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exists.");
        return fetchedRoom.get();
    }

    public boolean isHost(String username, long roomId) throws IllegalAccessException {
        Room room = getRoomById(roomId);
        Account host = accountService.getAccount(username);
        return Objects.equals(room.getHost().getUsername(), host.getUsername());
    }

    @Transactional
    public RoomUpdate joinRoomByAccessCode(String accessCode, String username) throws IllegalAccessException {
        Room room = getRoomByAccessCode(accessCode);
        Account account = accountService.getAccount(username);

        if (room.getRoomSettings().getMaxNumberOfPlayers() <= room.getAccounts().size())
            throw new IllegalAccessException("Lobby is full.");

        account.setRoom(room);
        room.getAccounts().add(account);
        accountRepository.save(account);
        room = roomRepository.save(room);

        return new RoomUpdate(room);
    }

    @Transactional
    public RoomUpdate joinRoomById(Long id, String username) throws IllegalAccessException {
        Room room = getRoomById(id);
        Account account = accountService.getAccount(username);

        if (room.getRoomSettings().getMaxNumberOfPlayers() <= room.getAccounts().size())
            throw new IllegalAccessException("Lobby is full.");

        account.setRoom(room);
        room.getAccounts().add(account);
        accountRepository.save(account);
        room = roomRepository.save(room);

        return new RoomUpdate(room);
    }

    @Transactional
    public void leaveRoom(String username) throws IllegalAccessException {
        Account account = accountService.getAccount(username);

        if(account.getRoom() == null)
            throw new IllegalAccessException("Account is not in any room.");

        Room room = account.getRoom();
        if(room.getAccounts().size() == 1) {
            account.setRoom(null);
            roomSettingsRepository.delete(room.getRoomSettings());
            roomRepository.delete(room);
            accountRepository.save(account);
            return;
        }

        account.setRoom(null);
        room.getAccounts().remove(account);
        if(room.getHost().equals(account)) {
            room.setHost(room.getAccounts().get(0));
        }
        roomRepository.save(room);
        accountRepository.save(account);

        RoomUpdate roomUpdate = new RoomUpdate(room);
        messagingTemplate.convertAndSend("/topic/" + roomUpdate.id() + "/room", roomUpdate);
    }

    @Transactional
    public RoomUpdate createRoom(String hostUsername) {
        Account host = accountService.getAccount(hostUsername);

        Room createdRoom = new Room();
        createdRoom.setHost(host);
        createdRoom.getAccounts().add(host);
        createdRoom.setAccessCode("");

        RoomSettings createdRoomSettings = new RoomSettings();
        createdRoomSettings.setRoom(createdRoom);
        createdRoomSettings.setPublic(true);
        createdRoomSettings.setMaxNumberOfPlayers(10);
        createdRoomSettings = roomSettingsRepository.save(createdRoomSettings);

        createdRoom.setRoomSettings(createdRoomSettings);
        createdRoom = roomRepository.save(createdRoom);

        host.setRoom(createdRoom);
        accountRepository.save(host);

        int codeLength = 7;
        String base26String = Long.toString(createdRoom.getId(), 26).toUpperCase();
        base26String = String.format("%" + codeLength + "s", base26String).replace(' ', '0');
        base26String = base26String.substring(Math.max(0, base26String.length() - codeLength));

        createdRoom.setAccessCode(base26String);
        createdRoom = roomRepository.save(createdRoom);

        return new RoomUpdate(createdRoom);
    }

    @Transactional
    public RoomUpdate updateRoomSettings(RoomSettingsUpdate roomSettingsUpdate, Long roomId) {
        Room room = getRoomById(roomId);

        RoomSettings roomSettings = room.getRoomSettings();
        roomSettings.setPublic(roomSettingsUpdate.isPublic());
        roomSettings.setMaxNumberOfPlayers(roomSettingsUpdate.maxNumberOfPlayers());
        room.setRoomSettings(roomSettings);

        roomSettingsRepository.save(roomSettings);
        room = roomRepository.save(room);

        return new RoomUpdate(room);
    }
}
