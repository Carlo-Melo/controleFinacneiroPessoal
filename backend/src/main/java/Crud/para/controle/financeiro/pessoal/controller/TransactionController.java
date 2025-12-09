package Crud.para.controle.financeiro.pessoal.controller;

import Crud.para.controle.financeiro.pessoal.entity.Transaction;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.service.TransactionService;
import Crud.para.controle.financeiro.pessoal.service.UserService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/transactions")
public class TransactionController {

    private final TransactionService transactionService;
    private final UserService userService;

    public TransactionController(TransactionService transactionService, UserService userService) {
        this.transactionService = transactionService;
        this.userService = userService;
    }

    // pega o usuário autenticado via token JWT
    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return userService.findByUsername(authentication.getName());
    }

    @PostMapping
    public ResponseEntity<Transaction> create(@RequestBody Map<String, Object> body) {
        User user = getAuthenticatedUser();

        Transaction t = new Transaction();
        t.setDescription((String) body.get("description"));
        t.setAmount(Double.valueOf(body.get("amount").toString()));

        Long categoryId = Long.valueOf(body.get("categoryId").toString());

        return ResponseEntity.ok(transactionService.create(t, categoryId, user));
    }

    @GetMapping
    public ResponseEntity<List<Transaction>> list() {
        User user = getAuthenticatedUser();
        return ResponseEntity.ok(transactionService.findByUser(user));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Transaction> update(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body) {

        User user = getAuthenticatedUser();

        Transaction newT = new Transaction();
        newT.setDescription((String) body.get("description"));
        newT.setAmount(Double.valueOf(body.get("amount").toString()));

        if (body.containsKey("categoryId")) {
            Long categoryId = Long.valueOf(body.get("categoryId").toString());
            newT.setCategory(new Crud.para.controle.financeiro.pessoal.entity.Category(categoryId, null, user));
        }

        return ResponseEntity.ok(transactionService.update(id, newT, user));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> delete(@PathVariable Long id) {
        User user = getAuthenticatedUser();
        transactionService.delete(id, user);
        return ResponseEntity.ok(Map.of("message", "Transação removida com sucesso"));
    }
}
