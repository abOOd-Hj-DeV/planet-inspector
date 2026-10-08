class PlantResult {
  const PlantResult({required this.name, required this.description});
  final String name;
  final String description;

  factory PlantResult.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('No plant was identified in this photo.');
    }
    final description = json['description'];
    final value = description is Map ? description['value'] : description;
    return PlantResult(
      name: name.trim(),
      description: value is String && value.trim().isNotEmpty
          ? value
          : 'No description available.',
    );
  }
}
