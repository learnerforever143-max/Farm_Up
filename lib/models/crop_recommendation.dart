class CropRecommendation {
  final String cropName;
  final String description;
  final double expectedYield;
  final List<String> careInstructions;
  final double profitabilityScore;

  CropRecommendation({
    required this.cropName,
    required this.description,
    required this.expectedYield,
    required this.careInstructions,
    required this.profitabilityScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'description': description,
      'expectedYield': expectedYield,
      'careInstructions': careInstructions,
      'profitabilityScore': profitabilityScore,
    };
  }

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      cropName: json['cropName'],
      description: json['description'],
      expectedYield: json['expectedYield'],
      careInstructions: List<String>.from(json['careInstructions']),
      profitabilityScore: json['profitabilityScore'],
    );
  }
}