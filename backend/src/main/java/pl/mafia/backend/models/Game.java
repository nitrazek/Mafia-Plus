package pl.mafia.backend.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.sql.Timestamp;
import java.util.List;

@Entity
@Table(name = "Game")
@Data
public class Game {
    @Id
    @ToString.Exclude
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Timestamp createTimestamp;

    @ManyToMany(mappedBy = "games")
    private List<Account> accounts;
}
