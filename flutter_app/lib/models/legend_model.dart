class LegendModel {
  final String id;
  final String pageId;
  final String color;
  final String label;
  final int position;
  final String createdAt;

  const LegendModel({
    required this.id,
    required this.pageId,
    required this.color,
    required this.label,
    required this.position,
    required this.createdAt,
  });

  factory LegendModel.fromJson(Map<String, dynamic> json) {
    return LegendModel(
      id: json['id'] as String,
      pageId: (json['pageId'] ?? json['page_id'] ?? '') as String,
      color: (json['color'] ?? '') as String,
      label: (json['label'] ?? '') as String,
      position: (json['position'] ?? 0) as int,
      createdAt: (json['createdAt'] ?? json['created_at'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'page_id': pageId,
      'color': color,
      'label': label,
      'position': position,
      'created_at': createdAt,
    };
  }

  LegendModel copyWith({
    String? id,
    String? pageId,
    String? color,
    String? label,
    int? position,
    String? createdAt,
  }) {
    return LegendModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      color: color ?? this.color,
      label: label ?? this.label,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
