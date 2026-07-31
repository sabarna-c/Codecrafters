/// Batch Model mapping college graduation batches
class BatchModel {
  final String id;
  final int year;
  final String name;

  const BatchModel({
    required this.id,
    required this.year,
    required this.name,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['id'] as String,
      year: json['year'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'name': name,
    };
  }
}
