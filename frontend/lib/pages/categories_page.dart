import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class CategoriesPage extends StatelessWidget {
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Categorias")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Nome"))),
                ElevatedButton(
                  onPressed: () {
                    provider.add(nameCtrl.text);
                    nameCtrl.clear();
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
                      final c = provider.items[i];
                      return ListTile(
                        title: Text(c.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                nameCtrl.text = c.name;
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Editar Categoria"),
                                    content: TextField(controller: nameCtrl),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          provider.update(c.id, nameCtrl.text);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Salvar"),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => provider.remove(c.id),
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
