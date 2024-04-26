package pl.mafia.backend.services;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.context.SecurityContextHolderStrategy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.repositories.AccountRepository;

import java.util.List;
import java.util.Optional;

@Component
public class AccountService {
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private UserDetailsManager userDetailsManager;
    @Autowired
    private SecurityContextRepository securityContextRepository;
    @Autowired
    private SecurityContextLogoutHandler securityContextLogoutHandler;

    @Transactional(readOnly = true)
    public Account getAccount(String username) {
        Optional<Account> fetchedAccount = accountRepository.findByUsername(username);
        if(fetchedAccount.isEmpty())
            throw new IllegalArgumentException("Account does not exist.");
        return fetchedAccount.get();
    }

    public AccountDetails login(AccountDetails loginRequest, HttpServletRequest request, HttpServletResponse response) {
        Authentication authenticationRequest =
                UsernamePasswordAuthenticationToken.unauthenticated(loginRequest.getUsername(), loginRequest.getPassword());
        Authentication authenticationResponse = authenticationManager.authenticate(authenticationRequest);
        SecurityContextHolderStrategy securityContextHolderStrategy = SecurityContextHolder.getContextHolderStrategy();
        SecurityContext context = securityContextHolderStrategy.createEmptyContext();
        context.setAuthentication(authenticationResponse);
        securityContextHolderStrategy.setContext(context);
        securityContextRepository.saveContext(context, request, response);

        Account account = getAccount(loginRequest.getUsername());
        return new AccountDetails(account);
    }

    public AccountDetails register(AccountDetails registerRequest, HttpServletRequest request, HttpServletResponse response) {
        userDetailsManager.createUser(registerRequest);
        return login(registerRequest, request, response);
    }

    public void logout(Authentication authentication, HttpServletRequest request, HttpServletResponse response) {
        securityContextLogoutHandler.logout(request, response, authentication);
    }

    @Transactional
    public AccountDetails changeUsername(String prevUsername, String newUsername) {
        Account account = getAccount(prevUsername);
        account.setUsername(newUsername);
        Account updatedAccount = accountRepository.save(account);
        return new AccountDetails(updatedAccount);
    }

    @Transactional
    public AccountDetails changePassword(String username, String previousPassword, String newPassword) {
        Account account = getAccount(username);

        if (!BCrypt.checkpw(previousPassword, account.getPassword()))
            throw new BadCredentialsException("Wrong password.");

        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        account.setPassword(hashedPassword);
        Account updatedAccount = accountRepository.save(account);
        return new AccountDetails(updatedAccount);
    }
}
