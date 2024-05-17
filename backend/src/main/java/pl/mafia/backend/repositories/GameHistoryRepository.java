package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.GameHistory;

import java.util.List;
import java.util.Optional;

public interface GameHistoryRepository extends JpaRepository<GameHistory, Long> {
    Optional<List<GameHistory>> findByUsernameInPlayersUsernames(String username);
}
