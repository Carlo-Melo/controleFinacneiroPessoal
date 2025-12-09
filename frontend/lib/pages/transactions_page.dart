import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';

class TransactionsPage extends StatelessWidget {
  final descCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  int? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Transações")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(controller: descCtrl, decoration: InputDecoration(labelText: "Descrição")),
                TextField(controller: amountCtrl, decoration: InputDecoration(labelText: "Valor")),
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
                    if (selectedCategory != null &&
                        descCtrl.text.isNotEmpty &&
                        amountCtrl.text.isNotEmpty) {
                      provider.add(descCtrl.text, double.parse(amountCtrl.text), selectedCategory!);
                      descCtrl.clear();
                      amountCtrl.clear();
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
                      final t = provider.items[i];
                      return ListTile(
                        title: Text("${t.description}: R\$ ${t.amount}"),
                        subtitle: Text(t.category.name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => provider.remove(t.id),
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
