package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import pl.mafia.backend.models.enums.RewardType;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Reward")
@Data
public class Reward {
    @Id
    @ToString.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "reward_sequence")
    @SequenceGenerator(name = "reward_sequence", sequenceName = "REWARD_SEQ", allocationSize = 1)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RewardType title;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_round")
    private Round round;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne
    @JoinColumn(name = "id_account")
    private Account account;
}
