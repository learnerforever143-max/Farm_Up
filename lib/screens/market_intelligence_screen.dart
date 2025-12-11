import 'package:flutter/material.dart';
import 'package:farm_up/services/market_service.dart';
import 'package:farm_up/models/market_price.dart';

class MarketIntelligenceScreen extends StatefulWidget {
  const MarketIntelligenceScreen({super.key});

  @override
  State<MarketIntelligenceScreen> createState() => _MarketIntelligenceScreenState();
}

class _MarketIntelligenceScreenState extends State<MarketIntelligenceScreen> {
  final MarketService _marketService = MarketService();
  List<MarketPrice> _marketPrices = [];
  List<PriceForecast> _priceForecasts = [];
  List<Buyer> _buyers = [];
  List<String> _crops = [];
  List<String> _regions = [];
  List<String> _priceAlerts = [];
  Map<String, dynamic> _marketInsights = {};
  String _selectedCrop = 'All';
  String _selectedRegion = 'All';
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _marketService.initializeSampleData();
    _loadMarketData();
  }

  void _loadMarketData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final prices = _marketService.getAllMarketPrices();
      final forecasts = _marketService.getPriceForecasts();
      final buyers = _marketService.getAllBuyers();
      final crops = _marketService.getCrops();
      final regions = _marketService.getRegions();
      final insights = _marketService.getMarketInsights();
      final alerts = _marketService.getPriceAlerts();
      
      setState(() {
        _marketPrices = prices;
        _priceForecasts = forecasts;
        _buyers = buyers;
        _crops = ['All', ...crops];
        _regions = ['All', ...regions];
        _marketInsights = insights;
        _priceAlerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load market data: $e')),
        );
      }
    }
  }

  void _filterByCrop(String crop) {
    setState(() {
      _selectedCrop = crop;
    });
  }

  void _filterByRegion(String region) {
    setState(() {
      _selectedRegion = region;
    });
  }

  void _searchMarketData(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<MarketPrice> _getFilteredPrices() {
    List<MarketPrice> filtered = _marketPrices;
    
    if (_selectedCrop != 'All') {
      filtered = filtered
          .where((price) => price.cropName == _selectedCrop)
          .toList();
    }
    
    if (_selectedRegion != 'All') {
      filtered = filtered
          .where((price) => price.region == _selectedRegion)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((price) =>
              price.cropName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              price.region.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              price.marketName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    return filtered;
  }

  void _viewBuyerDetails(Buyer buyer) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(buyer.companyName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact: ${buyer.name}'),
                Text('Email: ${buyer.contactInfo}'),
                Text('Region: ${buyer.region}'),
                Text('Crops Interested: ${buyer.cropsInterested}'),
                Text('Avg. Transaction Size: \$${buyer.averageTransactionSize.toStringAsFixed(0)}'),
                Row(
                  children: [
                    const Text('Reliability: '),
                    ...List.generate(5, (index) {
                      return Icon(
                        index < buyer.reliabilityRating 
                            ? Icons.star 
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ],
                ),
                Text('Status: ${buyer.verificationStatus}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _contactBuyer(buyer);
                },
                child: const Text('Contact Buyer'),
              ),
            ],
          );
        },
      );
    }
  }

  void _contactBuyer(Buyer buyer) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting you with ${buyer.companyName}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPrices = _getFilteredPrices();
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Market Intelligence'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Prices'),
              Tab(text: 'Buyers'),
              Tab(text: 'Forecasts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Prices Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search crops, regions...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: _searchMarketData,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._crops.map((crop) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(crop),
                            selected: _selectedCrop == crop,
                            onSelected: (_) => _filterByCrop(crop),
                            selectedColor: Colors.green,
                          ),
                        );
                      }),
                      const SizedBox(width: 10),
                      ..._regions.map((region) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(region),
                            selected: _selectedRegion == region,
                            onSelected: (_) => _filterByRegion(region),
                            selectedColor: Colors.green,
                          );
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Price Alerts
                if (_priceAlerts.isNotEmpty)
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _priceAlerts.map((alert) {
                        return Card(
                          color: alert.contains('surged') 
                              ? Colors.green[50] 
                              : alert.contains('dropped') 
                                  ? Colors.red[50] 
                                  : Colors.blue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  alert.contains('surged') 
                                      ? Icons.trending_up 
                                      : alert.contains('dropped') 
                                          ? Icons.trending_down 
                                          : Icons.info,
                                  color: alert.contains('surged') 
                                      ? Colors.green 
                                      : alert.contains('dropped') 
                                          ? Colors.red 
                                          : Colors.blue,
                                ),
                                const SizedBox(width: 5),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    alert,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredPrices.isEmpty
                          ? const Center(
                              child: Text(
                                'No market prices found',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filteredPrices.length,
                              itemBuilder: (context, index) {
                                final price = filteredPrices[index];
                                return Card(
                                  child: ListTile(
                                    title: Text('${price.cropName} - ${price.region}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${price.marketName}'),
                                        Text(
                                          '${price.price} ${price.currency}/${price.unit}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              price.priceChange >= 0 ? '+' : '',
                                              style: TextStyle(
                                                color: price.priceChange >= 0 
                                                    ? Colors.green 
                                                    : Colors.red,
                                              ),
                                            ),
                                            Text(
                                              '${price.priceChange.toStringAsFixed(2)} ',
                                              style: TextStyle(
                                                color: price.priceChange >= 0 
                                                    ? Colors.green 
                                                    : Colors.red,
                                              ),
                                            ),
                                            Text(
                                              '(${price.priceChangePercentage.toStringAsFixed(1)}%)',
                                              style: TextStyle(
                                                color: price.priceChange >= 0 
                                                    ? Colors.green 
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          price.priceTrend == 'up' 
                                              ? Icons.trending_up 
                                              : price.priceTrend == 'down' 
                                                  ? Icons.trending_down 
                                                  : Icons.trending_flat,
                                          color: price.priceTrend == 'up' 
                                              ? Colors.green 
                                              : price.priceTrend == 'down' 
                                                  ? Colors.red 
                                                  : Colors.grey,
                                        ),
                                        Text(
                                          price.qualityGrade,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            
            // Buyers Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search buyers...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: (query) {
                      // In a real app, this would filter the buyers list
                    },
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buyers.isEmpty
                          ? const Center(
                              child: Text(
                                'No buyers found',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: _buyers.length,
                              itemBuilder: (context, index) {
                                final buyer = _buyers[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(buyer.companyName),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(buyer.name),
                                        Text(buyer.region),
                                        Text(buyer.cropsInterested),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...List.generate(5, (starIndex) {
                                          return Icon(
                                            starIndex < buyer.reliabilityRating 
                                                ? Icons.star 
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                                        }),
                                        const SizedBox(width: 5),
                                        Icon(
                                          buyer.verificationStatus == 'Verified' 
                                              ? Icons.verified 
                                              : Icons.report,
                                          color: buyer.verificationStatus == 'Verified' 
                                              ? Colors.green 
                                              : Colors.grey,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    onTap: () => _viewBuyerDetails(buyer),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            
            // Forecasts Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Forecasts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_priceForecasts.isEmpty)
                      const Center(
                        child: Text(
                          'No forecasts available',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _priceForecasts.length,
                        itemBuilder: (context, index) {
                          final forecast = _priceForecasts[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${forecast.cropName} - ${forecast.region}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(forecast.confidenceLevel),
                                        backgroundColor: forecast.confidenceLevel == 'High' 
                                            ? Colors.green[300] 
                                            : forecast.confidenceLevel == 'Medium' 
                                                ? Colors.orange[300] 
                                                : Colors.red[300],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Predicted Price: ${forecast.predictedPrice} ${_marketPrices.first.currency}/${_marketPrices.first.unit}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Forecast Date: ${forecast.forecastDate.toString().split(' ').first}'),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Factors:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(forecast.factors),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}