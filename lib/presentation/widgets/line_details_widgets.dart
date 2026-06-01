import 'package:flutter/material.dart';
import '../../../data/models/line_model.dart';

const primaryDark = Color(0xFF0B3D2E);
const primaryGreen = Color(0xFF1F7A5C);
const background = Color(0xFFF7F6F3);

// --- HEADER ---
class LineHeaderWidget extends StatelessWidget {
  final LineModel line;

  const LineHeaderWidget({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: primaryDark,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              line.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  line.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- FREQUÊNCIA ---
class FrequencySectionWidget extends StatelessWidget {
  final LineFrequency frequency;

  const FrequencySectionWidget({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_month, color: primaryDark, size: 18),
            SizedBox(width: 8),
            Text(
              "FREQUÊNCIA",
              style: TextStyle(
                color: primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _FreqCard(
                title: "DIAS ÚTEIS",
                icon: Icons.calendar_today,
                detail: frequency.diasUteis,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FreqCard(
                title: "SÁBADOS",
                icon: Icons.calendar_today,
                detail: frequency.sabados,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FreqCard(
                title: "DOMINGOS",
                icon: Icons.light_mode,
                detail: frequency.domingos,
                isOff: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FreqCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final FrequencyDetail detail;
  final bool isOff;

  const _FreqCard({
    required this.title,
    required this.icon,
    required this.detail,
    this.isOff = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 12, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 12),
          if (detail.operates) ...[
            RichText(
              text: TextSpan(
                text: '${detail.buses} ',
                style: const TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 16),
                children: const [
                  TextSpan(text: 'ônibus', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                text: '${detail.trips} ',
                style: const TextStyle(color: primaryDark, fontWeight: FontWeight.bold, fontSize: 16),
                children: const [
                  TextSpan(text: 'viagens', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ] else ...[
            const Text(
              "Não opera",
              style: TextStyle(
                color: Colors.black38,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- INDICADORES ---
class IndicatorWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  const IndicatorWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TRAJETO / TIMELINE ---
class TrajectoryTimelineWidget extends StatelessWidget {
  final LineRoute trajetoIda;
  final LineRoute trajetoVolta;

  const TrajectoryTimelineWidget({
    super.key,
    required this.trajetoIda,
    required this.trajetoVolta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.directions_bus, color: primaryDark, size: 18),
            SizedBox(width: 8),
            Text(
              "TRAJETO",
              style: TextStyle(
                color: primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _RouteCard(
                route: trajetoIda,
                headerColor: const Color(0xFFE8F5E9),
                textColor: const Color(0xFF2E7D32),
                icon: Icons.arrow_forward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RouteCard(
                route: trajetoVolta,
                headerColor: const Color(0xFFE3F2FD),
                textColor: const Color(0xFF1565C0),
                icon: Icons.arrow_back,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  final LineRoute route;
  final Color headerColor;
  final Color textColor;
  final IconData icon;

  const _RouteCard({
    required this.route,
    required this.headerColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: textColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    route.title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: route.stops.asMap().entries.map((entry) {
                int idx = entry.key;
                RouteStop stop = entry.value;
                bool isLast = idx == route.stops.length - 1;
                return _TimelineItem(stop: stop, isLast: isLast);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final RouteStop stop;
  final bool isLast;

  const _TimelineItem({required this.stop, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                stop.isMain ? Icons.adjust : Icons.circle,
                color: stop.isMain ? primaryDark : Colors.grey.shade300,
                size: stop.isMain ? 16 : 12,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                stop.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: stop.isMain ? FontWeight.w600 : FontWeight.normal,
                  color: stop.isMain ? Colors.black87 : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- AVALIAÇÕES ---
class RatingCardWidget extends StatelessWidget {
  final double averageLine;
  final double averageDriver;

  const RatingCardWidget({
    super.key,
    required this.averageLine,
    required this.averageDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_border, color: primaryDark, size: 18),
            const SizedBox(width: 8),
            const Text(
              "AVALIAÇÕES DA LINHA",
              style: TextStyle(
                color: primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFF4B400), size: 12),
                  const SizedBox(width: 4),
                  Text(averageLine.toStringAsFixed(0), style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Container(width: 1, height: 10, color: Colors.grey.shade300),
                  const SizedBox(width: 6),
                  const Icon(Icons.directions_bus, color: Colors.grey, size: 12),
                  const SizedBox(width: 4),
                  Text(averageDriver.toStringAsFixed(0), style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFF4B400), size: 18),
                      SizedBox(width: 8),
                      Text("Avaliar Linha", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  Row(
                    children: List.generate(5, (index) => const Icon(Icons.star_border, color: Colors.grey, size: 20)),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.directions_bus, color: primaryDark, size: 18),
                      SizedBox(width: 8),
                      Text("Avaliar Motorista", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- RELATOS ---
class ReportCardWidget extends StatelessWidget {
  final LineReport report;

  const ReportCardWidget({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    bool isPositive = report.tagType == 'positive';
    Color accentColor = isPositive ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F);
    Color tagBgColor = isPositive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: tagBgColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isPositive ? Icons.check_circle_outline : Icons.error_outline,
                                    color: accentColor,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    report.tag,
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              report.author,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          report.dateTime,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      report.comment,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _InteractionIcon(icon: Icons.favorite_border, count: report.likes),
                        const SizedBox(width: 16),
                        _InteractionIcon(icon: Icons.thumb_down_outlined, count: report.dislikes),
                        const SizedBox(width: 16),
                        _InteractionIcon(icon: Icons.chat_bubble_outline, count: report.comments),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractionIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const _InteractionIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
