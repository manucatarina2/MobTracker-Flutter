import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPIs
            Row(
              children: [
                _KpiCard(
                  title: 'Total Relatos',
                  value: '1,234',
                  icon: Icons.report,
                  color: AppColors.verdeMedio,
                ),
                const SizedBox(width: 12),
                _KpiCard(
                  title: 'Usuários',
                  value: '567',
                  icon: Icons.people,
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _KpiCard(
                  title: 'Horas Perdidas',
                  value: '2,345',
                  icon: Icons.timer,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 12),
                _KpiCard(
                  title: 'Linhas Problemáticas',
                  value: '12',
                  icon: Icons.directions_bus,
                  color: AppColors.error,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Relatos por Bairro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: [
                    _makeBarData(0, 85, 'Centro'),
                    _makeBarData(1, 62, 'Paulista'),
                    _makeBarData(2, 43, 'Jardins'),
                    _makeBarData(3, 28, 'Vila Mariana'),
                    _makeBarData(4, 56, 'Moema'),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Centro', 'Paulista', 'Jardins', 'Vila M.', 'Moema'];
                          if (value.toInt() >= titles.length) return const Text('');
                          return Text(titles[value.toInt()], style: const TextStyle(fontSize: 10));
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Média de Atraso por Linha',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 60,
                  barGroups: [
                    _makeBarData(0, 25, '101', Colors.red),
                    _makeBarData(1, 18, '205', Colors.orange),
                    _makeBarData(2, 12, '303', Colors.yellow),
                    _makeBarData(3, 8, '412', Colors.green),
                    _makeBarData(4, 15, '530', Colors.orange),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['101', '205', '303', '412', '530'];
                          if (value.toInt() >= titles.length) return const Text('');
                          return Text(titles[value.toInt()], style: const TextStyle(fontSize: 12));
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Evolução Mensal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 200,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 45),
                        FlSpot(1, 62),
                        FlSpot(2, 78),
                        FlSpot(3, 55),
                        FlSpot(4, 92),
                        FlSpot(5, 120),
                      ],
                      isCurved: true,
                      color: AppColors.verdeMedio,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.verdeMedio.withOpacity(0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'];
                          if (value.toInt() >= months.length) return const Text('');
                          return Text(months[value.toInt()], style: const TextStyle(fontSize: 12));
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarData(int x, double y, String title, [Color? color]) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color ?? AppColors.verdeMedio,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}