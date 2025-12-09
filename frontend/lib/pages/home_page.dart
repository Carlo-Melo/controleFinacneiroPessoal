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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _cardsController;
  late AnimationController _chartsController;
  late AnimationController _transactionsController;

  @override
  void initState() {
    super.initState();

    _cardsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _chartsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _transactionsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _cardsController.forward();
    _chartsController.forward();
    _transactionsController.forward();

    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    categoryProvider.load();
    budgetProvider.load();
    transactionProvider.load();
  }

  @override
  void dispose() {
    _cardsController.dispose();
    _chartsController.dispose();
    _transactionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    double totalBudget = budgetProvider.items.fold(0, (sum, b) => sum + b.limitValue);
    double totalSpent = transactionProvider.items.fold(0, (sum, t) => sum + t.amount);
    double saldo = totalBudget - totalSpent;

    // Gráfico de pizza
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

    // Gráfico de linhas
    List<FlSpot> lineSpots = [];
    if (transactionProvider.items.isNotEmpty) {
      for (int idx = 0; idx < transactionProvider.items.length; idx++) {
        lineSpots.add(FlSpot((idx + 1).toDouble(), transactionProvider.items[idx].amount));
      }
    } else {
      lineSpots.add(FlSpot(0, 0));
    }

    double maxY = lineSpots.map((e) => e.y).fold(0, (a, b) => a > b ? a : b);
    maxY = maxY == 0 ? 1 : maxY * 1.2;
    double maxX = lineSpots.length > 0 ? lineSpots.length.toDouble() : 1;
    double horizontalInterval = maxY / 5;

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "FinanceApp",
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
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            tooltip: "Notificações",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Nenhuma notificação por enquanto")),
              );
            },
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo financeiro
            AnimatedBuilder(
              animation: _cardsController,
              builder: (context, child) {
                return Opacity(
                  opacity: _cardsController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _cardsController.value)),
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                height: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ResumoCard(
                      label: "Saldo",
                      value: saldo,
                      icon: Icons.account_balance_wallet,
                      color: Colors.blueAccent,
                      progress: totalBudget > 0 ? saldo / totalBudget : 0,
                    ),
                    _ResumoCard(
                      label: "Gastos",
                      value: totalSpent,
                      icon: Icons.arrow_circle_down,
                      color: Colors.redAccent,
                      progress: totalBudget > 0 ? totalSpent / totalBudget : 0,
                    ),
                    _ResumoCard(
                      label: "Orçamentos",
                      value: totalBudget,
                      icon: Icons.insert_chart,
                      color: Colors.greenAccent,
                      progress: 1.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Gráficos
            AnimatedBuilder(
              animation: _chartsController,
              builder: (context, child) {
                return Opacity(
                  opacity: _chartsController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _chartsController.value)),
                    child: child,
                  ),
                );
              },
              child: Row(
                children: [
                  // Pizza
                  Expanded(
                    child: Card(
                      color: Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Gastos por Categoria",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: 200,
                              child: pieSections.isNotEmpty
                                  ? PieChart(PieChartData(
                                      sections: pieSections,
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 30,
                                    ))
                                  : Center(child: Text("Sem transações", style: TextStyle(color: Colors.white))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Linhas
                  Expanded(
                    child: Card(
                      color: Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Evolução das Transações",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: 200,
                              child: LineChart(LineChartData(
                                minX: 0,
                                maxX: maxX,
                                minY: 0,
                                maxY: maxY,
                                gridData: FlGridData(show: true, horizontalInterval: horizontalInterval),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (v, meta) {
                                        return Text(v.toStringAsFixed(0), style: TextStyle(color: Colors.white, fontSize: 10));
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28,
                                      interval: 1,
                                      getTitlesWidget: (v, meta) {
                                        return Text("${v.toInt()}º", style: TextStyle(color: Colors.white, fontSize: 10));
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: lineSpots,
                                    isCurved: true,
                                    color: Colors.blueAccent,
                                    barWidth: 3,
                                    dotData: FlDotData(show: true),
                                  )
                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Últimas transações
            AnimatedBuilder(
              animation: _transactionsController,
              builder: (context, child) {
                return Opacity(
                  opacity: _transactionsController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _transactionsController.value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Últimas Transações",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  transactionProvider.items.isEmpty
                      ? Center(child: Text("Nenhuma transação registrada", style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: transactionProvider.items.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final t = transactionProvider.items[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: Color(0xFF2A2A2A),
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: Icon(Icons.monetization_on, color: Colors.blueAccent),
                                title: Text(t.description,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                subtitle: Text("Categoria: ${t.category.name}", style: TextStyle(color: Colors.grey[400])),
                                trailing: Text(
                                  "R\$ ${t.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: t.amount > 0 ? Colors.greenAccent : Colors.redAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Grid de navegação
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
                  label: "Perfil",
                  color: Colors.redAccent,
                  onTap: () => Navigator.pushNamed(context, "/users"),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() {
                _selectedIndex = 0;
              });
              break;
            case 1:
              Navigator.pushNamed(context, "/categories");
              break;
            case 2:
              Navigator.pushNamed(context, "/budgets");
              break;
            case 3:
              Navigator.pushNamed(context, "/transactions");
              break;
            case 4:
              Navigator.pushNamed(context, "/users");
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}

// Card de resumo financeiro
class _ResumoCard extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;
  final double progress;

  const _ResumoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Color(0xFF1E1E1E),
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 8),
              Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              SizedBox(height: 4),
              Text(
                "R\$ ${value.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[800],
                  color: color,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Card de navegação
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
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 4))],
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
