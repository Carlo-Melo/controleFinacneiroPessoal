package Crud.para.controle.financeiro.pessoal.repository;

import Crud.para.controle.financeiro.pessoal.entity.Category;
import Crud.para.controle.financeiro.pessoal.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    // Buscar todas as categorias de um usuário
    List<Category> findByUser(User user);
}
