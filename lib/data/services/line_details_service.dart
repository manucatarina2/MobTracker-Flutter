import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stop_model.dart';
import '../models/alert_model.dart';
import '../models/report_model.dart';
import '../models/line_model.dart';

class LineDetailsService {
  final LineRepository _repository = LineRepository();

  Future<LineDetailsData> loadLineDetails(String lineNumber) async {
    final futures = await Future.wait([
      _repository.getLine(lineNumber),
      _repository.getAlerts(),
      _repository.getReports(lineNumber),
      _repository.getStops(),
    ]);
    return LineDetailsData(
      line: futures[0] as LineModel,
      alerts: futures[1] as List<AlertModel>,
      reports: futures[2] as List<ReportModel>,
      stops: futures[3] as List<StopModel>,
    );
  }

  Future<void> submitReport(ReportModel report) async {
    await _repository.insertReport(report);
  }
}

class LineDetailsData {
  final LineModel line;
  final List<AlertModel> alerts;
  final List<ReportModel> reports;
  final List<StopModel> stops;

  LineDetailsData({
    required this.line,
    required this.alerts,
    required this.reports,
    required this.stops,
  });
}
