import 'package:flutter/material.dart';
import 'package:farm_up/services/disease_detection_service.dart';
import 'package:farm_up/models/disease_detection.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final DiseaseDetectionService _detectionService = DiseaseDetectionService();
  List<DiseaseDetection> _detectionHistory = [];
  DiseaseDetection? _latestDetection;
  bool _isLoading = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _loadDetectionHistory();
  }

  Future<void> _loadDetectionHistory() async {
    try {
      final history = await _detectionService.getDetectionHistory();
      setState(() {
        _detectionHistory = history;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load history: $e')),
        );
      }
    }
  }

  Future<void> _simulateImageCapture() async {
    setState(() {
      _isLoading = true;
      _showResults = false;
    });

    try {
      // In a real app, this would use the camera plugin to capture an image
      // For simulation, we'll use a placeholder image path
      final detection = await _detectionService.analyzePlantImage(
        'assets/images/plant_sample.jpg',
      );
      
      setState(() {
        _latestDetection = detection;
        _showResults = true;
        _isLoading = false;
        
        // Add to history
        _detectionHistory.insert(0, detection);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detection failed: $e')),
        );
      }
    }
  }

  void _markTreatmentAsApplied(DiseaseDetection detection) {
    setState(() {
      // In a real app, this would update the database
      // For simulation, we'll just update the local object
      _detectionHistory = _detectionHistory.map((d) {
        if (d.detectionDate == detection.detectionDate) {
          return DiseaseDetection(
            id: d.id,
            imagePath: d.imagePath,
            detectedDisease: d.detectedDisease,
            diseaseDescription: d.diseaseDescription,
            confidenceScore: d.confidenceScore,
            treatmentOptions: d.treatmentOptions,
            preventionTips: d.preventionTips,
            detectionDate: d.detectionDate,
            treatmentApplied: true,
          );
        }
        return d;
      }).toList();
      
      if (_latestDetection != null && 
          _latestDetection!.detectionDate == detection.detectionDate) {
        _latestDetection = DiseaseDetection(
          id: _latestDetection!.id,
          imagePath: _latestDetection!.imagePath,
          detectedDisease: _latestDetection!.detectedDisease,
          diseaseDescription: _latestDetection!.diseaseDescription,
          confidenceScore: _latestDetection!.confidenceScore,
          treatmentOptions: _latestDetection!.treatmentOptions,
          preventionTips: _latestDetection!.preventionTips,
          detectionDate: _latestDetection!.detectionDate,
          treatmentApplied: true,
        );
      }
    });
    
    // In a real app, this would call the service method
    // _detectionService.markTreatmentAsApplied(detection.id!);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treatment marked as applied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI-Powered Disease Detection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Upload plant photos for instant diagnosis and treatment recommendations',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.photo_camera,
                        size: 60,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Capture or Upload Plant Photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Take a clear photo of the affected plant part for analysis',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _simulateImageCapture,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Analyze Plant Image',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_showResults && _latestDetection != null) ...[
                const Text(
                  'Detection Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: _latestDetection!.detectedDisease == 'Healthy Plant'
                      ? Colors.green[50]
                      : Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _latestDetection!.detectedDisease == 'Healthy Plant'
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: _latestDetection!.detectedDisease == 'Healthy Plant'
                                  ? Colors.green
                                  : Colors.red,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _latestDetection!.detectedDisease,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                '${(_latestDetection!.confidenceScore * 100).toStringAsFixed(1)}%',
                              ),
                              backgroundColor: _latestDetection!.confidenceScore > 0.9
                                  ? Colors.green
                                  : _latestDetection!.confidenceScore > 0.7
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(_latestDetection!.diseaseDescription),
                        if (_latestDetection!.treatmentOptions.isNotEmpty) ...[
                          const SizedBox(height: 15),
                          const Text(
                            'Treatment Options:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ..._latestDetection!.treatmentOptions.map((treatment) => Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• '),
                                    Expanded(child: Text(treatment)),
                                  ],
                                ),
                              )),
                        ],
                        if (_latestDetection!.preventionTips.isNotEmpty) ...[
                          const SizedBox(height: 15),
                          const Text(
                            'Prevention Tips:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ..._latestDetection!.preventionTips.map((tip) => Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• '),
                                    Expanded(child: Text(tip)),
                                  ],
                                ),
                              )),
                        ],
                        const SizedBox(height: 15),
                        if (!_latestDetection!.treatmentApplied)
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _markTreatmentAsApplied(_latestDetection!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Mark Treatment as Applied'),
                            ),
                          )
                        else
                          const Center(
                            child: Text(
                              'Treatment Applied ✓',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Detection History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_detectionHistory.isEmpty)
                const Center(
                  child: Text('No detection history yet'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _detectionHistory.length,
                  itemBuilder: (context, index) {
                    final detection = _detectionHistory[index];
                    return Card(
                      child: ListTile(
                        title: Text(detection.detectedDisease),
                        subtitle: Text(
                          '${detection.detectionDate.toString().split(' ').first} • '
                          '${(detection.confidenceScore * 100).toStringAsFixed(1)}% confidence',
                        ),
                        trailing: detection.treatmentApplied
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() {
                            _latestDetection = detection;
                            _showResults = true;
                          });
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}