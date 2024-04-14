package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.Minigame;

public interface MinigameRepository extends JpaRepository<Minigame, Long> {
}
