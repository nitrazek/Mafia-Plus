package pl.mafia.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import pl.mafia.backend.models.db.*;
import pl.mafia.backend.repositories.MinigameRepository;
import pl.mafia.backend.repositories.MinigameScoreRepository;
import pl.mafia.backend.repositories.RoundRepository;

import java.util.Optional;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Component
public class MinigameService {
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

  @Transactional
  private Minigame getMinigame(Long minigameId) {
    Optional<Minigame> fetchedMinigame = minigameRepository.findById(minigameId);
    if (fetchedMinigame.isEmpty())
      throw new IllegalArgumentException("Minigame does not exists.");
    return fetchedMinigame.get();
  }

  @Transactional
  public boolean finishMinigame(Long minigameId, String username, int score) {
    Minigame minigame = getMinigame(minigameId);
    Account account = accountService.getAccount(username);

    MinigameScore minigameScore = new MinigameScore();
    minigameScore.setScore(score);
    minigameScore.setAccount(account);
    minigameScore.setMinigame(minigame);
    minigame.getMinigameScores().add(minigameScore);
    minigameScoreRepository.save(minigameScore);
    minigame = minigameRepository.save(minigame);

    return minigame.getMinigameScores().size() >= minigame.getRound().getGame().getPlayers().stream()
      .filter(Player::getAlive).toList().size();
  }

  @Transactional
  public void summarizeMinigame(Long minigameId) {
    Minigame minigame = getMinigame(minigameId);
    Round round = minigame.getRound();
    round = roundRepository.save(round);

    //Tutaj wybrać najlepszego i przyznać nagrodę czy coś takiego

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
