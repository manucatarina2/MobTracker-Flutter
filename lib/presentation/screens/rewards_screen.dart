import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recompensas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de Pontos
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.verdeEscuro, AppColors.verdeMedio],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seus Pontos',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '150',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Nível: Colaborador',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Badges Disponíveis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Badges
            _BadgeCard(
              name: 'Badge Bronze',
              description: 'Primeira conquista!',
              points: 50,
              icon: Icons.emoji_events,
              color: Color(0xFFCD7F32),
            ),
            _BadgeCard(
              name: 'Badge Prata',
              description: 'Você está evoluindo!',
              points: 150,
              icon: Icons.emoji_events,
              color: Color(0xFFC0C0C0),
            ),
            _BadgeCard(
              name: 'Badge Ouro',
              description: 'Colaborador exemplar!',
              points: 300,
              icon: Icons.emoji_events,
              color: Color(0xFFFFD700),
            ),
            _BadgeCard(
              name: 'Badge Mobilidade',
              description: 'Defensor da mobilidade',
              points: 500,
              icon: Icons.emoji_transportation,
              color: AppColors.verdeMedio,
            ),
            _BadgeCard(
              name: 'Badge Fiscalizador',
              description: 'Olho atento da cidade',
              points: 800,
              icon: Icons.remove_red_eye,
              color: AppColors.verdeEscuro,
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final String name;
  final String description;
  final int points;
  final IconData icon;
  final Color color;
  final bool isLocked;

  const _BadgeCard({
    required this.name,
    required this.description,
    required this.points,
    required this.icon,
    required this.color,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasPoints = 150 >= points; // Mock user points
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (hasPoints && !isLocked) ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: (hasPoints && !isLocked) ? color : Colors.grey,
            size: 30,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: (hasPoints && !isLocked) ? null : Colors.grey,
          ),
        ),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$points pts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (hasPoints && !isLocked) ? AppColors.verdeMedio : Colors.grey,
              ),
            ),
            if (hasPoints && !isLocked)
              const SizedBox(height: 4),
            if (hasPoints && !isLocked)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.verdeMedio,
                  minimumSize: const Size(60, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Trocar', style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }
}