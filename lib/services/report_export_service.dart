import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:farm_up/models/soil_data.dart';
import 'package:farm_up/models/crop_recommendation.dart';
import 'package:farm_up/models/budget_item.dart';
import 'package:farm_up/models/yield_data.dart';
import 'package:farm_up/models/inventory_item.dart';
import 'package:farm_up/models/disease_record.dart';
import 'package:farm_up/models/weather_data.dart';

class ReportExportService {
  static final ReportExportService _instance = ReportExportService._internal();
  factory ReportExportService() => _instance;
  ReportExportService._internal();

  // Export soil analysis report to PDF
  Future<String> exportSoilAnalysisReportToPdf({
    required SoilData soilData,
    required List<CropRecommendation> recommendations,
    required List<String> improvementTips,
    String? farmerName,
  }) async {
    final pdf = pw.Document();

    // Add title page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Soil Analysis Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              if (farmerName != null)
                pw.Text(
                  'Farmer: $farmerName',
                  style: pw.TextStyle(fontSize: 16),
                ),
              pw.Text(
                'Generated on: ${DateTime.now().toString().split(' ').first}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Soil Data',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              _buildSoilDataTable(soilData),
              pw.SizedBox(height: 30),
              pw.Text(
                'Crop Recommendations',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...recommendations.map((rec) => _buildRecommendationEntry(rec)).toList(),
              pw.SizedBox(height: 30),
              pw.Text(
                'Improvement Tips',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...improvementTips.map((tip) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('• ', style: pw.TextStyle(fontSize: 12)),
                    pw.Expanded(
                      child: pw.Text(
                        tip,
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          );
        },
      ),
    );

    // Save PDF to file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/soil_analysis_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // Export budget report to PDF
  Future<String> exportBudgetReportToPdf({
    required List<BudgetItem> budgetItems,
    required double totalCost,
    required Map<String, double> costByCategory,
    String? farmerName,
  }) async {
    final pdf = pw.Document();

    // Add title page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Budget Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              if (farmerName != null)
                pw.Text(
                  'Farmer: $farmerName',
                  style: pw.TextStyle(fontSize: 16),
                ),
              pw.Text(
                'Generated on: ${DateTime.now().toString().split(' ').first}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Summary',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Cost:', style: pw.TextStyle(fontSize: 16)),
                  pw.Text('₹${totalCost.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Cost by Category',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...costByCategory.entries.map((entry) => pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(entry.key, style: pw.TextStyle(fontSize: 14)),
                  pw.Text('₹${entry.value.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
                ],
              )).toList(),
              pw.SizedBox(height: 30),
              pw.Text(
                'Detailed Budget Items',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Item', 'Category', 'Quantity', 'Unit Price', 'Total'],
                data: budgetItems.map((item) => [
                  item.name,
                  item.category,
                  item.quantity.toString(),
                  '₹${item.unitPrice.toStringAsFixed(2)}',
                  '₹${item.cost.toStringAsFixed(2)}',
                ]).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                border: null,
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/budget_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // Export yield report to PDF
  Future<String> exportYieldReportToPdf({
    required List<YieldData> yieldData,
    required List<FieldProductivity> fieldProductivity,
    String? farmerName,
  }) async {
    final pdf = pw.Document();

    // Add title page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Yield Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              if (farmerName != null)
                pw.Text(
                  'Farmer: $farmerName',
                  style: pw.TextStyle(fontSize: 16),
                ),
              pw.Text(
                'Generated on: ${DateTime.now().toString().split(' ').first}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Field Productivity',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...fieldProductivity.map((field) => _buildFieldProductivityEntry(field)).toList(),
              pw.SizedBox(height: 30),
              pw.Text(
                'Yield History',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Crop', 'Field', 'Season', 'Area (ha)', 'Yield (q/ha)'],
                data: yieldData.map((data) => [
                  data.cropName,
                  data.fieldName,
                  data.season,
                  data.areaHectares.toString(),
                  data.yieldPerHectare.toStringAsFixed(2),
                ]).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                border: null,
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/yield_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // Export inventory report to Excel
  Future<String> exportInventoryReportToExcel({
    required List<InventoryItem> inventoryItems,
    String? farmerName,
  }) async {
    final excel = Excel.createExcel();

    // Create worksheet
    final sheet = excel['Inventory Report'];

    // Add headers
    sheet.appendRow([
      'Item Name',
      'Category',
      'Description',
      'Quantity',
      'Unit',
      'Purchase Date',
      'Expiry Date',
      'Purchase Price',
      'Total Price',
      'Supplier',
      'Storage Location',
      'Batch Number',
      'Critical Item',
    ]);

    // Add data rows
    for (final item in inventoryItems) {
      sheet.appendRow([
        item.name,
        item.category,
        item.description,
        item.quantity,
        item.unit,
        item.purchaseDate.toString().split(' ').first,
        item.expiryDate.toString().split(' ').first,
        item.purchasePrice,
        item.totalPrice,
        item.supplier,
        item.storageLocation,
        item.batchNumber,
        item.isCritical ? 'Yes' : 'No',
      ]);
    }

    // Auto resize columns
    for (var column = 0; column < 13; column++) {
      sheet.autoResizeColumn(column);
    }

    // Save Excel file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/inventory_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath);
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }

    return filePath;
  }

  // Export disease records report to PDF
  Future<String> exportDiseaseRecordsReportToPdf({
    required List<DiseaseRecord> diseaseRecords,
    String? farmerName,
  }) async {
    final pdf = pw.Document();

    // Add title page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Disease Records Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              if (farmerName != null)
                pw.Text(
                  'Farmer: $farmerName',
                  style: pw.TextStyle(fontSize: 16),
                ),
              pw.Text(
                'Generated on: ${DateTime.now().toString().split(' ').first}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Disease Records',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...diseaseRecords.map((record) => _buildDiseaseRecordEntry(record)).toList(),
            ],
          );
        },
      ),
    );

    // Save PDF to file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/disease_records_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // Helper widgets for PDF generation
  pw.Widget _buildSoilDataTable(SoilData soilData) {
    return pw.Table.fromTextArray(
      headers: ['Parameter', 'Value'],
      data: [
        ['pH Level', soilData.pH.toStringAsFixed(2)],
        ['Nitrogen (ppm)', soilData.nitrogen.toStringAsFixed(2)],
        ['Phosphorus (ppm)', soilData.phosphorus.toStringAsFixed(2)],
        ['Potassium (ppm)', soilData.potassium.toStringAsFixed(2)],
        ['Moisture (%)', soilData.moisture.toStringAsFixed(2)],
        ['Organic Carbon (%)', soilData.organicCarbon.toStringAsFixed(2)],
        ['Temperature (°C)', soilData.temperature.toStringAsFixed(2)],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.centerLeft,
      border: null,
    );
  }

  pw.Widget _buildRecommendationEntry(CropRecommendation recommendation) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            recommendation.cropName,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            recommendation.description,
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Expected Yield: ${recommendation.expectedYield} tons/hectare',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Profitability Score: ${recommendation.profitabilityScore}/10',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text('Care Instructions:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...recommendation.careInstructions.map((instruction) => pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: pw.TextStyle(fontSize: 10)),
                pw.Expanded(
                  child: pw.Text(
                    instruction,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  pw.Widget _buildFieldProductivityEntry(FieldProductivity field) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            field.fieldName,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Area: ${field.areaHectares} hectares',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Average Yield: ${field.averageYieldPerHectare.toStringAsFixed(2)} quintals/hectare',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Trend: ${field.productivityTrend}',
            style: pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDiseaseRecordEntry(DiseaseRecord record) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${record.cropName} - ${record.diseaseName}',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Diagnosed on: ${record.diagnosisDate.toString().split(' ').first}',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Severity: ${record.severity}',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Status: ${record.status}',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Text('Symptoms:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...record.symptoms.map((symptom) => pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: pw.TextStyle(fontSize: 10)),
                pw.Expanded(
                  child: pw.Text(
                    symptom,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          )).toList(),
          pw.SizedBox(height: 5),
          pw.Text('Treatment:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 3),
            child: pw.Text(
              record.treatment,
              style: pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text('Prevention:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...record.prevention.map((tip) => pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: pw.TextStyle(fontSize: 10)),
                pw.Expanded(
                  child: pw.Text(
                    tip,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  // Open file (platform-specific implementation would be needed in a real app)
  Future<void> openFile(String filePath) async {
    // In a real implementation, this would use a package like `open_file`
    // to open the file with the appropriate application
    print('File saved to: $filePath');
  }
}