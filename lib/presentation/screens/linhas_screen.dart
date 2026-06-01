import 'package:flutter/material.dart';
import '../../data/models/line_model.dart';
import '../../data/repositories/line_repository.dart';
import 'line_details_screen.dart';

// Color palette
const primaryDark = Color(0xFF0B3D2E);
const primaryGreen = Color(0xFF1F7A5C);
const background = Color(0xFFF7F6F3);
const warning = Color(0xFFB54708);
const warningBorder = Color(0xFFFFD8A8);
const warningBackground = Color(0xFFFFFBF5);

class LinhasScreen extends StatelessWidget {
  const LinhasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          // App Bar Superior
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xCC0B3D2E),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Linhas",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ],
                      ),
                      const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Body with data
          Expanded(
            child: FutureBuilder<List<LineModel>>(
              future: LineRepository().getAllLines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final lines = snapshot.data ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seletor de Cidade (static for now)
                      Center(
                        child: Container(
                          width: 220,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            border: Border.all(color: const Color(0xFFE2E2E2)),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.location_on_outlined, color: primaryDark, size: 20),
                              SizedBox(width: 8),
                              Text("Caçapava – SP", style: TextStyle(color: primaryDark, fontWeight: FontWeight.w500, fontSize: 14)),
                              SizedBox(width: 8),
                              Icon(Icons.keyboard_arrow_down, color: primaryDark, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Título Principal
                      const Text(
                        "Linhas de Ônibus",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDark),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Itinerários, avaliações e relatos colaborativos da comunidade",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),
                      // Card de Alerta
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: warningBackground,
                          border: Border.all(color: warningBorder),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(Icons.warning_amber_rounded, color: warning, size: 24),
                                SizedBox(width: 10),
                                Expanded(child: Text(
                                  "Caçapava tem o pior transporte público do Vale?",
                                  style: TextStyle(color: warning, fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
                                )),
                                Icon(Icons.chevron_right, color: warning, size: 20),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Relatos acumulados até 2025 apontam problemas sérios. Confira:",
                              style: TextStyle(color: warning, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 20),
                            // Grid de Problemas (kept as before)
                            Column(
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: const [
                                      Expanded(
                                        child: _ProblemCard(
                                          icon: Icons.directions_bus,
                                          title: "Qualidade dos Ônibus",
                                          desc: "Ônibus precários, sucateados, com bancos soltos, cheiro forte e quebras frequentes.",
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: _ProblemCard(
                                          icon: Icons.security,
                                          title: "Segurança",
                                          desc: "Problemas mecânicos e quebra de componentes em veículos escolares preocupam pais.",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: const [
                                      Expanded(
                                        child: _ProblemCard(
                                          icon: Icons.settings,
                                          title: "Operação",
                                          desc: "Falta de cobradores, motoristas dirigindo e cobrando ao mesmo tempo, atrasos e falta de horários.",
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: _ProblemCard(
                                          icon: Icons.business,
                                          title: "Infraestrutura",
                                          desc: "Falta de iluminação e mato alto nos pontos de ônibus.",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Seção Linhas Disponíveis
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "Linhas Disponíveis",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDark),
                          ),
                          Text(
                            "9 linhas encontradas",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Lista de Linhas real data
                      ...lines.map((line) => _LineListItem(line: line)).toList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          currentIndex: 1,
          selectedItemColor: primaryDark,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          iconSize: 24,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
            BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: "Linhas"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Pontos"),
            BottomNavigationBarItem(icon: Icon(Icons.warning_amber), label: "Alertas"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuário"),
          ],
        ),
      ),
    );
  }
}

// Problem Card widget (single definition)
class _ProblemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _ProblemCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: primaryGreen, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryDark),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.3),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}

// Widget for each line item using real data
class _LineListItem extends StatelessWidget {
  final LineModel line;
  const _LineListItem({required this.line});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LineDetailsScreen(line: line)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            // Badge with number
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0B3D2E), Color(0xFF1F7A5C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                line.number,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        line.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          line.tripsBadge,
                          style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    line.description,
                    style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
