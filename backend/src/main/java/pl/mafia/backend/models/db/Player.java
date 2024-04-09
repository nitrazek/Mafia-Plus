package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Entity
@Table(name = "Player")
@Data
public class Player {
  @Id
  @Column(unique = true, nullable = false)
  private String username;

  @ToString.Exclude
  @EqualsAndHashCode.Exclude
  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "id_game")
  private Game game;

  @Column(nullable = false)
  private String role;

  @Column(nullable = false)
  private Boolean alive;
}
