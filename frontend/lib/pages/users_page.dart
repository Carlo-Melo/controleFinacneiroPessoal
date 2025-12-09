import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UsersPage extends StatelessWidget {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Usuários")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(controller: usernameCtrl, decoration: InputDecoration(labelText: "Usuário")),
                TextField(controller: passwordCtrl, decoration: InputDecoration(labelText: "Senha")),
                ElevatedButton(
                  onPressed: () {
                    provider.add(usernameCtrl.text, passwordCtrl.text);
                    usernameCtrl.clear();
                    passwordCtrl.clear();
                  },
                  child: Text("Adicionar"),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: provider.items.length,
                    itemBuilder: (_, i) {
                      final u = provider.items[i];
                      return ListTile(
                        title: Text(u.username),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => provider.remove(u.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
