package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "GameHistory")
@Data
public class GameHistory {
    @Id
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "game_history_sequence")
    @SequenceGenerator(name = "game_history_sequence", sequenceName = "GAME_HIS_SEQ", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private Timestamp createTimestamp;

    @Column(nullable = false)
    private int roundsPlayed;

    @Column(nullable = false)
    private List<String> playersUsernames = new ArrayList<>();

    @Column(nullable = false)
    private String winnerRole;
}
