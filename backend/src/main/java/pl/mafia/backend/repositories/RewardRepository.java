package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.Reward;

public interface RewardRepository extends JpaRepository<Reward, Long> {
}
