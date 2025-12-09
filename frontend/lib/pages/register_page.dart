import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Registrar")),
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
                      await auth.register(userCtrl.text, passCtrl.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Usuário registrado com sucesso")));
                      Navigator.pop(context);
                    },
              child: auth.loading ? CircularProgressIndicator() : Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
