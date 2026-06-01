import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum AlertType {
  atraso,
  acidente,
  interrupcao,
  protesto,
  transito,
  superlotacao,
}

extension AlertTypeExtension on AlertType {
  String get displayName {
    switch (this) {
      case AlertType.atraso:
        return 'Atraso';
      case AlertType.acidente:
        return 'Acidente';
      case AlertType.interrupcao:
        return 'Interdição';
      case AlertType.protesto:
        return 'Protesto';
      case AlertType.transito:
        return 'Trânsito intenso';
      case AlertType.superlotacao:
        return 'Superlotação';
    }
  }
  
  IconData get icon {
    switch (this) {
      case AlertType.atraso:
        return Icons.timer;
      case AlertType.acidente:
        return Icons.car_crash;
      case AlertType.interrupcao:
        return Icons.block;
      case AlertType.protesto:
        return Icons.gavel;
      case AlertType.transito:
        return Icons.traffic;
      case AlertType.superlotacao:
        return Icons.people;
    }
  }
}

class AlertModel extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final AlertType type;
  final String? busLineName;
  final String location;
  final double? latitude;
  final double? longitude;
  final String description;
  final int likes;
  final int dislikes;
  final bool isResolved;
  final DateTime createdAt;
  
  const AlertModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    this.busLineName,
    required this.location,
    this.latitude,
    this.longitude,
    required this.description,
    this.likes = 0,
    this.dislikes = 0,
    this.isResolved = false,
    required this.createdAt,
  });
  
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      type: AlertType.values.firstWhere(
        (e) => e.displayName == json['type'],
        orElse: () => AlertType.atraso,
      ),
      busLineName: json['bus_line_name'] as String?,
      location: json['location'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      description: json['description'] as String,
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
      isResolved: json['is_resolved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'type': type.displayName,
      'bus_line_name': busLineName,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'likes': likes,
      'dislikes': dislikes,
      'is_resolved': isResolved,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  @override
  List<Object?> get props => [id, userId, type, location];
}