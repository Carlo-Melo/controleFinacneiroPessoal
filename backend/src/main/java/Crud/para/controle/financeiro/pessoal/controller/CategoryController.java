package Crud.para.controle.financeiro.pessoal.controller;

import Crud.para.controle.financeiro.pessoal.entity.Category;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.service.CategoryService;
import Crud.para.controle.financeiro.pessoal.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/categories")
public class CategoryController {

    private final CategoryService categoryService;
    private final UserService userService;

    public CategoryController(CategoryService categoryService, UserService userService) {
        this.categoryService = categoryService;
        this.userService = userService;
    }

    // Método auxiliar para pegar usuário autenticado
    private User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        return userService.findByUsername(username);
    }

    @PostMapping
    public ResponseEntity<Category> create(@RequestBody Map<String, String> body) {
        User user = getAuthenticatedUser();
        Category category = new Category();
        category.setName(body.get("name"));
        return ResponseEntity.ok(categoryService.create(category, user));
    }

    @GetMapping
    public ResponseEntity<List<Category>> list() {
        User user = getAuthenticatedUser();
        return ResponseEntity.ok(categoryService.findByUser(user));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Category> update(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        User user = getAuthenticatedUser();
        return ResponseEntity.ok(categoryService.update(id, body.get("name"), user));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> delete(@PathVariable Long id) {
        User user = getAuthenticatedUser();
        categoryService.delete(id, user);
        return ResponseEntity.ok(Map.of("message", "Categoria removida com sucesso"));
    }
}
