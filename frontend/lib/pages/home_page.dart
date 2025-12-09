import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Carrega os dados
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    categoryProvider.load();
    budgetProvider.load();
    transactionProvider.load();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Calcula resumo financeiro
    double totalBudget = budgetProvider.items.fold(0, (sum, b) => sum + b.limitValue);
    double totalSpent = transactionProvider.items.fold(0, (sum, t) => sum + t.amount);
    double saldo = totalBudget - totalSpent;

    // Dados para gráfico por categoria
    Map<String, double> categoryTotals = {};
    for (var t in transactionProvider.items) {
      String cat = t.category.name;
      categoryTotals[cat] = (categoryTotals[cat] ?? 0) + t.amount;
    }

    List<PieChartSectionData> pieSections = [];
    int i = 0;
    categoryTotals.forEach((key, value) {
      final color = Colors.primaries[i % Colors.primaries.length];
      pieSections.add(PieChartSectionData(
        value: value,
        color: color,
        title: '${value.toStringAsFixed(0)}',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ));
      i++;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Sair",
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Resumo financeiro
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Resumo Financeiro", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ResumoItem(label: "Saldo", value: saldo),
                        _ResumoItem(label: "Gastos", value: totalSpent),
                        _ResumoItem(label: "Orçamentos", value: totalBudget),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Gráfico de pizza por categoria
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Gastos por Categoria", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Container(
                      height: 200,
                      child: pieSections.isNotEmpty
                          ? PieChart(
                              PieChartData(
                                sections: pieSections,
                                sectionsSpace: 2,
                                centerSpaceRadius: 30,
                              ),
                            )
                          : Center(child: Text("Sem transações")),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Grid de cards para navegação
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                DashboardCard(
                  icon: Icons.category,
                  label: "Categorias",
                  color: Colors.orangeAccent,
                  onTap: () => Navigator.pushNamed(context, "/categories"),
                ),
                DashboardCard(
                  icon: Icons.attach_money,
                  label: "Orçamentos",
                  color: Colors.greenAccent,
                  onTap: () => Navigator.pushNamed(context, "/budgets"),
                ),
                DashboardCard(
                  icon: Icons.receipt_long,
                  label: "Transações",
                  color: Colors.purpleAccent,
                  onTap: () => Navigator.pushNamed(context, "/transactions"),
                ),
                DashboardCard(
                  icon: Icons.person,
                  label: "Usuários",
                  color: Colors.redAccent,
                  onTap: () => Navigator.pushNamed(context, "/users"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget resumo financeiro
class _ResumoItem extends StatelessWidget {
  final String label;
  final double value;

  const _ResumoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 4),
        Text("R\$ ${value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Widget do card
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
