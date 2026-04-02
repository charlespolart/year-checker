class PageModel {
  final String id;
  final String userId;
  final String title;
  final int year;
  final int position;
  final List<List<String>>? palette;
  final String createdAt;

  const PageModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.year,
    required this.position,
    this.palette,
    required this.createdAt,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      year: json['year'] as int,
      position: json['position'] as int,
      palette: json['palette'] != null
          ? (json['palette'] as List<dynamic>)
              .map((row) =>
                  (row as List<dynamic>).map((c) => c as String).toList())
              .toList()
          : null,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'year': year,
      'position': position,
      'palette': palette,
      'created_at': createdAt,
    };
  }

  PageModel copyWith({
    String? id,
    String? userId,
    String? title,
    int? year,
    int? position,
    List<List<String>>? palette,
    String? createdAt,
  }) {
    return PageModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      year: year ?? this.year,
      position: position ?? this.position,
      palette: palette ?? this.palette,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
