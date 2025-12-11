class YieldData {
  final int? id;
  final String cropName;
  final String fieldName;
  final double areaHectares;
  final DateTime plantingDate;
  final DateTime harvestDate;
  final double yieldInQuintals;
  final double yieldPerHectare;
  final String season;
  final String notes;
  final List<YieldComparison> comparisons;

  YieldData({
    this.id,
    required this.cropName,
    required this.fieldName,
    required this.areaHectares,
    required this.plantingDate,
    required this.harvestDate,
    required this.yieldInQuintals,
    required this.yieldPerHectare,
    required this.season,
    this.notes = '',
    List<YieldComparison>? comparisons,
  }) : comparisons = comparisons ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'fieldName': fieldName,
      'areaHectares': areaHectares,
      'plantingDate': plantingDate.toIso8601String(),
      'harvestDate': harvestDate.toIso8601String(),
      'yieldInQuintals': yieldInQuintals,
      'yieldPerHectare': yieldPerHectare,
      'season': season,
      'notes': notes,
      'comparisons': comparisons.map((c) => c.toJson()).toList(),
    };
  }

  factory YieldData.fromJson(Map<String, dynamic> json) {
    return YieldData(
      id: json['id'],
      cropName: json['cropName'],
      fieldName: json['fieldName'],
      areaHectares: json['areaHectares'],
      plantingDate: DateTime.parse(json['plantingDate']),
      harvestDate: DateTime.parse(json['harvestDate']),
      yieldInQuintals: json['yieldInQuintals'],
      yieldPerHectare: json['yieldPerHectare'],
      season: json['season'],
      notes: json['notes'] ?? '',
      comparisons: (json['comparisons'] as List)
          .map((c) => YieldComparison.fromJson(c))
          .toList(),
    );
  }

  int get daysToHarvest {
    return harvestDate.difference(plantingDate).inDays;
  }
}

class YieldComparison {
  final int? id;
  final int yieldDataId;
  final String comparedWith; // Previous season, neighboring field, etc.
  final double comparisonYield;
  final double difference;
  final String notes;

  YieldComparison({
    this.id,
    required this.yieldDataId,
    required this.comparedWith,
    required this.comparisonYield,
    required this.difference,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yieldDataId': yieldDataId,
      'comparedWith': comparedWith,
      'comparisonYield': comparisonYield,
      'difference': difference,
      'notes': notes,
    };
  }

  factory YieldComparison.fromJson(Map<String, dynamic> json) {
    return YieldComparison(
      id: json['id'],
      yieldDataId: json['yieldDataId'],
      comparedWith: json['comparedWith'],
      comparisonYield: json['comparisonYield'],
      difference: json['difference'],
      notes: json['notes'] ?? '',
    );
  }
}

class FieldProductivity {
  final int? id;
  final String fieldName;
  final double areaHectares;
  final List<YieldData> yieldHistory;
  final double averageYieldPerHectare;
  final String productivityTrend; // Increasing, Decreasing, Stable

  FieldProductivity({
    this.id,
    required this.fieldName,
    required this.areaHectares,
    List<YieldData>? yieldHistory,
    required this.averageYieldPerHectare,
    required this.productivityTrend,
  }) : yieldHistory = yieldHistory ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldName': fieldName,
      'areaHectares': areaHectares,
      'yieldHistory': yieldHistory.map((y) => y.toJson()).toList(),
      'averageYieldPerHectare': averageYieldPerHectare,
      'productivityTrend': productivityTrend,
    };
  }

  factory FieldProductivity.fromJson(Map<String, dynamic> json) {
    return FieldProductivity(
      id: json['id'],
      fieldName: json['fieldName'],
      areaHectares: json['areaHectares'],
      yieldHistory: (json['yieldHistory'] as List)
          .map((y) => YieldData.fromJson(y))
          .toList(),
      averageYieldPerHectare: json['averageYieldPerHectare'],
      productivityTrend: json['productivityTrend'],
    );
  }
}