package pl.mafia.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import pl.mafia.backend.models.db.*;
import pl.mafia.backend.models.dto.MinigameSummary;
import pl.mafia.backend.repositories.GameRepository;
import pl.mafia.backend.repositories.MinigameRepository;
import pl.mafia.backend.repositories.MinigameScoreRepository;
import pl.mafia.backend.repositories.RoundRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Component
public class MinigameService {
  @Autowired
  private GameRepository gameRepository;
  @Autowired
  private MinigameRepository minigameRepository;
  @Autowired
  private MinigameScoreRepository minigameScoreRepository;
  @Autowired
  private RoundRepository roundRepository;
  @Autowired
  private AccountService accountService;
  @Autowired
  private GameService gameService;
  @Autowired
  private ScheduledExecutorService scheduledExecutorService;
  @Autowired
  private PlatformTransactionManager transactionManager;
  @Autowired
  private SimpMessagingTemplate messagingTemplate;

  @Transactional
  private Minigame getMinigame(Long minigameId) {
    Optional<Minigame> fetchedMinigame = minigameRepository.findById(minigameId);
    if (fetchedMinigame.isEmpty())
      throw new IllegalArgumentException("Minigame does not exists.");
    return fetchedMinigame.get();
  }

  @Transactional
  public boolean finishMinigame(Long minigameId, String username, int score) {
    synchronized(this) {
      Minigame minigame = getMinigame(minigameId);
      Account account = accountService.getAccount(username);

      MinigameScore minigameScore = new MinigameScore();
      minigameScore.setScore(score);
      minigameScore.setAccount(account);
      minigameScore.setMinigame(minigame);
      minigame.getMinigameScores().add(minigameScore);
      minigameScoreRepository.save(minigameScore);
      minigame = minigameRepository.save(minigame);

      Round round = minigame.getRound();
      round = roundRepository.save(round);
      Game game = round.getGame();
      game = gameRepository.save(game);
      return minigame.getMinigameScores().size() >= game.getPlayers().stream()
        .filter(Player::getAlive).toList().size();
    }
  }

  @Transactional
  public void summarizeMinigame(Long minigameId) {
    Minigame minigame = getMinigame(minigameId);

    Round round = minigame.getRound();
    round = roundRepository.save(round);

    //Tutaj wybrać najlepszego i przyznać nagrodę czy coś takiego
    int highestScore = 0;
    List<Account> winners = new ArrayList<>();
    Account winner = null;

    for (MinigameScore minigameScore : minigame.getMinigameScores()) {
      if (minigameScore.getScore() > highestScore) {
        highestScore = minigameScore.getScore();
        winners.clear();
        winners.add(minigameScore.getAccount());
      } else if (minigameScore.getScore() == highestScore) {
        winners.add(minigameScore.getAccount());
      }
    }
    if (winners.size() > 1) {
      winner = winners.get(new Random().nextInt(winners.size()));
    }
    else{
      winner = winners.get(0);
    }


    messagingTemplate.convertAndSend("/topic/"+round.getId() + "/minigame-summary",new MinigameSummary(highestScore));

    Round finalRound = round;
    scheduledExecutorService.schedule(() -> {
      TransactionTemplate transactionTemplate = new TransactionTemplate(transactionManager);
      transactionTemplate.execute(status -> {
        gameService.startVotingCity(finalRound.getId());
        return null;
      });
    }, 3, TimeUnit.SECONDS);
  }
}
