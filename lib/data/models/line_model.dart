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
  final String tagType; // 'positive' ou 'negative'
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
