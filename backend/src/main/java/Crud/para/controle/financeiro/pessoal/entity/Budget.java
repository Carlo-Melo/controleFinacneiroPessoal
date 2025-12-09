package Crud.para.controle.financeiro.pessoal.entity;

import jakarta.persistence.*;

@Entity
public class Budget {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Double limitValue;

    @ManyToOne
    private Category category;

    @ManyToOne
    private User user;

    // ----- Construtores -----
    public Budget() {
    }

    public Budget(Long id, Double limitValue, Category category, User user) {
        this.id = id;
        this.limitValue = limitValue;
        this.category = category;
        this.user = user;
    }

    // ----- Getters e Setters -----
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Double getLimitValue() {
        return limitValue;
    }

    public void setLimitValue(Double limitValue) {
        this.limitValue = limitValue;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    // ----- equals e hashCode (opcional, mas recomendado para JPA) -----
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Budget)) return false;
        Budget budget = (Budget) o;
        return id != null && id.equals(budget.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }

    // ----- toString (opcional) -----
    @Override
    public String toString() {
        return "Budget{" +
                "id=" + id +
                ", limitValue=" + limitValue +
                ", category=" + category +
                ", user=" + user +
                '}';
    }
}
