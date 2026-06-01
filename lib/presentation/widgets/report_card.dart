import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final VoidCallback? onTap;
  final VoidCallback? onConfirm;
  final VoidCallback? onLike;

  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.onConfirm,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
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
                      color: _getSituationColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getSituationIcon(),
                      size: 20,
                      color: _getSituationColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.busLineName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          report.busStopName,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    Helpers.formatTimeAgo(report.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.timer,
                    label: '${report.waitTime} min',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.warning,
                    label: report.situation.displayName,
                  ),
                ],
              ),
              if (report.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  report.description!,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _ActionChip(
                    icon: Icons.check_circle,
                    label: 'Confirmar',
                    count: report.confirmations,
                    onPressed: onConfirm,
                  ),
                  const SizedBox(width: 16),
                  _ActionChip(
                    icon: Icons.thumb_up,
                    label: 'Curtir',
                    count: report.likes,
                    onPressed: onLike,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSituationColor() {
    switch (report.situation) {
      case ReportSituation.atrasado:
        return AppColors.warning;
      case ReportSituation.lotado:
        return AppColors.error;
      case ReportSituation.quebrado:
        return AppColors.error;
      default:
        return AppColors.verdeMedio;
    }
  }

  IconData _getSituationIcon() {
    switch (report.situation) {
      case ReportSituation.atrasado:
        return Icons.timer;
      case ReportSituation.lotado:
        return Icons.people;
      case ReportSituation.quebrado:
        return Icons.build;
      case ReportSituation.acidente:
        return Icons.car_crash;
      default:
        return Icons.report;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback? onPressed;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.count,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.verdeMedio),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.verdeMedio),
          ),
          const SizedBox(width: 4),
          if (count > 0)
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}