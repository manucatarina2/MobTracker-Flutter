import 'package:flutter/material.dart';
import '../../data/models/line_model.dart';
import '../widgets/line_details_widgets.dart';

class LineDetailsScreen extends StatelessWidget {
  final LineModel line;

  const LineDetailsScreen({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          "Linha ${line.number}",
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          LineHeaderWidget(line: line),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alertas
                  if (line.alerts.isNotEmpty)
                    ...line.alerts.map((alert) => Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            border: Border.all(color: const Color(0xFFFFE082)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Color(0xFFD84315), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  alert,
                                  style: const TextStyle(
                                    color: Color(0xFFD84315),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  
                  // Frequencia
                  FrequencySectionWidget(frequency: line.frequency),
                  const SizedBox(height: 32),
                  
                  // Indicadores
                  IndicatorWidget(
                    text: "Tempo de percurso: ${line.travelTime}",
                    icon: Icons.access_time,
                    color: const Color(0xFF1565C0),
                    bgColor: const Color(0xFFE3F2FD),
                    borderColor: const Color(0xFFBBDEFB),
                  ),
                  IndicatorWidget(
                    text: "Tempo médio de trânsito(ida e volta): ${line.transitTime}",
                    icon: Icons.warning_amber_rounded,
                    color: const Color(0xFFD32F2F),
                    bgColor: const Color(0xFFFFEBEE),
                    borderColor: const Color(0xFFFFCDD2),
                  ),
                  const SizedBox(height: 32),
                  
                  // Trajeto
                  TrajectoryTimelineWidget(
                    trajetoIda: line.trajetoIda,
                    trajetoVolta: line.trajetoVolta,
                  ),
                  const SizedBox(height: 32),
                  
                  // Avaliacoes
                  RatingCardWidget(
                    averageLine: line.averageLineRating,
                    averageDriver: line.averageDriverRating,
                  ),
                  const SizedBox(height: 32),
                  
                  // Relatos
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, color: primaryDark, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "RELATOS DA LINHA",
                            style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      _AddReportButton(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Formulario de Relato (Mock)
                  const _ReportFormMock(),
                  const SizedBox(height: 16),
                  
                  // Lista de Relatos
                  ...line.reports.map((r) => ReportCardWidget(report: r)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddReportButton extends StatelessWidget {
  const _AddReportButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.add, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            "Relatar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportFormMock extends StatelessWidget {
  const _ReportFormMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Atraso / Problema Médio", style: TextStyle(fontSize: 13, color: Colors.black87)),
                Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 80,
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "O que está acontecendo nesta linha?",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Cancelar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Enviar Relato", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
