import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';

class TransactionsPage extends StatefulWidget {
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TickerProviderStateMixin {
  final descCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  int? selectedCategory;

  late AnimationController _formController;
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _formController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _listController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _formController.forward();
    _listController.forward();
  }

  @override
  void dispose() {
    _formController.dispose();
    _listController.dispose();
    descCtrl.dispose();
    amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.receipt_long, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Transações",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 8,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.shade700, Colors.blueAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulário para adicionar transações
            AnimatedBuilder(
              animation: _formController,
              builder: (context, child) {
                return Opacity(
                  opacity: _formController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _formController.value)),
                    child: child,
                  ),
                );
              },
              child: Card(
                color: Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: descCtrl,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Descrição",
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.text_snippet, color: Colors.blueAccent),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: amountCtrl,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Valor",
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.attach_money, color: Colors.greenAccent),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      DropdownButton<int>(
                        dropdownColor: Color(0xFF1E1E1E),
                        hint: Text("Selecione a Categoria", style: TextStyle(color: Colors.grey[400])),
                        value: selectedCategory,
                        onChanged: (v) {
                          setState(() {
                            selectedCategory = v;
                          });
                        },
                        items: categoryProvider.items
                            .map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name, style: TextStyle(color: Colors.white)),
                                ))
                            .toList(),
                        isExpanded: true,
                        iconEnabledColor: Colors.greenAccent,
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedCategory != null &&
                              descCtrl.text.isNotEmpty &&
                              amountCtrl.text.isNotEmpty) {
                            provider.add(
                              descCtrl.text,
                              double.parse(amountCtrl.text),
                              selectedCategory!,
                            );
                            descCtrl.clear();
                            amountCtrl.clear();
                            setState(() {
                              selectedCategory = null;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Adicionar", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Lista de transações
            AnimatedBuilder(
              animation: _listController,
              builder: (context, child) {
                return Opacity(
                  opacity: _listController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _listController.value)),
                    child: child,
                  ),
                );
              },
              child: provider.loading
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : ListView.builder(
                      itemCount: provider.items.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        final t = provider.items[i];
                        return Card(
                          color: Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              "${t.description}: R\$ ${t.amount.toStringAsFixed(2)}",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              t.category.name,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => provider.remove(t.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Transações
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, "/");
              break;
            case 1:
              Navigator.pushReplacementNamed(context, "/categories");
              break;
            case 2:
              Navigator.pushReplacementNamed(context, "/budgets");
              break;
            case 3:
              break;
            case 4:
              Navigator.pushReplacementNamed(context, "/users");
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF1E1E1E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categorias"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Orçamentos"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Transações"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuários"),
        ],
      ),
    );
  }
}
