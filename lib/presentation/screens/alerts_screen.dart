import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/alert_model.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Hoje', 'Esta semana', 'Linha', 'Bairro'];
  
  // Mock data
  final List<AlertModel> _alerts = [
    AlertModel(
      id: '1',
      userId: '1',
      userName: 'João Silva',
      type: AlertType.atraso,
      busLineName: 'Linha 101',
      location: 'Terminal Central',
      description: 'Ônibus com mais de 20 minutos de atraso',
      likes: 15,
      dislikes: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AlertModel(
      id: '2',
      userId: '2',
      userName: 'Maria Santos',
      type: AlertType.superlotacao,
      busLineName: 'Linha 205',
      location: 'Av. Paulista',
      description: 'Ônibus extremamente lotado, não consegui embarcar',
      likes: 32,
      dislikes: 1,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AlertModel(
      id: '3',
      userId: '3',
      userName: 'Pedro Costa',
      type: AlertType.acidente,
      location: 'Rua das Flores',
      description: 'Acidente na via, trânsito parado',
      likes: 8,
      dislikes: 0,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.verdeMedio,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          
          // Lista de alertas
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // TODO: Refresh alerts
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  return _AlertCard(alert: alert);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create alert
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Alerta'),
        backgroundColor: AppColors.verdeMedio,
      ),
    );
  }
}

class _AlertCard extends StatefulWidget {
  final AlertModel alert;
  
  const _AlertCard({required this.alert});

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard> {
  bool _isLiked = false;
  bool _isDisliked = false;
  int _likes = 0;
  int _dislikes = 0;

  @override
  void initState() {
    super.initState();
    _likes = widget.alert.likes;
    _dislikes = widget.alert.dislikes;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.verdeMedio.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.alert.type.icon,
                    size: 20,
                    color: AppColors.verdeMedio,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.alert.type.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (widget.alert.busLineName != null)
                        Text(
                          widget.alert.busLineName!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                    ],
                  ),
                ),
                Text(
                  Helpers.formatTimeAgo(widget.alert.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.alert.location,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              widget.alert.description,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Like button
                _ActionButton(
                  icon: Icons.thumb_up,
                  count: _likes,
                  isActive: _isLiked,
                  color: AppColors.success,
                  onTap: () {
                    setState(() {
                      if (_isLiked) {
                        _likes--;
                        _isLiked = false;
                      } else {
                        _likes++;
                        _isLiked = true;
                        if (_isDisliked) {
                          _dislikes--;
                          _isDisliked = false;
                        }
                      }
                    });
                  },
                ),
                const SizedBox(width: 16),
                // Dislike button
                _ActionButton(
                  icon: Icons.thumb_down,
                  count: _dislikes,
                  isActive: _isDisliked,
                  color: AppColors.error,
                  onTap: () {
                    setState(() {
                      if (_isDisliked) {
                        _dislikes--;
                        _isDisliked = false;
                      } else {
                        _dislikes++;
                        _isDisliked = true;
                        if (_isLiked) {
                          _likes--;
                          _isLiked = false;
                        }
                      }
                    });
                  },
                ),
                const SizedBox(width: 16),
                // Comment button
                _ActionButton(
                  icon: Icons.comment,
                  count: 0,
                  isActive: false,
                  color: Colors.grey,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? color : Colors.grey.shade400,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isActive ? color : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}