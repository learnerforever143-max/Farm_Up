import 'package:flutter/material.dart';
import 'package:farm_up/widgets/soil_analysis_form.dart';
import 'package:farm_up/widgets/crop_recommendations_list.dart';
import 'package:farm_up/models/crop_recommendation.dart';
import 'package:farm_up/models/market_price.dart';
import 'package:farm_up/screens/soil_analysis_screen.dart';
import 'package:farm_up/screens/budget_calculator_screen.dart';
import 'package:farm_up/screens/weather_screen.dart';
import 'package:farm_up/screens/water_management_screen.dart';
import 'package:farm_up/screens/disease_detection_screen.dart';
import 'package:farm_up/screens/video_library_screen.dart';
import 'package:farm_up/screens/livestock_management_screen.dart';
import 'package:farm_up/screens/equipment_marketplace_screen.dart';
import 'package:farm_up/screens/market_intelligence_screen.dart';
import 'package:farm_up/screens/yield_tracking_screen.dart';
import 'package:farm_up/screens/government_schemes_screen.dart';
import 'package:farm_up/screens/inventory_management_screen.dart';
import 'package:farm_up/screens/insurance_management_screen.dart';
import 'package:farm_up/screens/organic_certification_screen.dart';
import 'package:farm_up/screens/community_screen.dart';
import 'package:farm_up/screens/supply_chain_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<CropRecommendation> _recommendations = [];

  void _handleResults(List<CropRecommendation> recommendations) {
    setState(() {
      _recommendations = recommendations;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daily Insights',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather Alert: Rain expected tomorrow',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Temperature: 28°C, Humidity: 75%'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title: const Text('Soil Analysis'),
                subtitle: const Text('Analyze soil and get crop recommendations'),
                leading: const Icon(Icons.grain, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to soil analysis screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SoilAnalysisScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Budget Calculator'),
                subtitle: const Text('Track expenses and calculate profits'),
                leading: const Icon(Icons.calculate, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to budget calculator screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BudgetCalculatorScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Weather Forecast'),
                subtitle: const Text('7-day forecast and agricultural advice'),
                leading: const Icon(Icons.wb_sunny, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to weather screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WeatherScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Water Management'),
                subtitle: const Text('Irrigation scheduling and conservation'),
                leading: const Icon(Icons.water_damage, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to water management screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WaterManagementScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Disease Detection'),
                subtitle: const Text('AI-powered plant disease diagnosis'),
                leading: const Icon(Icons.biotech, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to disease detection screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiseaseDetectionScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Video Library'),
                subtitle: const Text('Farming tutorials and expert guides'),
                leading: const Icon(Icons.video_library, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to video library screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoLibraryScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Livestock Management'),
                subtitle: const Text('Track animal health and breeding'),
                leading: const Icon(Icons.pets, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to livestock management screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LivestockManagementScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Equipment Marketplace'),
                subtitle: const Text('Buy or rent farming tools and machinery'),
                leading: const Icon(Icons.agriculture, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to equipment marketplace screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EquipmentMarketplaceScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Market Intelligence'),
                subtitle: const Text('Crop prices, buyers, and forecasts'),
                leading: const Icon(Icons.show_chart, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to market intelligence screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MarketIntelligenceScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Yield Tracking'),
                subtitle: const Text('Analytics and productivity monitoring'),
                leading: const Icon(Icons.analytics, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to yield tracking screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YieldTrackingScreen(),
                    );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Government Schemes'),
                subtitle: const Text('Subsidies, loans, and support programs'),
                leading: const Icon(Icons.account_balance, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to government schemes screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GovernmentSchemesScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Inventory Management'),
                subtitle: const Text('Track seeds, fertilizers, and supplies'),
                leading: const Icon(Icons.inventory, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to inventory management screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InventoryManagementScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Insurance & Risk'),
                subtitle: const Text('Manage policies and assess risks'),
                leading: const Icon(Icons.security, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to insurance management screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InsuranceManagementScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Organic Certification'),
                subtitle: const Text('Manage organic certification process'),
                leading: const Icon(Icons.eco, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to organic certification screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrganicCertificationScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Supply Chain & Traceability'),
                subtitle: const Text('Track products from farm to market'),
                leading: const Icon(Icons.track_changes, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to supply chain screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupplyChainScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Farmer Community'),
                subtitle: const Text('Connect with other farmers'),
                leading: const Icon(Icons.groups, color: Colors.green),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to community screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SoilAnalysisForm(onResults: _handleResults),
            const SizedBox(height: 20),
            const Text(
              'Recommended Crops',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: CropRecommendationsList(recommendations: _recommendations),
            ),
          ],
        ),
      ),
    );
  }
}