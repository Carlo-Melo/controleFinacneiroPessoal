package Crud.para.controle.financeiro.pessoal.controller;

import Crud.para.controle.financeiro.pessoal.dto.UserCreateDTO;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.service.UserService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/users")
public class UserController {

    private final UserService service;

    public UserController(UserService service) {
        this.service = service;
    }

    // REGISTER (criar usuário com senha criptografada)
    @PostMapping("/register")
    public User register(@Valid @RequestBody UserCreateDTO dto) {

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword()); // será criptografada no service

        return service.create(user);
    }

    // Listar todos
    @GetMapping
    public List<User> findAll() {
        return service.findAll();
    }

    // Buscar por ID
    @GetMapping("/{id}")
    public User findById(@PathVariable Long id) {
        return service.findById(id);
    }

    // Atualizar usuário
    @PutMapping("/{id}")
    public User update(@PathVariable Long id, @RequestBody UserCreateDTO dto) {

        User u = new User();
        u.setUsername(dto.getUsername());
        u.setPassword(dto.getPassword());

        return service.update(id, u);
    }

    // Deletar
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}
