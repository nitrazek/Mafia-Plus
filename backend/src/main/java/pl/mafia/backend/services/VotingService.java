package pl.mafia.backend.services;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import pl.mafia.backend.models.db.*;
import pl.mafia.backend.models.dto.VotingEnd;
import pl.mafia.backend.models.dto.VotingResult;
import pl.mafia.backend.models.dto.VotingSummary;
import pl.mafia.backend.repositories.*;

import java.util.*;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Component
public class VotingService {
    private Random random = new Random();
    @Autowired
    private RoundRepository roundRepository;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private GameRepository gameRepository;
    @Autowired
    private VotingRepository votingRepository;
    @Autowired
    private VoteRepository voteRepository;
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private PlayerRepository playerRepository;
    @Autowired
    private AccountService accountService;
    @Autowired
    private GameService gameService;
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    @Autowired
    private ScheduledExecutorService scheduledExecutorService;
    @Autowired
    private PlatformTransactionManager transactionManager;

    @Transactional
    public Voting getVoting(long votingId) {
        Optional<Voting> fetchedVoting = votingRepository.findById(votingId);
        if (fetchedVoting.isEmpty())
            throw new IllegalArgumentException("Voting does not exists.");
        return fetchedVoting.get();
    }

    @Transactional
    public boolean saveVote(Long votingId, String voterUsername, String votedUsername) {
        Optional<Voting> fetchedVoting = votingRepository.findById(votingId);
        if (fetchedVoting.isEmpty())
            throw new IllegalArgumentException("Voting does not exists.");

        Optional<Account> fetchedVoter = accountRepository.findByUsername(voterUsername);
        if (fetchedVoter.isEmpty())
            throw new IllegalArgumentException("Voter does not exist");

        Optional<Account> fetchedVoted = accountRepository.findByUsername(votedUsername);
        if (fetchedVoted.isEmpty())
            throw new IllegalArgumentException("Voted does not exist");

        if (voterUsername.equals(votedUsername))
            throw new IllegalArgumentException("Voter and voted can not be the same user");

        Voting voting = fetchedVoting.get();
        Account voter = fetchedVoter.get();
        Account voted = fetchedVoted.get();
        Vote vote = new Vote();
        vote.setVoting(voting);
        vote.setVoter(voter);
        vote.setVoted(voted);
        vote = voteRepository.save(vote);

        voting.getVotes().add(vote);
        votingRepository.save(voting);
        return voting.getVotes().size() >= voter.getRoom().getAccounts().size();
    }

    public VotingSummary calculateVotingSummary(Voting voting) {
      Map<Account, Long> voteCounts = voting.getVotes().stream()
        .map(Vote::getVoted)
        .collect(Collectors.groupingBy(account -> account, Collectors.counting()));
      List<VotingResult> votingResults = voteCounts.entrySet().stream()
        .map(entry -> new VotingResult(entry.getKey().getUsername(), entry.getValue()))
        .toList();
      return new VotingSummary(votingResults);
    }

    public String selectVotedPlayer(VotingSummary votingSummary) {
      Long maxVoteCount = votingSummary.votingResults().stream()
        .map(VotingResult::voteCount)
        .max(Long::compare)
        .orElse(0L);
      List<String> maxVotedPlayers = votingSummary.votingResults().stream()
        .filter(result -> Objects.equals(result.voteCount(), maxVoteCount))
        .map(VotingResult::username)
        .toList();
      return maxVotedPlayers.get(random.nextInt(maxVotedPlayers.size()));
    }

    @Transactional
    public void summarizeVoting(long votingId) {
        Voting voting = getVoting(votingId);
        VotingSummary votingSummary = calculateVotingSummary(voting);

        Round round = voting.getRound();
        round = roundRepository.save(round);
        Game game = round.getGame();
        game = gameRepository.save(game);
        Room room = game.getRoom();
        room = roomRepository.save(room);
        messagingTemplate.convertAndSend("/topic/" + room.getId() + "/voting-summary", votingSummary);

        scheduledExecutorService.schedule(() -> {
            TransactionTemplate transactionTemplate = new TransactionTemplate(transactionManager);
            transactionTemplate.execute(status -> {
                endVoting(votingId);
                return null;
            });
        }, 5, TimeUnit.SECONDS);
    }

    @Transactional
    public void endVoting(Long votingId) {
        Voting voting = getVoting(votingId);
        VotingSummary votingSummary = calculateVotingSummary(voting);
        String votedPlayerUsername = selectVotedPlayer(votingSummary);

        Account account = accountService.getAccount(votedPlayerUsername);
        voting.setAccount(account);
        voting = votingRepository.save(voting);

        Player player = gameService.getPlayer(votedPlayerUsername);
        player.setAlive(false);
        playerRepository.save(player);

        Round round = voting.getRound();
        round = roundRepository.save(round);
        Game game = round.getGame();
        game = gameRepository.save(game);
        Room room = game.getRoom();
        room = roomRepository.save(room);
        messagingTemplate.convertAndSend("/topic/" + room.getId() + "/voting-end", new VotingEnd(voting.getType(), votedPlayerUsername));

        Voting finalVoting = voting;
        Round finalRound = round;
        Game finalGame = game;
        scheduledExecutorService.schedule(() -> {
          TransactionTemplate transactionTemplate = new TransactionTemplate(transactionManager);
          transactionTemplate.execute(status -> {
            long gameId = finalGame.getId();
            long roundId = finalRound.getId();
            Optional<String> optWinner = gameService.isGameFinished(gameId);
            optWinner.ifPresentOrElse(
              winner -> gameService.endGame(gameId, winner),
              () -> {
                if(Objects.equals(finalVoting.getType(), "city")) {
                  gameService.startVotingMafia(roundId);
                } else {
                  gameService.startRound(gameId);
                }
              }
            );
            return null;
          });
        }, 3, TimeUnit.SECONDS);
    }
}
