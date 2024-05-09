package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.MinigameScore;

public interface MinigameScoreRepository extends JpaRepository<MinigameScore, Long> {
}
