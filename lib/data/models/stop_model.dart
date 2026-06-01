class StopModel {
  final int? id;
  final String? nome;
  final String? bairro;
  final double? latitude;
  final double? longitude;
  final List<dynamic>? linhas; // list of line numbers or identifiers
  final bool? acessivel;
  final String? status;

  StopModel({
    this.id,
    this.nome,
    this.bairro,
    this.latitude,
    this.longitude,
    this.linhas,
    this.acessivel,
    this.status,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nome: json['nome'] as String?,
      bairro: json['bairro'] as String?,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      linhas: json['linhas'] as List<dynamic>?,
      acessivel: json['acessivel'] as bool?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'bairro': bairro,
        'latitude': latitude,
        'longitude': longitude,
        'linhas': linhas,
        'acessivel': acessivel,
        'status': status,
      };
}
