import 'package:flutter/material.dart';
import 'package:farm_up/models/soil_data.dart';
import 'package:farm_up/models/crop_recommendation.dart';
import 'package:farm_up/services/soil_analysis_service.dart';

class SoilAnalysisForm extends StatefulWidget {
  final Function(List<CropRecommendation>) onResults;
  
  const SoilAnalysisForm({super.key, required this.onResults});

  @override
  State<SoilAnalysisForm> createState() => _SoilAnalysisFormState();
}

class _SoilAnalysisFormState extends State<SoilAnalysisForm> {
  final _formKey = GlobalKey<FormState>();
  final SoilAnalysisService _service = SoilAnalysisService();
  
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _moistureController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _phController.dispose();
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _moistureController.dispose();
    super.dispose();
  }

  Future<void> _analyzeSoil() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      final soilData = SoilData(
        pH: double.tryParse(_phController.text) ?? 0.0,
        nitrogen: double.tryParse(_nitrogenController.text) ?? 0.0,
        phosphorus: double.tryParse(_phosphorusController.text) ?? 0.0,
        potassium: double.tryParse(_potassiumController.text) ?? 0.0,
        moisture: double.tryParse(_moistureController.text) ?? 0.0,
      );
      
      try {
        final recommendations = await _service.analyzeSoil(soilData);
        widget.onResults(recommendations);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error analyzing soil: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Soil Analysis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phController,
            decoration: const InputDecoration(
              labelText: 'pH Level',
              hintText: 'Enter pH value (e.g., 6.5)',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter pH level';
              }
              final ph = double.tryParse(value);
              if (ph == null || ph < 0 || ph > 14) {
                return 'Please enter a valid pH value (0-14)';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _nitrogenController,
            decoration: const InputDecoration(
              labelText: 'Nitrogen (ppm)',
              hintText: 'Enter nitrogen content',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter nitrogen content';
              }
              final nitrogen = double.tryParse(value);
              if (nitrogen == null || nitrogen < 0) {
                return 'Please enter a valid nitrogen value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _phosphorusController,
            decoration: const InputDecoration(
              labelText: 'Phosphorus (ppm)',
              hintText: 'Enter phosphorus content',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phosphorus content';
              }
              final phosphorus = double.tryParse(value);
              if (phosphorus == null || phosphorus < 0) {
                return 'Please enter a valid phosphorus value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _potassiumController,
            decoration: const InputDecoration(
              labelText: 'Potassium (ppm)',
              hintText: 'Enter potassium content',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter potassium content';
              }
              final potassium = double.tryParse(value);
              if (potassium == null || potassium < 0) {
                return 'Please enter a valid potassium value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _moistureController,
            decoration: const InputDecoration(
              labelText: 'Moisture (%)',
              hintText: 'Enter moisture percentage',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter moisture percentage';
              }
              final moisture = double.tryParse(value);
              if (moisture == null || moisture < 0 || moisture > 100) {
                return 'Please enter a valid moisture percentage (0-100)';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _analyzeSoil,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      'Analyze Soil',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}