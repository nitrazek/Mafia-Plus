package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.Game;
import pl.mafia.backend.models.db.Player;

import java.util.Optional;

public interface PlayerRepository extends JpaRepository<Player, Long> {
  Optional<Player> findByUsername(String username);
}
