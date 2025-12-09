package Crud.para.controle.financeiro.pessoal.controller;

import Crud.para.controle.financeiro.pessoal.entity.Budget;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.service.BudgetService;
import Crud.para.controle.financeiro.pessoal.service.UserService;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/budgets")
public class BudgetController {

    private final BudgetService budgetService;
    private final UserService userService;

    public BudgetController(BudgetService budgetService, UserService userService) {
        this.budgetService = budgetService;
        this.userService = userService;
    }

    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return userService.findByUsername(authentication.getName());
    }

    @PostMapping
    public ResponseEntity<Budget> create(@RequestBody Map<String, Object> body) {
        User user = getAuthenticatedUser();

        Double limitValue = Double.valueOf(body.get("limitValue").toString());
        Long categoryId = Long.valueOf(body.get("categoryId").toString());

        return ResponseEntity.ok(budgetService.create(limitValue, categoryId, user));
    }

    @GetMapping
    public ResponseEntity<List<Budget>> list() {
        return ResponseEntity.ok(budgetService.findByUser(getAuthenticatedUser()));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Budget> update(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body) {

        User user = getAuthenticatedUser();

        Double limitValue = Double.valueOf(body.get("limitValue").toString());
        Long categoryId = body.containsKey("categoryId")
                ? Long.valueOf(body.get("categoryId").toString())
                : null;

        return ResponseEntity.ok(budgetService.update(id, limitValue, categoryId, user));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> delete(@PathVariable Long id) {
        User user = getAuthenticatedUser();
        budgetService.delete(id, user);
        return ResponseEntity.ok(Map.of("message", "Orçamento removido com sucesso"));
    }
}
