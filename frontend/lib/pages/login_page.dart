import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: userCtrl, decoration: InputDecoration(labelText: "Usuário")),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: "Senha"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: auth.loading
                  ? null
                  : () async {
                      await auth.login(userCtrl.text, passCtrl.text);
                      if (auth.isAuthenticated) {
                        Navigator.pushReplacementNamed(context, "/home");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login falhou")));
                      }
                    },
              child: auth.loading ? CircularProgressIndicator() : Text("Entrar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              child: Text("Registrar"),
            )
          ],
        ),
      ),
    );
  }
}
