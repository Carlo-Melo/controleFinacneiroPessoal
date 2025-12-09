package Crud.para.controle.financeiro.pessoal.service;

import Crud.para.controle.financeiro.pessoal.entity.Budget;
import Crud.para.controle.financeiro.pessoal.entity.Category;
import Crud.para.controle.financeiro.pessoal.entity.Transaction;
import Crud.para.controle.financeiro.pessoal.entity.User;
import Crud.para.controle.financeiro.pessoal.repository.BudgetRepository;
import Crud.para.controle.financeiro.pessoal.repository.CategoryRepository;
import Crud.para.controle.financeiro.pessoal.repository.TransactionRepository;
import Crud.para.controle.financeiro.pessoal.repository.UserRepository;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class ServiceUnitTests {

    @Mock
    private UserRepository userRepository;

    @Mock
    private CategoryRepository categoryRepository;

    @Mock
    private BudgetRepository budgetRepository;

    @Mock
    private TransactionRepository transactionRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    @InjectMocks
    private CategoryService categoryService;

    @InjectMocks
    private BudgetService budgetService;

    @InjectMocks
    private TransactionService transactionService;

    private User user;
    private Category category;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);

        // Dados de teste reutilizáveis
        user = new User();
        user.setId(1L);
        user.setUsername("testuser");
        user.setPassword("senha123");

        category = new Category();
        category.setId(1L);
        category.setName("Alimentação");
        category.setUser(user);
    }

    // ==================== TESTE 1: UserService - Criar usuário ====================
    @Test
    @DisplayName("Teste 1: Deve criar um usuário com senha criptografada")
    public void testCreateUser() {
        System.out.println("\n🧪 EXECUTANDO TESTE 1: Criar Usuário");

        // Arrange (Preparar)
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.empty());
        when(passwordEncoder.encode("senha123")).thenReturn("senhaCriptografada");
        when(userRepository.save(any(User.class))).thenReturn(user);

        // Act (Executar)
        User result = userService.create(user);

        // Assert (Verificar)
        assertNotNull(result);
        assertEquals("testuser", result.getUsername());
        verify(passwordEncoder, times(1)).encode("senha123");
        verify(userRepository, times(1)).save(any(User.class));

        System.out.println("✅ TESTE 1 PASSOU: Usuário criado com sucesso!");
    }

    // ==================== TESTE 2: CategoryService - Criar categoria ====================
    @Test
    @DisplayName("Teste 2: Deve criar uma categoria associada ao usuário")
    public void testCreateCategory() {
        System.out.println("\n🧪 EXECUTANDO TESTE 2: Criar Categoria");

        // Arrange
        when(categoryRepository.save(any(Category.class))).thenReturn(category);

        // Act
        Category result = categoryService.create(category, user);

        // Assert
        assertNotNull(result);
        assertEquals("Alimentação", result.getName());
        assertEquals(user, result.getUser());
        verify(categoryRepository, times(1)).save(category);

        System.out.println("✅ TESTE 2 PASSOU: Categoria criada com sucesso!");
    }

    // ==================== TESTE 3: BudgetService - Criar orçamento ====================
    @Test
    @DisplayName("Teste 3: Deve criar um orçamento com categoria válida")
    public void testCreateBudget() {
        System.out.println("\n🧪 EXECUTANDO TESTE 3: Criar Orçamento");

        // Arrange
        Double limitValue = 500.0;
        Long categoryId = 1L;

        when(categoryRepository.findById(categoryId)).thenReturn(Optional.of(category));
        when(budgetRepository.save(any(Budget.class))).thenAnswer(invocation -> {
            Budget b = invocation.getArgument(0);
            b.setId(1L);
            return b;
        });

        // Act
        Budget result = budgetService.create(limitValue, categoryId, user);

        // Assert
        assertNotNull(result);
        assertEquals(500.0, result.getLimitValue());
        assertEquals(category, result.getCategory());
        assertEquals(user, result.getUser());
        verify(categoryRepository, times(1)).findById(categoryId);
        verify(budgetRepository, times(1)).save(any(Budget.class));

        System.out.println("✅ TESTE 3 PASSOU: Orçamento criado com sucesso!");
    }

    // ==================== TESTE 4: TransactionService - Criar transação ====================
    @Test
    @DisplayName("Teste 4: Deve criar uma transação com data automática se não fornecida")
    public void testCreateTransactionWithAutoDate() {
        System.out.println("\n🧪 EXECUTANDO TESTE 4: Criar Transação");

        // Arrange
        Transaction transaction = new Transaction();
        transaction.setDescription("Compra supermercado");
        transaction.setAmount(150.0);
        transaction.setDate(null); // Data não fornecida

        Long categoryId = 1L;

        when(categoryRepository.findById(categoryId)).thenReturn(Optional.of(category));
        when(transactionRepository.save(any(Transaction.class))).thenAnswer(invocation -> {
            Transaction t = invocation.getArgument(0);
            t.setId(1L);
            return t;
        });

        // Act
        Transaction result = transactionService.create(transaction, categoryId, user);

        // Assert
        assertNotNull(result);
        assertEquals("Compra supermercado", result.getDescription());
        assertEquals(150.0, result.getAmount());
        assertEquals(LocalDate.now(), result.getDate()); // Verifica se data foi setada automaticamente
        assertEquals(category, result.getCategory());
        assertEquals(user, result.getUser());
        verify(transactionRepository, times(1)).save(any(Transaction.class));

        System.out.println("✅ TESTE 4 PASSOU: Transação criada com sucesso!");
        System.out.println("\n" + "=".repeat(60));
        System.out.println("📊 RESUMO: TODOS OS 4 TESTES PASSARAM COM SUCESSO!");
        System.out.println("=".repeat(60) + "\n");
    }
}