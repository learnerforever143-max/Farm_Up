import 'package:flutter/material.dart';
import 'package:farm_up/services/government_schemes_service.dart';
import 'package:farm_up/models/government_scheme.dart';

class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() => _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen> {
  final GovernmentSchemesService _schemeService = GovernmentSchemesService();
  List<GovernmentScheme> _schemes = [];
  List<SubsidyTracker> _subsidyTrackers = [];
  List<String> _categories = [];
  List<String> _regions = [];
  List<String> _schemeAlerts = [];
  String _selectedCategory = 'All';
  String _selectedRegion = 'All';
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _schemeService.initializeSampleData();
    _loadSchemeData();
  }

  void _loadSchemeData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final schemes = _schemeService.getActiveSchemes();
      final trackers = _schemeService.getSubsidyTrackersByFarmer('FARMER001');
      final categories = _schemeService.getCategories();
      final regions = _schemeService.getRegions();
      final alerts = _schemeService.getSchemeAlerts();
      
      setState(() {
        _schemes = schemes;
        _subsidyTrackers = trackers;
        _categories = ['All', ...categories];
        _regions = ['All', ...regions];
        _schemeAlerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load scheme data: $e')),
        );
      }
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _filterByRegion(String region) {
    setState(() {
      _selectedRegion = region;
    });
  }

  void _searchSchemes(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<GovernmentScheme> _getFilteredSchemes() {
    List<GovernmentScheme> filtered = _schemes;
    
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((scheme) => scheme.category == _selectedCategory)
          .toList();
    }
    
    if (_selectedRegion != 'All') {
      filtered = filtered
          .where((scheme) => scheme.region == _selectedRegion)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((scheme) =>
              scheme.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              scheme.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    return filtered;
  }

  void _viewSchemeDetails(GovernmentScheme scheme) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(scheme.name),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheme.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text('Category: ${scheme.category}'),
                  Text('Region: ${scheme.region}'),
                  Text(
                    'Maximum Benefit: ${scheme.maxValue} ${scheme.currency}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Eligibility Criteria:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(scheme.eligibilityCriteria),
                  const SizedBox(height: 10),
                  const Text(
                    'Application Process:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(scheme.applicationProcess),
                  const SizedBox(height: 10),
                  const Text(
                    'Contact:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(scheme.contactInfo),
                  if (scheme.website.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text('Website: ${scheme.website}'),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        scheme.isCurrentlyActive 
                            ? Icons.check_circle 
                            : scheme.isExpired 
                                ? Icons.cancel 
                                : Icons.schedule,
                        color: scheme.isCurrentlyActive 
                            ? Colors.green 
                            : scheme.isExpired 
                                ? Colors.red 
                                : Colors.orange,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        scheme.isCurrentlyActive 
                            ? 'Currently Active' 
                            : scheme.isExpired 
                                ? 'Expired' 
                                : 'Upcoming',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _applyForScheme(scheme);
                },
                child: const Text('Apply Now'),
              ),
            ],
          );
        },
      );
    }
  }

  void _applyForScheme(GovernmentScheme scheme) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application process for ${scheme.name} initiated'),
        ),
      );
    }
  }

  void _calculateLoanEligibility() {
    // In a real app, this would open a form to collect farmer details
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening loan eligibility calculator...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchemes = _getFilteredSchemes();
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Government Schemes'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Schemes'),
              Tab(text: 'My Applications'),
              Tab(text: 'Loan Calculator'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Schemes Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search schemes...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: _searchSchemes,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) => _filterByCategory(category),
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
                // Scheme Alerts
                if (_schemeAlerts.isNotEmpty)
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _schemeAlerts.map((alert) {
                        return Card(
                          color: Colors.blue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.info, color: Colors.blue),
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
                      : filteredSchemes.isEmpty
                          ? const Center(
                              child: Text(
                                'No government schemes found',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filteredSchemes.length,
                              itemBuilder: (context, index) {
                                final scheme = filteredSchemes[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(scheme.name),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(scheme.description),
                                        Text(
                                          '${scheme.category} - ${scheme.region}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${scheme.maxValue} ${scheme.currency}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Icon(
                                          scheme.isCurrentlyActive 
                                              ? Icons.check_circle 
                                              : scheme.isExpired 
                                                  ? Icons.cancel 
                                                  : Icons.schedule,
                                          color: scheme.isCurrentlyActive 
                                              ? Colors.green 
                                              : scheme.isExpired 
                                                  ? Colors.red 
                                                  : Colors.orange,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    onTap: () => _viewSchemeDetails(scheme),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            
            // My Applications Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Subsidy Applications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_subsidyTrackers.isEmpty)
                      const Center(
                        child: Text('No applications submitted yet'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _subsidyTrackers.length,
                        itemBuilder: (context, index) {
                          final tracker = _subsidyTrackers[index];
                          // Get scheme details for this tracker
                          final scheme = _schemeService.getSchemeById(tracker.schemeId);
                          
                          return Card(
                            child: ListTile(
                              title: Text(scheme?.name ?? 'Unknown Scheme'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Applied: \$${tracker.appliedAmount.toStringAsFixed(0)}'),
                                  if (tracker.approvedAmount > 0)
                                    Text('Approved: \$${tracker.approvedAmount.toStringAsFixed(0)}'),
                                  Text('Status: ${tracker.status}'),
                                  Text(
                                    'Date: ${tracker.applicationDate.toString().split(' ').first}',
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                tracker.status == 'Disbursed' 
                                    ? Icons.check_circle 
                                    : tracker.status == 'Approved' 
                                        ? Icons.done 
                                        : tracker.status == 'Rejected' 
                                            ? Icons.cancel 
                                            : Icons.schedule,
                                color: tracker.status == 'Disbursed' 
                                    ? Colors.green 
                                    : tracker.status == 'Approved' 
                                        ? Colors.blue 
                                        : tracker.status == 'Rejected' 
                                            ? Colors.red 
                                            : Colors.orange,
                              ),
                              onTap: () {
                                // Show tracker details
                                if (mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(scheme?.name ?? 'Scheme Details'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Applied Amount: \$${tracker.appliedAmount.toStringAsFixed(0)}'),
                                            if (tracker.approvedAmount > 0)
                                              Text('Approved Amount: \$${tracker.approvedAmount.toStringAsFixed(0)}'),
                                            Text('Status: ${tracker.status}'),
                                            Text('Application Date: ${tracker.applicationDate.toString().split(' ').first}'),
                                            if (tracker.notes.isNotEmpty)
                                              Text('Notes: ${tracker.notes}'),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            
            // Loan Calculator Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loan Eligibility Calculator',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Calculate your eligibility for agricultural loans',
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
                              Icons.calculate,
                              size: 50,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Enter your details to calculate loan eligibility',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _calculateLoanEligibility,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                              ),
                              child: const Text(
                                'Calculate Eligibility',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Popular Loan Schemes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Card(
                      child: ListTile(
                        title: Text('Kisan Credit Card (KCC)'),
                        subtitle: Text('Short-term credit for crop cultivation'),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        title: Text('Micro Irrigation Fund'),
                        subtitle: Text('Subsidy for drip and sprinkler irrigation systems'),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        title: Text('Agriculture Infrastructure Fund'),
                        subtitle: Text('Investment in post-harvest infrastructure'),
                      ),
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