import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/line_model.dart';
import '../models/alert_model.dart';
import '../models/report_model.dart';
import '../models/stop_model.dart';

class LineRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch a single line by its number.
  Future<LineModel> getLine(String number) async {
    final response = await _client
        .from('linhas')
        .select()
        .eq('numero', number)
        .single();
    // response is a Map<String, dynamic>
    return LineModel.fromJson(response as Map<String, dynamic>);
  }

  // Fetch all lines ordered by 'numero'.
  Future<List<LineModel>> getAllLines() async {
    final response = await _client.from('linhas').select().order('numero');
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((e) => LineModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Fetch all stops.
  Future<List<StopModel>> getStops() async {
    final response = await _client.from('stops').select();
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((e) => StopModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Insert a new report.
  Future<void> insertReport(ReportModel report) async {
    await _client.from('reports').insert(report.toJson());
    // The Supabase client throws on errors automatically.
  }
}
