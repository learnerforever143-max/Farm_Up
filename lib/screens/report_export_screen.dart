import 'package:flutter/material.dart';
import 'package:farm_up/services/report_export_service.dart';
import 'package:farm_up/services/soil_analysis_service.dart';
import 'package:farm_up/services/budget_calculator_service.dart';
import 'package:farm_up/services/yield_service.dart';
import 'package:farm_up/services/inventory_service.dart';
import 'package:farm_up/services/disease_detection_service.dart';
import 'package:farm_up/models/soil_data.dart';
import 'package:farm_up/models/crop_recommendation.dart';
import 'package:farm_up/models/budget_item.dart';
import 'package:farm_up/models/yield_data.dart';
import 'package:farm_up/models/inventory_item.dart';
import 'package:farm_up/models/disease_record.dart';

class ReportExportScreen extends StatefulWidget {
  const ReportExportScreen({super.key});

  @override
  State<ReportExportScreen> createState() => _ReportExportScreenState();
}

class _ReportExportScreenState extends State<ReportExportScreen> {
  final ReportExportService _exportService = ReportExportService();
  final SoilAnalysisService _soilService = SoilAnalysisService();
  final BudgetCalculatorService _budgetService = BudgetCalculatorService();
  final YieldService _yieldService = YieldService();
  final InventoryService _inventoryService = InventoryService();
  final DiseaseDetectionService _diseaseService = DiseaseDetectionService();
  
  bool _isExporting = false;
  String? _exportMessage;

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Initialize sample data for demonstration
    _soilService.initializeSampleData();
    _budgetService.initializeSampleData();
    _yieldService.initializeSampleData();
    _inventoryService.initializeSampleData();
    _diseaseService.initializeSampleData();
  }

  Future<void> _exportSoilAnalysisReport() async {
    setState(() {
      _isExporting = true;
      _exportMessage = 'Generating soil analysis report...';
    });

    try {
      // Create sample soil data
      final soilData = SoilData(
        pH: 6.5,
        nitrogen: 25.0,
        phosphorus: 18.0,
        potassium: 20.0,
        moisture: 30.0,
        organicCarbon: 2.5,
        temperature: 28.0,
        createdAt: DateTime.now(),
      );

      // Analyze soil
      final recommendations = await _soilService.analyzeSoil(soilData);
      final tips = await _soilService.getSoilImprovementTips(soilData);

      // Export to PDF
      final filePath = await _exportService.exportSoilAnalysisReportToPdf(
        soilData: soilData,
        recommendations: recommendations,
        improvementTips: tips,
        farmerName: 'John Doe',
      );

      setState(() {
        _isExporting = false;
        _exportMessage = 'Soil analysis report exported successfully!\nSaved to: $filePath';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved to: $filePath')),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportMessage = 'Error exporting soil analysis report: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting report: $e')),
        );
      }
    }
  }

  Future<void> _exportBudgetReport() async {
    setState(() {
      _isExporting = true;
      _exportMessage = 'Generating budget report...';
    });

    try {
      // Get budget data
      final budgetItems = _budgetService.getBudgetItems();
      final totalCost = _budgetService.getTotalCost();
      final costByCategory = _budgetService.getCostByCategory();

      // Export to PDF
      final filePath = await _exportService.exportBudgetReportToPdf(
        budgetItems: budgetItems,
        totalCost: totalCost,
        costByCategory: costByCategory,
        farmerName: 'John Doe',
      );

      setState(() {
        _isExporting = false;
        _exportMessage = 'Budget report exported successfully!\nSaved to: $filePath';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved to: $filePath')),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportMessage = 'Error exporting budget report: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting report: $e')),
        );
      }
    }
  }

  Future<void> _exportYieldReport() async {
    setState(() {
      _isExporting = true;
      _exportMessage = 'Generating yield report...';
    });

    try {
      // Get yield data
      final yieldData = _yieldService.getAllYieldData();
      final fieldProductivity = _yieldService.getAllFieldProductivity();

      // Export to PDF
      final filePath = await _exportService.exportYieldReportToPdf(
        yieldData: yieldData,
        fieldProductivity: fieldProductivity,
        farmerName: 'John Doe',
      );

      setState(() {
        _isExporting = false;
        _exportMessage = 'Yield report exported successfully!\nSaved to: $filePath';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved to: $filePath')),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportMessage = 'Error exporting yield report: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting report: $e')),
        );
      }
    }
  }

  Future<void> _exportInventoryReport() async {
    setState(() {
      _isExporting = true;
      _exportMessage = 'Generating inventory report...';
    });

    try {
      // Get inventory data
      final inventoryItems = _inventoryService.getAllInventoryItems();

      // Export to Excel
      final filePath = await _exportService.exportInventoryReportToExcel(
        inventoryItems: inventoryItems,
        farmerName: 'John Doe',
      );

      setState(() {
        _isExporting = false;
        _exportMessage = 'Inventory report exported successfully!\nSaved to: $filePath';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved to: $filePath')),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportMessage = 'Error exporting inventory report: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting report: $e')),
        );
      }
    }
  }

  Future<void> _exportDiseaseRecordsReport() async {
    setState(() {
      _isExporting = true;
      _exportMessage = 'Generating disease records report...';
    });

    try {
      // Get disease records
      final diseaseRecords = _diseaseService.getAllDiseaseRecords();

      // Export to PDF
      final filePath = await _exportService.exportDiseaseRecordsReportToPdf(
        diseaseRecords: diseaseRecords,
        farmerName: 'John Doe',
      );

      setState(() {
        _isExporting = false;
        _exportMessage = 'Disease records report exported successfully!\nSaved to: $filePath';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report saved to: $filePath')),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportMessage = 'Error exporting disease records report: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Export'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Generate and export detailed farming reports in PDF or Excel formats.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Available Reports',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Soil Analysis Report
            Card(
              child: ListTile(
                title: const Text('Soil Analysis Report'),
                subtitle: const Text('Detailed soil composition and crop recommendations'),
                trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
                onTap: _isExporting ? null : _exportSoilAnalysisReport,
              ),
            ),
            const SizedBox(height: 10),
            // Budget Report
            Card(
              child: ListTile(
                title: const Text('Budget Report'),
                subtitle: const Text('Financial planning and expense tracking'),
                trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
                onTap: _isExporting ? null : _exportBudgetReport,
              ),
            ),
            const SizedBox(height: 10),
            // Yield Report
            Card(
              child: ListTile(
                title: const Text('Yield Report'),
                subtitle: const Text('Productivity analytics and field performance'),
                trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
                onTap: _isExporting ? null : _exportYieldReport,
              ),
            ),
            const SizedBox(height: 10),
            // Inventory Report
            Card(
              child: ListTile(
                title: const Text('Inventory Report'),
                subtitle: const Text('Seeds, fertilizers, and supplies tracking'),
                trailing: const Icon(Icons.grid_on, color: Colors.green),
                onTap: _isExporting ? null : _exportInventoryReport,
              ),
            ),
            const SizedBox(height: 10),
            // Disease Records Report
            Card(
              child: ListTile(
                title: const Text('Disease Records Report'),
                subtitle: const Text('Plant health diagnostics and treatments'),
                trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
                onTap: _isExporting ? null : _exportDiseaseRecordsReport,
              ),
            ),
            const SizedBox(height: 30),
            if (_isExporting) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Generating report...'),
                  ],
                ),
              ),
            ] else if (_exportMessage != null) ...[
              Card(
                color: _exportMessage!.startsWith('Error') 
                    ? Colors.red[50] 
                    : Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _exportMessage!,
                    style: TextStyle(
                      color: _exportMessage!.startsWith('Error') 
                          ? Colors.red 
                          : Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}