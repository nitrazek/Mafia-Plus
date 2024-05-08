package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Entity
@Table(name = "MinigameScore")
@Data
public class MinigameScore {
  @Id
  @ToString.Exclude
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "minigame_score_sequence")
  @SequenceGenerator(name = "minigame_score_sequence", sequenceName = "MINIGAME_SCORE_SEQ", allocationSize = 1)
  private Long id;

  @ToString.Exclude
  @EqualsAndHashCode.Exclude
  @ManyToOne
  @JoinColumn(name = "id_minigame")
  private Minigame minigame;

  @ToString.Exclude
  @EqualsAndHashCode.Exclude
  @ManyToOne
  @JoinColumn(name = "id_account")
  private Account account;

  @Column(nullable = false)
  private int score;
}
