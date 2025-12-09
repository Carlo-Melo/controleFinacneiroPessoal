package Crud.para.controle.financeiro.pessoal.service;

import Crud.para.controle.financeiro.pessoal.entity.Category;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.repository.CategoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    private final CategoryRepository repository;

    public CategoryService(CategoryRepository repository) {
        this.repository = repository;
    }

    // Criar categoria associada ao usuário
    public Category create(Category category, User user) {
        category.setUser(user);
        return repository.save(category);
    }

    // Buscar categorias de um usuário
    public List<Category> findByUser(User user) {
        return repository.findByUser(user);
    }

    // Atualizar nome da categoria se pertencer ao usuário
    public Category update(Long id, String name, User user) {
        Category category = getCategoryIfOwnedByUser(id, user);
        category.setName(name);
        return repository.save(category);
    }

    // Deletar categoria se pertencer ao usuário
    public void delete(Long id, User user) {
        Category category = getCategoryIfOwnedByUser(id, user);
        repository.delete(category);
    }

    // Método auxiliar para verificar propriedade da categoria
    private Category getCategoryIfOwnedByUser(Long id, User user) {
        Category category = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));
        if (!category.getUser().equals(user)) {
            throw new RuntimeException("Você não tem permissão para acessar esta categoria");
        }
        return category;
    }
}
