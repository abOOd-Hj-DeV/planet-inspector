class ImageModel {
  final int? id;
  final String plantName;
  final String description;
  final String imagePath;
  final bool isFavorite;

  const ImageModel({
    this.id,
    required this.plantName,
    required this.description,
    required this.imagePath,
    this.isFavorite = false,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      plantName: map['plantName'],
      description: map['description'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
