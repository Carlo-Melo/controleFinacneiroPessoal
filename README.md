# 💰 FinanceApp – Controle Financeiro Pessoal (Full Stack)

O **FinanceApp** é um sistema **full stack** de controle financeiro pessoal, composto por um **backend em Spring Boot (API REST)** e um **frontend mobile em Flutter**.

O objetivo do projeto é permitir que usuários gerenciem **gastos**, **categorias**, **orçamentos** e acompanhem sua vida financeira de forma **segura**, **visual** e **intuitiva**.

---

## 🧩 Arquitetura do Projeto

```
FinanceApp
├── backend/   → API REST (Spring Boot)
└── frontend/  → Aplicativo Mobile (Flutter)
```

* **Backend**: responsável por regras de negócio, autenticação, segurança e persistência de dados
* **Frontend**: aplicativo mobile que consome a API e exibe dashboards, gráficos e funcionalidades ao usuário

---

## 🚀 Funcionalidades

### 👤 Usuários

* Cadastro de usuários
* Login e logout
* Senhas criptografadas com **BCrypt**
* Autenticação via **Spring Security**
* Cada usuário acessa apenas seus próprios dados

### 📂 Categorias

* Criar categorias personalizadas
* Listar categorias do usuário autenticado
* Atualizar e excluir apenas categorias próprias

### 💸 Transações

* Registrar receitas e despesas
* Associar transações a categorias
* Listar transações do usuário
* Atualizar e excluir apenas transações próprias

### 📊 Orçamentos

* Criar orçamentos por categoria
* Definir limites de gastos
* Listar, atualizar e remover orçamentos do usuário

### 📈 Dashboard Financeiro (Frontend)

* Saldo total
* Total gasto
* Total de orçamentos
* Gráfico de pizza (gastos por categoria)
* Gráfico de linha (evolução das transações)

---

## 🔐 Segurança

### Backend

* **Spring Security**
* Implementação de `UserDetailsService`
* Senhas armazenadas de forma segura
* Validação de propriedade dos dados (User → Category / Transaction / Budget)

### Frontend

* Controle de sessão via `AuthProvider`
* Logout seguro
* Acesso apenas a endpoints autenticados

---

## 🛠️ Tecnologias Utilizadas

### Backend (API REST)

* **Java 17+**
* **Spring Boot**
* **Spring Data JPA**
* **Spring Security**
* **Hibernate**
* **Maven**
* **Banco de dados relacional** (H2 / MySQL / PostgreSQL)

### Frontend (Mobile)

* **Flutter (Dart)**
* **Provider** (Gerenciamento de estado)
* **fl_chart** (Gráficos)
* **Material Design**
* **Dark Mode**

---

## 📁 Estrutura dos Projetos

### Backend

```
backend/
├── entity
│   ├── User
│   ├── Category
│   ├── Transaction
│   └── Budget
├── repository
├── service
├── controller
└── security
```

### Frontend

```
frontend/
├── lib/
│   ├── pages/
│   ├── providers/
│   ├── models/
│   ├── services/
│   └── main.dart
```

---

## ▶️ Como Executar o Projeto

### 🔹 Backend

**Pré-requisitos**:

* Java 17+
* Maven
* Banco de dados configurado em `application.properties`

```bash
# Entrar no backend
cd backend

# Executar a aplicação
mvn spring-boot:run
```

API disponível em:

```
http://localhost:8080
```

---

### 🔹 Frontend

**Pré-requisitos**:

* Flutter SDK
* Emulador ou dispositivo físico
* Backend em execução

```bash
# Entrar no frontend
cd frontend

# Instalar dependências
flutter pub get

# Executar o app
flutter run
```

> ⚠️ Configure corretamente a **URL da API** nos serviços HTTP do app.

---

## 🎯 Diferenciais do Projeto

* Arquitetura **full stack bem definida**
* Separação clara de responsabilidades
* Segurança e isolamento de dados por usuário
* Dashboard visual com gráficos
* Código organizado e escalável
* Ideal para **portfólio**, **TCC** ou estudo de **Spring Boot + Flutter**

---

## 📌 Possíveis Evoluções

* Autenticação com JWT
* Swagger/OpenAPI
* Deploy com Docker
* Notificações de limite de orçamento
* Relatórios mensais em PDF

---

## 📄 Licença

Projeto de uso livre para fins educacionais e pessoais.

---

