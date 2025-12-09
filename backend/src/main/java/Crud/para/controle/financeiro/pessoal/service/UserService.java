package Crud.para.controle.financeiro.pessoal.service;

import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    private final UserRepository repository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository repository, PasswordEncoder passwordEncoder) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    // Criar usuário com senha criptografada
    public User create(User user) {

        // Impede cadastro duplicado
        if (repository.findByUsername(user.getUsername()).isPresent()) {
            throw new RuntimeException("Usuário já existe!");
        }

        // Criptografar a senha antes de salvar
        String senhaCriptografada = passwordEncoder.encode(user.getPassword());
        user.setPassword(senhaCriptografada);

        return repository.save(user);
    }

    // Buscar todos
    public List<User> findAll() {
        return repository.findAll();
    }

    // Buscar por ID
    public User findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado!"));
    }

    // Buscar por username
    public User findByUsername(String username) {
        return repository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado!"));
    }

    // Atualizar usuário
    public User update(Long id, User userAtualizado) {
        User u = findById(id);

        u.setUsername(userAtualizado.getUsername());

        // Apenas criptografa novamente se a senha mudar
        if (userAtualizado.getPassword() != null && !userAtualizado.getPassword().isEmpty()) {
            u.setPassword(passwordEncoder.encode(userAtualizado.getPassword()));
        }

        return repository.save(u);
    }

    // Deletar
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new RuntimeException("Usuário não encontrado!");
        }

        repository.deleteById(id);
    }
}
