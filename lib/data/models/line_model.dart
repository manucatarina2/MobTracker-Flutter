class LineModel {
  final String id;
  final String number;
  final String title;
  final String description;
  final String tripsBadge;
  final List<String> alerts;
  final LineFrequency frequency;
  final String travelTime;
  final String transitTime;
  final LineRoute trajetoIda;
  final LineRoute trajetoVolta;
  final double averageLineRating;
  final double averageDriverRating;
  final List<LineReport> reports;

  LineModel({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.tripsBadge,
    required this.alerts,
    required this.frequency,
    required this.travelTime,
    required this.transitTime,
    required this.trajetoIda,
    required this.trajetoVolta,
    required this.averageLineRating,
    required this.averageDriverRating,
    required this.reports,
  });

  /// Factory to create a [LineModel] from Supabase JSON response.
  factory LineModel.fromJson(Map<String, dynamic> json) {
    final detalhes = json['detalhes'] as Map<String, dynamic>? ?? {};
    // Frequency parsing
    final freqJson = detalhes['frequency'] as Map<String, dynamic>? ?? {};
    LineFrequency parseFrequency() {
      FrequencyDetail parseDetail(String key) {
        final info = freqJson[key] as Map<String, dynamic>? ?? {};
        return FrequencyDetail(
          operates: (info['buses'] != null && (info['buses'] as int) > 0),
          buses: info['buses'] as int? ?? 0,
          trips: info['trips'] as int? ?? 0,
        );
      }
      return LineFrequency(
        diasUteis: parseDetail('weekdays'),
        sabados: parseDetail('saturday'),
        domingos: parseDetail('sunday'),
      );
    }
    // Route parsing helper
    LineRoute parseRoute(String key) {
      final routeJson = detalhes[key] as Map<String, dynamic>? ?? {};
      final label = routeJson['label'] as String? ?? '';
      final stopsList = (routeJson['stops'] as List<dynamic>? ?? [])
          .map((e) => RouteStop(name: e as String, isMain: false))
          .toList();
      return LineRoute(title: label, stops: stopsList);
    }
    // Ratings
    final ratings = detalhes['ratings'] as Map<String, dynamic>? ?? {};
    double parseRating(String key) {
      final val = ratings[key];
      if (val == null) return 0.0;
      return (val is int) ? val.toDouble() : (val as num).toDouble();
    }
    return LineModel(
      id: json['id']?.toString() ?? '',
      number: json['numero']?.toString() ?? '',
      title: json['nome']?.toString() ?? '',
      description: json['descricao']?.toString() ?? '',
      tripsBadge: '',
      alerts: [],
      frequency: parseFrequency(),
      travelTime: detalhes['duration']?.toString() ?? '',
      transitTime: detalhes['peakTrafficTime']?.toString() ?? '',
      trajetoIda: parseRoute('forward'),
      trajetoVolta: parseRoute('return'),
      averageLineRating: parseRating('line'),
      averageDriverRating: parseRating('driver'),
      reports: [],
    );
  }
}

class LineFrequency {
  final FrequencyDetail diasUteis;
  final FrequencyDetail sabados;
  final FrequencyDetail domingos;

  LineFrequency({
    required this.diasUteis,
    required this.sabados,
    required this.domingos,
  });
}

class FrequencyDetail {
  final bool operates;
  final int buses;
  final int trips;

  FrequencyDetail({
    this.operates = true,
    this.buses = 0,
    this.trips = 0,
  });
}

class LineRoute {
  final String title;
  final List<RouteStop> stops;

  LineRoute({
    required this.title,
    required this.stops,
  });
}

class RouteStop {
  final String name;
  final bool isMain;

  RouteStop({
    required this.name,
    this.isMain = false,
  });
}

class LineReport {
  final String tag;
  final String tagType; // 'positive' or 'negative'
  final String author;
  final String dateTime;
  final String comment;
  final int likes;
  final int dislikes;
  final int comments;

  LineReport({
    required this.tag,
    required this.tagType,
    required this.author,
    required this.dateTime,
    required this.comment,
    this.likes = 0,
    this.dislikes = 0,
    this.comments = 0,
  });
}
