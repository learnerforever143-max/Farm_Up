import 'package:flutter/material.dart';
import 'package:farm_up/models/crop_recommendation.dart';

class CropRecommendationsList extends StatelessWidget {
  final List<CropRecommendation> recommendations;

  const CropRecommendationsList({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return const Center(
        child: Text('No crop recommendations available.'),
      );
    }

    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final crop = recommendations[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Row(
              children: [
                Icon(
                  _getCropIcon(crop.cropName),
                  color: Colors.green,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    crop.cropName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text('${crop.profitabilityScore.toStringAsFixed(1)}/10'),
                  backgroundColor: _getProfitabilityColor(crop.profitabilityScore),
                ),
              ],
            ),
            subtitle: Text(crop.description),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expected Yield: ${crop.expectedYield} tons/hectare',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Care Instructions:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ...crop.careInstructions.map((instruction) => Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(instruction)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getCropIcon(String cropName) {
    switch (cropName.toLowerCase()) {
      case 'wheat':
        return Icons.grain;
      case 'rice':
        return Icons.eco;
      case 'tomatoes':
        return Icons.eco_outlined;
      default:
        return Icons.local_florist;
    }
  }

  Color _getProfitabilityColor(double score) {
    if (score >= 8.0) {
      return Colors.green.shade300;
    } else if (score >= 6.0) {
      return Colors.orange.shade300;
    } else {
      return Colors.red.shade300;
    }
  }
}