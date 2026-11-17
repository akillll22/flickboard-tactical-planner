class PlayerModel {
  final int id;
  final String name;
  final int shirtNumber;
  final String position;
  final int overallRating;
  final int pace;
  final int passing;
  final int defending;
  final String? photoUrl;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.shirtNumber,
    required this.position,
    required this.overallRating,
    required this.pace,
    required this.passing,
    required this.defending,
    this.photoUrl,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      name: json['name'],
      shirtNumber: json['shirt_number'],
      position: json['position'],
      overallRating: json['overall_rating'],
      pace: json['pace'],
      passing: json['passing'],
      defending: json['defending'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shirt_number': shirtNumber,
      'position': position,
      'overall_rating': overallRating,
      'pace': pace,
      'passing': passing,
      'defending': defending,
      'photo_url': photoUrl,
    };
  }
}
