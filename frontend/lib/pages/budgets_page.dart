import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';

class BudgetsPage extends StatelessWidget {
  final limitCtrl = TextEditingController();
  int? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Orçamentos")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(controller: limitCtrl, decoration: InputDecoration(labelText: "Limite")),
                DropdownButton<int>(
                  hint: Text("Categoria"),
                  value: selectedCategory,
                  onChanged: (v) => selectedCategory = v,
                  items: categoryProvider.items
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCategory != null && limitCtrl.text.isNotEmpty) {
                      provider.add(double.parse(limitCtrl.text), selectedCategory!);
                      limitCtrl.clear();
                    }
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
                      final b = provider.items[i];
                      return ListTile(
                        title: Text("${b.category.name}: R\$ ${b.limitValue}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => provider.remove(b.id),
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
