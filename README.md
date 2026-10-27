# FinanceApp — Controle Financeiro Pessoal

O FinanceApp é um protótipo acadêmico de controle financeiro pessoal. A interface, desenvolvida em Flutter, se comunica com uma API REST em Java e Spring Boot. O objetivo é oferecer uma forma visual de organizar categorias, transações e limites de orçamento.

## Funcionalidades

- Cadastro, login e saída de usuário; autenticação da API com token JWT e senhas protegidas com BCrypt.
- Cadastro, listagem, edição e exclusão de categorias.
- Cadastro e listagem de transações vinculadas a categorias, com operações de atualização e exclusão disponíveis na API.
- Cadastro, listagem e exclusão de orçamentos na interface; a API também oferece atualização.
- Painel com resumo dos limites e transações, gráfico de distribuição por categoria e gráfico dos valores das transações.

## Tecnologias e organização

| Parte | Tecnologias | Diretório |
| --- | --- | --- |
| Interface | Flutter, Dart, Provider, Dio e fl_chart | frontend/ |
| API | Java 21, Spring Boot, Spring Security, Spring Data JPA e Maven | backend/ |
| Dados | H2 em memória, configurado para demonstração local | backend/src/main/resources/application.properties |

## Executar localmente

É necessário ter **Java 21** e o **Flutter SDK** instalados e disponíveis no terminal. O projeto inclui o Maven Wrapper, que baixa a versão necessária do Maven no primeiro uso. O download das dependências exige acesso à internet.

### 1. Iniciar a API

Em um terminal, a partir da raiz do repositório:

    cd backend
    .\mvnw.cmd spring-boot:run

Em Linux ou macOS, use `./mvnw spring-boot:run` no diretório `backend`. Aguarde a mensagem de inicialização; a API ficará disponível em `http://localhost:8080`.

### 2. Iniciar a interface web

Em outro terminal, a partir da raiz do repositório:

    cd frontend
    flutter pub get
    flutter run -d web-server --web-hostname localhost --web-port 3000 --no-pub

Acesse [http://localhost:3000](http://localhost:3000) no navegador. Cadastre um usuário na tela inicial e faça login. Para encerrar, interrompa os processos nos terminais correspondentes.

No Windows, se o Flutter informar que não consegue criar links simbólicos para plugins, habilite o Modo de Desenvolvedor do Windows e execute `flutter pub get` novamente.

## Estado e limitações do protótipo

- O H2 está configurado em memória: os dados são perdidos quando a API é encerrada ou reiniciada.
- A interface usa `http://localhost:8080` como endereço fixo da API. Esse endereço atende à demonstração no mesmo computador; outros dispositivos ou ambientes exigem ajuste de configuração.
- O indicador chamado “Saldo” no painel é a soma dos limites de orçamento menos a soma dos valores das transações. O protótipo não distingue receitas e despesas como tipos separados.
- O gráfico de linhas mostra valores na ordem em que as transações são recebidas, sem agrupamento por período.
- A aplicação requer revisão de segurança, controles de acesso, configuração de segredos e persistência antes de ser usada com dados reais ou disponibilizada em produção.
- Integração bancária, notificações automáticas, exportação de relatórios e publicação nas lojas de aplicativos não fazem parte da implementação atual.

## Testes

O backend contém testes de serviços e de inicialização do contexto Spring. Para executá-los com Java 21, no diretório `backend`:

    .\mvnw.cmd test

No Linux ou macOS, use `./mvnw test`. O diretório `frontend/test` contém um teste gerado pelo modelo inicial do Flutter, que ainda precisa ser adaptado ao aplicativo.

## Repositório

[github.com/Carlo-Melo/controleFinacneiroPessoal](https://github.com/Carlo-Melo/controleFinacneiroPessoal)
