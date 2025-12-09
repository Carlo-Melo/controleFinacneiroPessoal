import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _summaryController;
  late AnimationController _pieController;
  late AnimationController _statsController;
  late AnimationController _lineChartController;

  @override
  void initState() {
    super.initState();
    _summaryController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _pieController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _statsController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _lineChartController = AnimationController(vsync: this, duration: Duration(milliseconds: 1400));

    _summaryController.forward();
    _pieController.forward();
    _statsController.forward();
    _lineChartController.forward();
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _pieController.dispose();
    _statsController.dispose();
    _lineChartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    double totalBudget = budgetProvider.items.fold(0, (sum, b) => sum + b.limitValue);
    double totalSpent = transactionProvider.items.fold(0, (sum, t) => sum + t.amount);
    double saldo = totalBudget - totalSpent;

    // Gráfico por categoria
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

    // Gráfico de linha (evolução das transações)
    List<FlSpot> lineSpots = [];
    for (int idx = 0; idx < transactionProvider.items.length; idx++) {
      lineSpots.add(FlSpot((idx + 1).toDouble(), transactionProvider.items[idx].amount));
    }
    if (lineSpots.isEmpty) lineSpots.add(FlSpot(0, 0));

    double maxY = lineSpots.map((e) => e.y).fold(0, (a, b) => a > b ? a : b);
    maxY = maxY == 0 ? 1 : maxY * 1.2;
    double maxX = lineSpots.length > 0 ? lineSpots.length.toDouble() : 1;
    double horizontalInterval = maxY / 5;

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.white),
            SizedBox(width: 8),
            Text("Perfil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
            icon: Icon(Icons.logout),
            tooltip: "Sair",
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Cabeçalho
            Card(
              color: Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Usuário", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 4),
                        Text("Perfil geral", style: TextStyle(color: Colors.grey[400])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Resumo financeiro
            AnimatedBuilder(
              animation: _summaryController,
              builder: (context, child) {
                return Opacity(
                  opacity: _summaryController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _summaryController.value)),
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
                      Text("Resumo Financeiro", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ResumoItem(label: "Saldo", value: saldo, color: Colors.blueAccent),
                          _ResumoItem(label: "Gastos", value: totalSpent, color: Colors.redAccent),
                          _ResumoItem(label: "Orçamentos", value: totalBudget, color: Colors.greenAccent),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Gráfico de pizza por categoria
            AnimatedBuilder(
              animation: _pieController,
              builder: (context, child) {
                return Opacity(
                  opacity: _pieController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _pieController.value)),
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
                      Text("Gastos por Categoria", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 12),
                      Container(
                        height: 200,
                        child: pieSections.isNotEmpty
                            ? PieChart(PieChartData(sections: pieSections, sectionsSpace: 2, centerSpaceRadius: 30))
                            : Center(child: Text("Sem transações", style: TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Gráfico de linha (evolução)
            AnimatedBuilder(
              animation: _lineChartController,
              builder: (context, child) {
                return Opacity(
                  opacity: _lineChartController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _lineChartController.value)),
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
                      Text("Evolução das Transações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                            leftTitles: AxisTitles(sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (v, meta) => Text(v.toStringAsFixed(0), style: TextStyle(color: Colors.white, fontSize: 10)),
                            )),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: (v, meta) => Text("${v.toInt()}º", style: TextStyle(color: Colors.white, fontSize: 10)),
                            )),
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
            SizedBox(height: 20),

            // Estatísticas gerais
            AnimatedBuilder(
              animation: _statsController,
              builder: (context, child) {
                return Opacity(
                  opacity: _statsController.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _statsController.value)),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatsItem(label: "Transações", value: transactionProvider.items.length),
                      _StatsItem(label: "Categorias", value: categoryProvider.items.length),
                      _StatsItem(label: "Orçamentos", value: budgetProvider.items.length),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Perfil
        onTap: (index) {
          switch (index) {
            case 0: Navigator.pushReplacementNamed(context, "/"); break;
            case 1: Navigator.pushReplacementNamed(context, "/categories"); break;
            case 2: Navigator.pushReplacementNamed(context, "/budgets"); break;
            case 3: Navigator.pushReplacementNamed(context, "/transactions"); break;
            case 4: break;
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

// Widget resumo financeiro
class _ResumoItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ResumoItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 4),
        Text("R\$ ${value.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

// Widget estatísticas
class _StatsItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatsItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 4),
        Text(value.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
