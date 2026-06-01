import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final int points;
  final String level;
  final int totalReports;
  final int totalConfirms;
  final int totalLikes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.points = 0,
    this.level = 'Iniciante',
    this.totalReports = 0,
    this.totalConfirms = 0,
    this.totalLikes = 0,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      points: json['points'] as int? ?? 0,
      level: json['level'] as String? ?? 'Iniciante',
      totalReports: json['total_reports'] as int? ?? 0,
      totalConfirms: json['total_confirms'] as int? ?? 0,
      totalLikes: json['total_likes'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'points': points,
      'level': level,
      'total_reports': totalReports,
      'total_confirms': totalConfirms,
      'total_likes': totalLikes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  UserModel copyWith({
    String? fullName,
    String? avatarUrl,
    int? points,
    String? level,
    int? totalReports,
    int? totalConfirms,
    int? totalLikes,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
      level: level ?? this.level,
      totalReports: totalReports ?? this.totalReports,
      totalConfirms: totalConfirms ?? this.totalConfirms,
      totalLikes: totalLikes ?? this.totalLikes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
  
  @override
  List<Object?> get props => [id, fullName, email, points, level];
}