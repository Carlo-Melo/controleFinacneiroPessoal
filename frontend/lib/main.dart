import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/dio_client.dart';
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/user_provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/categories_page.dart';
import 'pages/budgets_page.dart';
import 'pages/transactions_page.dart';
import 'pages/users_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Dio e interceptores
  DioClient.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Controle Financeiro',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => RootPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
          '/categories': (context) => CategoriesPage(),
          '/budgets': (context) => BudgetsPage(),
          '/transactions': (context) => TransactionsPage(),
          '/users': (context) => UsersPage(),
        },
      ),
    );
  }
}

/// Página raiz que verifica se o usuário está autenticado
class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Mostra tela de loading enquanto verifica token
    if (auth.token == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
