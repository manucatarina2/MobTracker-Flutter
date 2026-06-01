import 'package:equatable/equatable.dart';

enum ReportSituation {
  atrasado,
  lotado,
  quebrado,
  naoPassou,
  acidente,
  transito,
  paradaVandalizada,
  outros,
}

extension ReportSituationExtension on ReportSituation {
  String get displayName {
    switch (this) {
      case ReportSituation.atrasado:
        return 'Atrasado';
      case ReportSituation.lotado:
        return 'Lotado';
      case ReportSituation.quebrado:
        return 'Quebrado';
      case ReportSituation.naoPassou:
        return 'Não passou';
      case ReportSituation.acidente:
        return 'Acidente';
      case ReportSituation.transito:
        return 'Trânsito';
      case ReportSituation.paradaVandalizada:
        return 'Parada vandalizada';
      case ReportSituation.outros:
        return 'Outro';
    }
  }
  
  static ReportSituation fromString(String value) {
    switch (value) {
      case 'Atrasado':
        return ReportSituation.atrasado;
      case 'Lotado':
        return ReportSituation.lotado;
      case 'Quebrado':
        return ReportSituation.quebrado;
      case 'Não passou':
        return ReportSituation.naoPassou;
      case 'Acidente':
        return ReportSituation.acidente;
      case 'Trânsito':
        return ReportSituation.transito;
      case 'Parada vandalizada':
        return ReportSituation.paradaVandalizada;
      default:
        return ReportSituation.outros;
    }
  }
}

class ReportModel extends Equatable {
  final String id;
  final String userId;
  final String busLineId;
  final String busLineName;
  final String busStopName;
  final int waitTime;
  final ReportSituation situation;
  final String? description;
  final String? photoUrl;
  final bool isAnonymous;
  final int confirmations;
  final int likes;
  final int dislikes;
  final DateTime createdAt;
  final String status;
  
  const ReportModel({
    required this.id,
    required this.userId,
    required this.busLineId,
    required this.busLineName,
    required this.busStopName,
    required this.waitTime,
    required this.situation,
    this.description,
    this.photoUrl,
    this.isAnonymous = false,
    this.confirmations = 0,
    this.likes = 0,
    this.dislikes = 0,
    required this.createdAt,
    this.status = 'active',
  });
  
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      busLineId: json['bus_line_id'] as String,
      busLineName: json['bus_line_name'] as String,
      busStopName: json['bus_stop_name'] as String,
      waitTime: json['wait_time'] as int,
      situation: ReportSituationExtension.fromString(json['situation'] as String),
      description: json['description'] as String?,
      photoUrl: json['photo_url'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      confirmations: json['confirmations'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String? ?? 'active',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bus_line_id': busLineId,
      'bus_line_name': busLineName,
      'bus_stop_name': busStopName,
      'wait_time': waitTime,
      'situation': situation.displayName,
      'description': description,
      'photo_url': photoUrl,
      'is_anonymous': isAnonymous,
      'confirmations': confirmations,
      'likes': likes,
      'dislikes': dislikes,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }
  
  @override
  List<Object?> get props => [id, userId, busLineId, waitTime, situation];
}