package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import pl.mafia.backend.models.enums.MinigameType;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Minigame")
@Data
public class Minigame {
    @Id
    @ToString.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "minigame_sequence")
    @SequenceGenerator(name = "minigame_sequence", sequenceName = "MINIGAME_SEQ", allocationSize = 1)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MinigameType type;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_round")
    private Round round;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "minigame", fetch = FetchType.LAZY)
    private List<MinigameScore> minigameScores = new ArrayList<>();
}
