package pl.mafia.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import pl.mafia.backend.models.db.*;
import pl.mafia.backend.models.dto.RoundDTO;
import pl.mafia.backend.models.dto.VotingStart;
import pl.mafia.backend.models.dto.VotingSummary;
import pl.mafia.backend.repositories.*;
import pl.mafia.backend.websockets.WebSocketListener;
import pl.mafia.backend.models.dto.GameStartDTO;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.*;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class GameService {
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private GameRepository gameRepository;
    @Autowired
    private RoundRepository roundRepository;
    @Autowired
    private VotingRepository votingRepository;
    @Autowired
    private PlayerRepository playerRepository;
    @Autowired
    private WebSocketListener webSocketListener;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
    @Autowired
    private ScheduledExecutorService scheduledExecutorService;
    @Autowired
    private PlatformTransactionManager transactionManager;

    private String getRandomRole() {
        String[] roles = new String[]{"citizen", "mafia"};
        return roles[new Random().nextInt(roles.length)];
    }

    private Player createNewPlayer(String username, Game game, String role) {
        Player newPlayer = new Player();
        newPlayer.setUsername(username);
        newPlayer.setGame(game);
        newPlayer.setRole(role);
        newPlayer.setAlive(true);
        return newPlayer;
    }

    @Transactional
    public Game getGame(Long gameId) {
        Optional<Game> fetchedGame = gameRepository.findById(gameId);
        if(fetchedGame.isEmpty())
            throw new IllegalArgumentException("Player does not exists.");
        return fetchedGame.get();
    }

    @Transactional
    public Round getRound(Long roundId) {
        Optional<Round> fetchedRound = roundRepository.findById(roundId);
        if(fetchedRound.isEmpty())
            throw new IllegalArgumentException("Player does not exists.");
        return fetchedRound.get();
    }

    @Transactional
    public Player getPlayer(String username) {
        Optional<Player> fetchedPlayer = playerRepository.findByUsername(username);
        if(fetchedPlayer.isEmpty())
            throw new IllegalArgumentException("Player does not exists.");
        return fetchedPlayer.get();
    }

    @Transactional
    public void startGame(Long roomId) throws IllegalAccessException {
        Optional<Room> fetchedRoom = roomRepository.findById(roomId);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exists.");

        Room room = fetchedRoom.get();

        Game createdGame = new Game();
        createdGame.setCreateTimestamp(Timestamp.from(Instant.now()));
        createdGame = gameRepository.save(createdGame);

        for(Account account : room.getAccounts()) {
            String role = getRandomRole();
            Player newPlayer = createNewPlayer(account.getUsername(), createdGame, role);
            createdGame.getPlayers().add(newPlayer);
            playerRepository.save(newPlayer);
            // historia gier - do zrobienia później
            account.getGames().add(createdGame);
            createdGame.getAccounts().add(account);
            accountRepository.save(account);
        }
        createdGame.setRoom(room);
        room.setGame(createdGame);

        createdGame = gameRepository.save(createdGame);
        roomRepository.save(room);

        String destination = "/queue/game-start";
        for(Player player : createdGame.getPlayers()) {
            simpMessagingTemplate.convertAndSendToUser(player.getUsername(), destination, new GameStartDTO(
              createdGame.getId(),
              player.getRole()
            ));
        }

        long gameId = createdGame.getId();
        scheduledExecutorService.schedule(() -> {
            TransactionTemplate transactionTemplate = new TransactionTemplate(transactionManager);
            transactionTemplate.execute(status -> {
                startRound(gameId);
                return null;
            });
        }, 3, TimeUnit.SECONDS);
    }

    @Transactional
    public Optional<String> isGameFinished(Long gameId) {
        Game game = getGame(gameId);
        Map<String, Long> alivePlayersCountByRole = game.getPlayers().stream()
          .filter(Player::getAlive)
          .map(Player::getRole)
          .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
        Optional<Long> mafiaCount = Optional.ofNullable(alivePlayersCountByRole.get("mafia"));
        Optional<Long> citizenCount = Optional.ofNullable(alivePlayersCountByRole.get("citizen"));
        if(mafiaCount.orElse(0L) == 0) return Optional.of("city");
        if(citizenCount.orElse(0L) <= mafiaCount.orElse(0L)) return Optional.of("mafia");
        return Optional.empty();
    }

    @Transactional
    public void endGame(Long gameId, String winner) {
        Game game = getGame(gameId);

        Optional<Room> fetchedRoom = roomRepository.findByGameId(gameId);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exist.");
        Room room = fetchedRoom.get();

        room.setGame(null);
        game.setRoom(null);
        roomRepository.save(room);
        gameRepository.save(game);
    }

    @Transactional
    public void startRound(long gameId) {
        Optional<Game> fetchedGame = gameRepository.findById(gameId);
        if(fetchedGame.isEmpty()) throw new IllegalArgumentException("Game does not exist.");
        Game game = fetchedGame.get();

        Round createdRound = new Round();
        createdRound = roundRepository.save(createdRound);
        createdRound.setGame(game);
        game.getRounds().add(createdRound);
        gameRepository.save(game);
        createdRound = roundRepository.save(createdRound);

        startVotingCity(createdRound.getId());
    }

    @Transactional
    public void startVotingCity(long roundId) {
        Round round = getRound(roundId);

        Voting createdVoting = new Voting();
        createdVoting.setType("city");
        createdVoting = votingRepository.save(createdVoting);

        createdVoting.setRound(round);
        round.setVoting(createdVoting);
        round = roundRepository.save(round);
        createdVoting = votingRepository.save(createdVoting);

        Game game = round.getGame();
        String destination = "/queue/voting-start";
        for(Player player : game.getPlayers()) {
            List<String> usernamesToVote = null;
            if(player.getAlive()) {
                usernamesToVote = game.getPlayers().stream()
                  .filter(p -> p.getAlive() && !p.equals(player))
                  .map(Player::getUsername)
                  .toList();
            }
            simpMessagingTemplate.convertAndSendToUser(player.getUsername(), destination, new VotingStart(
              createdVoting.getId(),
              "city",
              player.getAlive(),
              usernamesToVote
            ));
        }
    }

    @Transactional
    public void startVotingMafia(long roundId) {
        Round round = getRound(roundId);

        Voting createdVoting = new Voting();
        createdVoting.setType("mafia");
        createdVoting = votingRepository.save(createdVoting);

        createdVoting.setRound(round);
        round.setVoting(createdVoting);
        round = roundRepository.save(round);
        createdVoting = votingRepository.save(createdVoting);

        Game game = round.getGame();
        String destination = "/queue/voting-start";
        for(Player player : game.getPlayers()) {
            List<String> usernamesToVote = null;
            if(player.getAlive() && player.getRole().equals("mafia")) {
                usernamesToVote = game.getPlayers().stream()
                  .filter(p -> p.getAlive() && p.getRole().equals("citizen"))
                  .map(Player::getUsername)
                  .toList();
            }
            simpMessagingTemplate.convertAndSendToUser(player.getUsername(), destination, new VotingStart(
              createdVoting.getId(),
              "mafia",
              player.getAlive(),
              usernamesToVote
            ));
        }
    }
}
