import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with TickerProviderStateMixin {
  final nameCtrl = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.category, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Categorias",
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
            // Formulário para adicionar categoria
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameCtrl,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Nome da Categoria",
                            labelStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.label, color: Colors.orangeAccent),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[700]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orangeAccent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (nameCtrl.text.isNotEmpty) {
                            provider.add(nameCtrl.text);
                            nameCtrl.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
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

            // Lista de categorias
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
                        final c = provider.items[i];
                        return Card(
                          color: Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(c.name, style: TextStyle(color: Colors.white)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () {
                                    nameCtrl.text = c.name;
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: Color(0xFF1E1E1E),
                                        title: Text("Editar Categoria", style: TextStyle(color: Colors.white)),
                                        content: TextField(
                                          controller: nameCtrl,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey[700]!),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.blueAccent),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              provider.update(c.id, nameCtrl.text);
                                              Navigator.pop(context);
                                            },
                                            child: Text("Salvar", style: TextStyle(color: Colors.blueAccent)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => provider.remove(c.id),
                                ),
                              ],
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
        currentIndex: 1, // Categoria é o segundo item
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, "/");
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, "/budgets");
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
