package Crud.para.controle.financeiro.pessoal.service;

import Crud.para.controle.financeiro.pessoal.entity.Budget;
import Crud.para.controle.financeiro.pessoal.entity.Category;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.repository.BudgetRepository;
import Crud.para.controle.financeiro.pessoal.repository.CategoryRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BudgetService {

    @Autowired
    private BudgetRepository repository;

    @Autowired
    private CategoryRepository categoryRepository;

    public Budget create(Double limitValue, Long categoryId, User user) {

        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada."));

        Budget budget = new Budget();
        budget.setLimitValue(limitValue);
        budget.setCategory(category);
        budget.setUser(user);

        return repository.save(budget);
    }

    public List<Budget> findByUser(User user) {
        return repository.findByUserId(user.getId());
    }

    public Budget update(Long id, Double limitValue, Long categoryId, User user) {
        Budget b = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Budget não encontrado."));

        if (!b.getUser().equals(user)) {
            throw new RuntimeException("Você não tem permissão para alterar este orçamento.");
        }

        b.setLimitValue(limitValue);

        if (categoryId != null) {
            Category category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Categoria não encontrada."));
            b.setCategory(category);
        }

        return repository.save(b);
    }

    public void delete(Long id, User user) {
        Budget b = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Budget não encontrado."));

        if (!b.getUser().equals(user)) {
            throw new RuntimeException("Você não tem permissão para excluir este orçamento.");
        }

        repository.delete(b);
    }
}
