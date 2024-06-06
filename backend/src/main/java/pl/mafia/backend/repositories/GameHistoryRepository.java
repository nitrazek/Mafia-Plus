package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.GameHistory;


public interface GameHistoryRepository extends JpaRepository<GameHistory, Long> {
}
