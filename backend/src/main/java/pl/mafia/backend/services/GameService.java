package pl.mafia.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import pl.mafia.backend.models.db.*;
import pl.mafia.backend.models.dto.*;
import pl.mafia.backend.models.enums.MinigameType;
import pl.mafia.backend.repositories.*;
import pl.mafia.backend.websockets.WebSocketListener;

import java.awt.*;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.*;
import java.util.List;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class GameService {
    private final Random random = new Random();
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private GameRepository gameRepository;
    @Autowired
    private GameHistoryRepository gameHistoryRepository;
    @Autowired
    private MinigameRepository minigameRepository;
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

    private Player createNewPlayer(String username, Game game, String role) {
        Player newPlayer = new Player();
        newPlayer.setUsername(username);
        newPlayer.setGame(game);
        newPlayer.setRole(role);
        newPlayer.setAlive(true);
        return newPlayer;
    }

    private String getRole(int mafiaCount, int playerCount) {
        int mafiaMax = (playerCount / 4) + (playerCount % 4 >= 2 ? 1 : 0);
        return mafiaCount < mafiaMax ? "mafia" : "citizen"; //Warunek do dostosowania gdy będą ustawienia
    }

    private MinigameType getMinigameType(Game game) {
        int minigamesPlayed = game.getMinigamesPlayed();
        String binaryString = Integer.toBinaryString(minigamesPlayed);
        binaryString = String.format("%" + MinigameType.values().length + "s", binaryString).replace(' ', '0');

        if (!binaryString.contains("0"))
            binaryString = new StringBuilder().repeat(0, binaryString.length()).toString();

        int zeroCount = binaryString.replace("1", "").length();
        int randomZeroNumber = new Random().nextInt(zeroCount);
        int zeroIndex = binaryString.indexOf('0');
        for (int i = 0; i < randomZeroNumber; i++) {
            zeroIndex = binaryString.indexOf('0', zeroIndex + 1);
        }

        StringBuilder newBinaryStringBuilder = new StringBuilder(binaryString);
        newBinaryStringBuilder.setCharAt(zeroIndex, '1');
        binaryString = newBinaryStringBuilder.toString();
        minigamesPlayed = Integer.parseInt(binaryString, 2);
        game.setMinigamesPlayed(minigamesPlayed);
        gameRepository.save(game);

        return MinigameType.valueOf(zeroIndex);
    }

    @Transactional
    public Game getGame(Long gameId) {
        Optional<Game> fetchedGame = gameRepository.findById(gameId);
        if(fetchedGame.isEmpty())
            throw new IllegalArgumentException("Game does not exists.");
        return fetchedGame.get();
    }

    @Transactional
    public Round getRound(Long roundId) {
        Optional<Round> fetchedRound = roundRepository.findById(roundId);
        if(fetchedRound.isEmpty())
            throw new IllegalArgumentException("Round does not exists.");
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
        createdGame.setMinigamesPlayed(0);
        createdGame = gameRepository.save(createdGame);

        List<Account> accountList = room.getAccounts();

        if (accountList.size() < 4)
            throw new IllegalAccessException("Not enough players.");

        Collections.shuffle(accountList);

        int mafiaCount = 0;
        for(Account account : accountList) {
            String role = getRole(mafiaCount, accountList.size());
            if(role.equals("mafia")) mafiaCount++;
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
    public void endGame(Long gameId, String winnerRole) {
        Game game = getGame(gameId);

        Optional<Room> fetchedRoom = roomRepository.findByGameId(gameId);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exist.");
        Room room = fetchedRoom.get();

        GameHistory gameHistory = new GameHistory();
        gameHistory.setCreateTimestamp(game.getCreateTimestamp());
        gameHistory.setRoundsPlayed(game.getRounds().size());
        gameHistory.setPlayersUsernames(game.getPlayers().stream().map(Player::getUsername).toList());
        gameHistory.setWinnerRole(winnerRole);
        gameHistoryRepository.save(gameHistory);

        room.setGame(null);
        game.setRoom(null);
        roomRepository.save(room);
        gameRepository.save(game);

        String destination = "/topic/" + room.getId() + "/game-end";
        simpMessagingTemplate.convertAndSend(destination, new GameEnd(winnerRole));
    }

    @Transactional
    public void startRound(long gameId) {
        Game game = getGame(gameId);

        Round createdRound = new Round();
        createdRound = roundRepository.save(createdRound);
        createdRound.setGame(game);
        game.getRounds().add(createdRound);
        gameRepository.save(game);
        createdRound = roundRepository.save(createdRound);

        startMinigame(createdRound.getId());
    }

    @Transactional
    public void startMinigame(long roundId) {
        Round round = getRound(roundId);

        Minigame minigame = new Minigame();
        minigame.setType(getMinigameType(round.getGame()));
        round = getRound(roundId);
        minigame.setRound(round);
        minigame = minigameRepository.save(minigame);

        round = roundRepository.save(round);
        Game game = round.getGame();
        game = gameRepository.save(game);
        Room room = game.getRoom();
        room = roomRepository.save(room);

        String destination = "/topic/" + room.getId() + "/minigame-start";
        simpMessagingTemplate.convertAndSend(destination, new MinigameStart(minigame));
    }

    @Transactional
    public void startVotingCity(long roundId) {
        Round round = getRound(roundId);

        Voting createdVoting = new Voting();
        createdVoting.setType("city");
        createdVoting = votingRepository.save(createdVoting);
        round.getVotings().add(createdVoting);
        round = roundRepository.save(round);
        createdVoting.setRound(round);
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
        round = roundRepository.save(round);

        Voting createdVoting = new Voting();
        createdVoting.setType("mafia");
        createdVoting = votingRepository.save(createdVoting);
        createdVoting.setRound(round);
        round.getVotings().add(createdVoting);
        createdVoting = votingRepository.save(createdVoting);
        round = roundRepository.save(round);

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

    @Transactional
    public List<GameHistory> getHistory(String username) {
        List<GameHistory> gameHistoryList = gameHistoryRepository.findAll();
        return gameHistoryList.stream()
                .filter(history -> history.getPlayersUsernames().contains(username))
                .collect(Collectors.toList());
    }
}
