package Crud.para.controle.financeiro.pessoal.service;

import Crud.para.controle.financeiro.pessoal.entity.Transaction;
import Crud.para.controle.financeiro.pessoal.entity.Category;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.repository.TransactionRepository;
import Crud.para.controle.financeiro.pessoal.repository.CategoryRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class TransactionService {

    @Autowired
    private TransactionRepository repository;

    @Autowired
    private CategoryRepository categoryRepository;

    // Criar transação associada ao usuário autenticado
    public Transaction create(Transaction transaction, Long categoryId, User user) {

        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada."));

        transaction.setUser(user);
        transaction.setCategory(category);

        if (transaction.getDate() == null) {
            transaction.setDate(LocalDate.now());
        }

        return repository.save(transaction);
    }

    // Buscar transações do usuário autenticado
    public List<Transaction> findByUser(User user) {
        return repository.findByUserId(user.getId());
    }

    // Atualizar somente se pertencer ao usuário
    public Transaction update(Long id, Transaction newData, User user) {
        Transaction transaction = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Transação não encontrada."));

        if (!transaction.getUser().equals(user)) {
            throw new RuntimeException("Você não tem permissão para alterar esta transação.");
        }

        transaction.setDescription(newData.getDescription());
        transaction.setAmount(newData.getAmount());
        transaction.setDate(newData.getDate() != null ? newData.getDate() : transaction.getDate());

        if (newData.getCategory() != null && newData.getCategory().getId() != null) {
            Category category = categoryRepository.findById(newData.getCategory().getId())
                    .orElseThrow(() -> new RuntimeException("Categoria não encontrada."));
            transaction.setCategory(category);
        }

        return repository.save(transaction);
    }

    public void delete(Long id, User user) {
        Transaction transaction = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Transação não encontrada."));

        if (!transaction.getUser().equals(user)) {
            throw new RuntimeException("Você não tem permissão para excluir esta transação.");
        }

        repository.delete(transaction);
    }
}
