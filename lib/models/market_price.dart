class MarketPrice {
  final int? id;
  final String cropName;
  final String region;
  final double price;
  final String currency;
  final String unit; // kg, quintal, ton, etc.
  final DateTime recordedDate;
  final double previousPrice;
  final String marketName;
  final String qualityGrade; // Premium, Standard, Low
  final int supplyIndex; // 1-10 scale
  final int demandIndex; // 1-10 scale

  MarketPrice({
    this.id,
    required this.cropName,
    required this.region,
    required this.price,
    this.currency = 'USD',
    this.unit = 'kg',
    required this.recordedDate,
    required this.previousPrice,
    required this.marketName,
    this.qualityGrade = 'Standard',
    required this.supplyIndex,
    required this.demandIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'region': region,
      'price': price,
      'currency': currency,
      'unit': unit,
      'recordedDate': recordedDate.toIso8601String(),
      'previousPrice': previousPrice,
      'marketName': marketName,
      'qualityGrade': qualityGrade,
      'supplyIndex': supplyIndex,
      'demandIndex': demandIndex,
    };
  }

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      id: json['id'],
      cropName: json['cropName'],
      region: json['region'],
      price: json['price'],
      currency: json['currency'] ?? 'USD',
      unit: json['unit'] ?? 'kg',
      recordedDate: DateTime.parse(json['recordedDate']),
      previousPrice: json['previousPrice'],
      marketName: json['marketName'],
      qualityGrade: json['qualityGrade'] ?? 'Standard',
      supplyIndex: json['supplyIndex'],
      demandIndex: json['demandIndex'],
    );
  }

  double get priceChange {
    return price - previousPrice;
  }

  double get priceChangePercentage {
    if (previousPrice == 0) return 0.0;
    return (priceChange / previousPrice) * 100;
  }

  String get priceTrend {
    if (priceChange > 0) return 'up';
    if (priceChange < 0) return 'down';
    return 'stable';
  }
}

class PriceForecast {
  final int? id;
  final String cropName;
  final String region;
  final DateTime forecastDate;
  final double predictedPrice;
  final String confidenceLevel; // High, Medium, Low
  final String factors; // Factors affecting the forecast

  PriceForecast({
    this.id,
    required this.cropName,
    required this.region,
    required this.forecastDate,
    required this.predictedPrice,
    this.confidenceLevel = 'Medium',
    required this.factors,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'region': region,
      'forecastDate': forecastDate.toIso8601String(),
      'predictedPrice': predictedPrice,
      'confidenceLevel': confidenceLevel,
      'factors': factors,
    };
  }

  factory PriceForecast.fromJson(Map<String, dynamic> json) {
    return PriceForecast(
      id: json['id'],
      cropName: json['cropName'],
      region: json['region'],
      forecastDate: DateTime.parse(json['forecastDate']),
      predictedPrice: json['predictedPrice'],
      confidenceLevel: json['confidenceLevel'] ?? 'Medium',
      factors: json['factors'],
    );
  }
}

class Buyer {
  final int? id;
  final String name;
  final String companyName;
  final String contactInfo;
  final String region;
  final String cropsInterested; // Comma-separated list
  final double averageTransactionSize;
  final int reliabilityRating; // 1-5 scale
  final String verificationStatus; // Verified, Unverified

  Buyer({
    this.id,
    required this.name,
    required this.companyName,
    required this.contactInfo,
    required this.region,
    required this.cropsInterested,
    required this.averageTransactionSize,
    required this.reliabilityRating,
    this.verificationStatus = 'Unverified',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'contactInfo': contactInfo,
      'region': region,
      'cropsInterested': cropsInterested,
      'averageTransactionSize': averageTransactionSize,
      'reliabilityRating': reliabilityRating,
      'verificationStatus': verificationStatus,
    };
  }

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'],
      name: json['name'],
      companyName: json['companyName'],
      contactInfo: json['contactInfo'],
      region: json['region'],
      cropsInterested: json['cropsInterested'],
      averageTransactionSize: json['averageTransactionSize'],
      reliabilityRating: json['reliabilityRating'],
      verificationStatus: json['verificationStatus'] ?? 'Unverified',
    );
  }
}