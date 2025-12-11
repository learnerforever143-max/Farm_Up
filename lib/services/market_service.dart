import 'package:farm_up/models/market_price.dart';

class MarketService {
  List<MarketPrice> _marketPrices = [];
  List<PriceForecast> _priceForecasts = [];
  List<Buyer> _buyers = [];
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample market prices
    final wheatPrice1 = MarketPrice(
      id: 1,
      cropName: 'Wheat',
      region: 'Midwest',
      price: 250.50,
      currency: 'USD',
      unit: 'quintal',
      recordedDate: DateTime.now(),
      previousPrice: 245.75,
      marketName: 'Chicago Grain Exchange',
      qualityGrade: 'Premium',
      supplyIndex: 7,
      demandIndex: 8,
    );
    
    final wheatPrice2 = MarketPrice(
      id: 2,
      cropName: 'Wheat',
      region: 'Great Plains',
      price: 248.25,
      currency: 'USD',
      unit: 'quintal',
      recordedDate: DateTime.now(),
      previousPrice: 252.30,
      marketName: 'Kansas City Board of Trade',
      qualityGrade: 'Standard',
      supplyIndex: 8,
      demandIndex: 6,
    );
    
    final ricePrice1 = MarketPrice(
      id: 3,
      cropName: 'Rice',
      region: 'California',
      price: 45.80,
      currency: 'USD',
      unit: 'kg',
      recordedDate: DateTime.now(),
      previousPrice: 44.90,
      marketName: 'California Rice Exchange',
      qualityGrade: 'Premium',
      supplyIndex: 6,
      demandIndex: 9,
    );
    
    final cornPrice1 = MarketPrice(
      id: 4,
      cropName: 'Corn',
      region: 'Iowa',
      price: 185.60,
      currency: 'USD',
      unit: 'quintal',
      recordedDate: DateTime.now(),
      previousPrice: 182.40,
      marketName: 'Chicago Board of Trade',
      qualityGrade: 'Standard',
      supplyIndex: 7,
      demandIndex: 7,
    );
    
    // Sample price forecasts
    final wheatForecast = PriceForecast(
      id: 1,
      cropName: 'Wheat',
      region: 'National',
      forecastDate: DateTime.now().add(const Duration(days: 30)),
      predictedPrice: 255.00,
      confidenceLevel: 'High',
      factors: 'Expected decrease in supply due to drought conditions in key growing regions',
    );
    
    final riceForecast = PriceForecast(
      id: 2,
      cropName: 'Rice',
      region: 'National',
      forecastDate: DateTime.now().add(const Duration(days: 30)),
      predictedPrice: 48.50,
      confidenceLevel: 'Medium',
      factors: 'Anticipated increase in demand from export markets',
    );
    
    // Sample buyers
    final buyer1 = Buyer(
      id: 1,
      name: 'John Smith',
      companyName: 'Global Grains Ltd.',
      contactInfo: 'john@globalgrains.com',
      region: 'Midwest',
      cropsInterested: 'Wheat, Corn, Soybeans',
      averageTransactionSize: 50000.0,
      reliabilityRating: 5,
      verificationStatus: 'Verified',
    );
    
    final buyer2 = Buyer(
      id: 2,
      name: 'Maria Garcia',
      companyName: 'Fresh Foods International',
      contactInfo: 'maria@freshfoods.com',
      region: 'West Coast',
      cropsInterested: 'Rice, Vegetables',
      averageTransactionSize: 25000.0,
      reliabilityRating: 4,
      verificationStatus: 'Verified',
    );
    
    _marketPrices = [wheatPrice1, wheatPrice2, ricePrice1, cornPrice1];
    _priceForecasts = [wheatForecast, riceForecast];
    _buyers = [buyer1, buyer2];
  }
  
  // Get all market prices
  List<MarketPrice> getAllMarketPrices() {
    return List.from(_marketPrices);
  }
  
  // Get market prices by crop
  List<MarketPrice> getMarketPricesByCrop(String cropName) {
    return _marketPrices
        .where((price) => price.cropName.toLowerCase() == cropName.toLowerCase())
        .toList();
  }
  
  // Get market prices by region
  List<MarketPrice> getMarketPricesByRegion(String region) {
    return _marketPrices
        .where((price) => price.region.toLowerCase() == region.toLowerCase())
        .toList();
  }
  
  // Get price history for a crop in a region
  List<MarketPrice> getPriceHistory(String cropName, String region) {
    return _marketPrices
        .where((price) => 
            price.cropName.toLowerCase() == cropName.toLowerCase() &&
            price.region.toLowerCase() == region.toLowerCase())
        .toList()
      ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
  }
  
  // Get price forecasts
  List<PriceForecast> getPriceForecasts() {
    return List.from(_priceForecasts);
  }
  
  // Get price forecast by crop
  List<PriceForecast> getPriceForecastsByCrop(String cropName) {
    return _priceForecasts
        .where((forecast) => forecast.cropName.toLowerCase() == cropName.toLowerCase())
        .toList();
  }
  
  // Get all buyers
  List<Buyer> getAllBuyers() {
    return List.from(_buyers);
  }
  
  // Get buyers interested in a specific crop
  List<Buyer> getBuyersByCrop(String cropName) {
    return _buyers
        .where((buyer) => 
            buyer.cropsInterested.toLowerCase().contains(cropName.toLowerCase()))
        .toList();
  }
  
  // Get buyers by region
  List<Buyer> getBuyersByRegion(String region) {
    return _buyers
        .where((buyer) => buyer.region.toLowerCase() == region.toLowerCase())
        .toList();
  }
  
  // Search market prices
  List<MarketPrice> searchMarketPrices(String query) {
    return _marketPrices
        .where((price) =>
            price.cropName.toLowerCase().contains(query.toLowerCase()) ||
            price.region.toLowerCase().contains(query.toLowerCase()) ||
            price.marketName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  // Search buyers
  List<Buyer> searchBuyers(String query) {
    return _buyers
        .where((buyer) =>
            buyer.name.toLowerCase().contains(query.toLowerCase()) ||
            buyer.companyName.toLowerCase().contains(query.toLowerCase()) ||
            buyer.region.toLowerCase().contains(query.toLowerCase()) ||
            buyer.cropsInterested.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  // Get unique crops
  List<String> getCrops() {
    final crops = <String>{};
    for (final price in _marketPrices) {
      crops.add(price.cropName);
    }
    return crops.toList();
  }
  
  // Get unique regions
  List<String> getRegions() {
    final regions = <String>{};
    for (final price in _marketPrices) {
      regions.add(price.region);
    }
    return regions.toList();
  }
  
  // Get market insights
  Map<String, dynamic> getMarketInsights() {
    final insights = <String, dynamic>{};
    
    // Calculate average prices by crop
    final priceMap = <String, List<double>>{};
    for (final price in _marketPrices) {
      if (priceMap.containsKey(price.cropName)) {
        priceMap[price.cropName]!.add(price.price);
      } else {
        priceMap[price.cropName] = [price.price];
      }
    }
    
    final avgPrices = <String, double>{};
    priceMap.forEach((crop, prices) {
      final sum = prices.reduce((a, b) => a + b);
      avgPrices[crop] = sum / prices.length;
    });
    
    insights['averagePrices'] = avgPrices;
    insights['totalListings'] = _marketPrices.length;
    insights['totalBuyers'] = _buyers.length;
    
    return insights;
  }
  
  // Get price alerts
  List<String> getPriceAlerts() {
    final alerts = <String>[];
    
    for (final price in _marketPrices) {
      if (price.priceChangePercentage > 5.0) {
        alerts.add(
          '${price.cropName} prices surged by ${price.priceChangePercentage.toStringAsFixed(1)}% in ${price.region}'
        );
      } else if (price.priceChangePercentage < -5.0) {
        alerts.add(
          '${price.cropName} prices dropped by ${(-price.priceChangePercentage).toStringAsFixed(1)}% in ${price.region}'
        );
      }
    }
    
    if (alerts.isEmpty) {
      alerts.add('No significant price movements at this time');
    }
    
    return alerts;
  }
}