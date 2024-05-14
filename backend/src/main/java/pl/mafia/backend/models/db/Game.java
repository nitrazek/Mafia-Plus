package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Game")
@Data
public class Game {
    @Id
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "game_sequence")
    @SequenceGenerator(name = "game_sequence", sequenceName = "GAME_SEQ", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private Timestamp createTimestamp;

    @Column(nullable = false)
    private int minigamesPlayed;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne(mappedBy = "game", fetch = FetchType.LAZY)
    private Room room;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "game", fetch = FetchType.LAZY)
    private List<Round> rounds = new ArrayList<>();

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @ManyToMany(mappedBy = "games", fetch = FetchType.LAZY)
    private List<Account> accounts = new ArrayList<>();

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "game", fetch = FetchType.LAZY)
    private List<Player> players = new ArrayList<>();
}
