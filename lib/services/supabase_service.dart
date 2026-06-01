import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  Future<void> init() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  Future<List<Map<String, dynamic>>> fetchReports({
  int? page,
  int? pageSize,
  String? busLineId,
}) async {
  try {
    final response = await client
        .from('reports')
        .select('*, bus_lines(*)')
        .eq('bus_line_id', busLineId ?? '')
        .order('created_at', ascending: false);
    
    return response;
  } catch (e) {
    print('Erro ao buscar relatos: $e');
    return [];
  }
}

  Future<Map<String, dynamic>?> createReport(Map<String, dynamic> report) async {
    try {
      final response = await client.from('reports').insert(report).select().single();
      return response;
    } catch (e) {
      print('Erro ao criar relato: $e');
      return null;
    }
  }

  Future<String?> uploadImage(String path, String userId) async {
    try {
      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(path);
      await client.storage.from('reports').upload(fileName, file);
      final url = client.storage.from('reports').getPublicUrl(fileName);
      return url;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  Future<bool> confirmReport(String reportId, String userId) async {
    try {
      await client.from('confirmations').insert({
        'report_id': reportId,
        'user_id': userId,
      });
      
      await client.rpc('increment_confirmations', params: {'report_id': reportId});
      return true;
    } catch (e) {
      print('Erro ao confirmar relato: $e');
      return false;
    }
  }

  Future<bool> likeContent(String type, String contentId, String userId) async {
    try {
      await client.from('likes').insert({
        '${type}_id': contentId,
        'user_id': userId,
        'type': 'like',
      });
      
      await client.rpc('increment_likes', params: {'${type}_id': contentId});
      return true;
    } catch (e) {
      print('Erro ao curtir: $e');
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> listenToReports() {
    return client
        .from('reports')
        .stream(primaryKey: ['id'])
        .map((event) => event as List<Map<String, dynamic>>);
  }

  Future<List<Map<String, dynamic>>> getBusLines() async {
    try {
      final response = await client.from('bus_lines').select().order('line_number');
      return response;
    } catch (e) {
      print('Erro ao buscar linhas: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserReports(String userId) async {
    try {
      final response = await client
          .from('reports')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      print('Erro ao buscar relatos do usuário: $e');
      return [];
    }
  }
}