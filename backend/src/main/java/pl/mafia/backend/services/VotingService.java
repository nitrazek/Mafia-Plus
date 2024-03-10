package pl.mafia.backend.services;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Vote;
import pl.mafia.backend.models.db.Voting;
import pl.mafia.backend.repositories.AccountRepository;
import pl.mafia.backend.repositories.GameRepository;
import pl.mafia.backend.repositories.VoteRepository;
import pl.mafia.backend.repositories.VotingRepository;

import java.util.*;
import java.util.stream.Collectors;

@Component
public class VotingService {
    @Autowired
    private VotingRepository votingRepository;
    @Autowired
    private VoteRepository voteRepository;
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Transactional
    public boolean saveVote(Long votingId, Long voterId, Long votedId) {
        Optional<Voting> fetchedVoting = votingRepository.findById(votingId);
        if (fetchedVoting.isEmpty())
            throw new IllegalArgumentException("Voting does not exists.");

        Optional<Account> fetchedVoter = accountRepository.findById(voterId);
        if (fetchedVoter.isEmpty())
            throw new IllegalArgumentException("Voter does not exist");

        Optional<Account> fetchedVoted = accountRepository.findById(votedId);
        if (fetchedVoted.isEmpty())
            throw new IllegalArgumentException("Voted does not exist");

        Voting voting = fetchedVoting.get();
        Account voter = fetchedVoter.get();
        Account voted = fetchedVoted.get();
        Vote vote = new Vote();
        vote.setVoting(voting);
        vote.setVoter(voter);
        vote.setVoted(voted);
        vote = voteRepository.save(vote);

        voting.getVotes().add(vote);
        votingRepository.save(voting);
        return voting.getVotes().size() >= voter.getRoom().getAccounts().size();
    }

    @Transactional
    public void endVoting(Long votingId) {
        Optional<Voting> fetchedVoting = votingRepository.findById(votingId);
        if (fetchedVoting.isEmpty())
            throw new IllegalArgumentException("Voting does not exists.");

        Voting voting = fetchedVoting.get();
        Map<Account, Long> voteCounts = voting.getVotes().stream()
                .map(Vote::getVoted)
                .collect(Collectors.groupingBy(account -> account, Collectors.counting()));

        long maxVotes = voteCounts.values().stream().mapToLong(v -> v).max().orElse(0);

        List<Account> mostVotedAccounts = voteCounts.entrySet().stream()
                .filter(entry -> entry.getValue() == maxVotes)
                .map(Map.Entry::getKey)
                .toList();

        if (mostVotedAccounts.size() > 1)
            voting.setAccount(mostVotedAccounts.get(new Random().nextInt(mostVotedAccounts.size())));
        else
            voting.setAccount(mostVotedAccounts.isEmpty() ? null : mostVotedAccounts.get(0));

        voting = votingRepository.save(voting);
        //Do ustalenia co wysyłamy
        messagingTemplate.convertAndSend("/topic/" + voting.getAccount().getRoom().getId() + "/voting-summary", voting.getAccount());
    }
}
