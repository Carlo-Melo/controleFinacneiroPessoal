import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';

class BudgetsPage extends StatefulWidget {
  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> with TickerProviderStateMixin {
  final limitCtrl = TextEditingController();
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
    limitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.attach_money, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Orçamentos",
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
            // Formulário para adicionar orçamento
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Color(0xFF1E1E1E),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: limitCtrl,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Limite",
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
                          if (selectedCategory != null && limitCtrl.text.isNotEmpty) {
                            provider.add(double.parse(limitCtrl.text), selectedCategory!);
                            limitCtrl.clear();
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

            // Lista de orçamentos
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
                        final b = provider.items[i];
                        return Card(
                          color: Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              "${b.category.name}: R\$ ${b.limitValue.toStringAsFixed(2)}",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => provider.remove(b.id),
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
        currentIndex: 2, // Orçamentos
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, "/");
              break;
            case 1:
              Navigator.pushReplacementNamed(context, "/categories");
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacementNamed(context, "/transactions");
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
