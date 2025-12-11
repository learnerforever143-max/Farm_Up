import 'package:flutter/material.dart';
import 'package:farm_up/services/supply_chain_service.dart';
import 'package:farm_up/models/supply_chain.dart';

class SupplyChainScreen extends StatefulWidget {
  const SupplyChainScreen({super.key});

  @override
  State<SupplyChainScreen> createState() => _SupplyChainScreenState();
}

class _SupplyChainScreenState extends State<SupplyChainScreen> {
  final SupplyChainService _supplyChainService = SupplyChainService();
  List<SupplyChainRecord> _supplyChainRecords = [];
  List<QualityCertificate> _qualityCertificates = [];
  List<BuyerVerification> _buyerVerifications = [];
  Map<String, dynamic> _supplyChainStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _supplyChainService.initializeSampleData();
    _loadSupplyChainData();
  }

  void _loadSupplyChainData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final records = _supplyChainService.getAllSupplyChainRecords();
      final certificates = _supplyChainService.getAllQualityCertificates();
      final buyers = _supplyChainService.getAllBuyerVerifications();
      final stats = _supplyChainService.getSupplyChainStats();
      
      setState(() {
        _supplyChainRecords = records;
        _qualityCertificates = certificates;
        _buyerVerifications = buyers;
        _supplyChainStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load supply chain data: $e')),
        );
      }
    }
  }

  void _addSupplyChainRecord() {
    // In a real app, this would open a form to add new supply chain record
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding new supply chain record...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Supply Chain & Traceability'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Products'),
              Tab(text: 'Certificates'),
              Tab(text: 'Buyers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Overview Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Supply Chain Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Key Metrics
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildMetricCard(
                              'Total Products',
                              '${_supplyChainStats['totalRecords'] ?? 0}',
                              Icons.inventory,
                              Colors.green,
                            ),
                            const SizedBox(width: 10),
                            _buildMetricCard(
                              'Active',
                              '${_supplyChainStats['activeRecords'] ?? 0}',
                              Icons.hourglass_empty,
                              Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            _buildMetricCard(
                              'Verified Buyers',
                              '${_supplyChainStats['verifiedBuyers'] ?? 0}',
                              Icons.verified,
                              Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            _buildMetricCard(
                              'Valid Certificates',
                              '${_supplyChainStats['activeCertificates'] ?? 0}',
                              Icons.card_membership,
                              Colors.purple,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Status Distribution
                      const Text(
                        'Product Status Distribution',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if ((_supplyChainStats['statusDistribution'] as Map?)?.isEmpty ?? true)
                        const Center(
                          child: Text('No status distribution data available'),
                        )
                      else
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: (_supplyChainStats['statusDistribution'] as Map?)
                                  ?.entries
                                  .map((entry) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(entry.key),
                                            Text('${entry.value} products'),
                                          ],
                                        ),
                                      ))
                                  .toList() ??
                                  [],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Recent Activity
                      const Text(
                        'Recent Traceability Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_supplyChainRecords.isEmpty)
                        const Center(
                          child: Text('No traceability events available'),
                        )
                      else
                        ..._supplyChainRecords.take(3).expand((record) {
                          return record.traceabilityEvents.reversed.take(2).map((event) {
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  event.eventType == 'Harvest'
                                      ? Icons.grain
                                      : event.eventType == 'Processing'
                                          ? Icons.build
                                          : event.eventType == 'Packaging'
                                              ? Icons.inventory_2
                                              : event.eventType == 'Transport'
                                                  ? Icons.local_shipping
                                                  : Icons.check_circle,
                                  color: Colors.green,
                                ),
                                title: Text('${event.eventType} - ${record.productName}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(event.location),
                                    Text(
                                      event.eventDate.toString().split(' ').first,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: Text(event.handler),
                              ),
                            );
                          }).toList();
                        }),
                    ],
                  ],
                ),
              ),
            ),
            
            // Products Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tracked Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_supplyChainRecords.isEmpty)
                      const Center(
                        child: Text('No products in supply chain'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _supplyChainRecords.length,
                        itemBuilder: (context, index) {
                          final record = _supplyChainRecords[index];
                          return Card(
                            child: ExpansionTile(
                              title: Text(record.productName),
                              subtitle: Text('${record.formattedQuantity} - ${record.status}'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Product ID:'),
                                          Text(record.productId),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Farm:'),
                                          Text(record.farmName),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Harvest Date:'),
                                          Text(record.harvestDate.toString().split(' ').first),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Quality Grade:'),
                                          Text(
                                            record.qualityGrade,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: record.qualityGrade == 'Premium'
                                                  ? Colors.green
                                                  : record.qualityGrade == 'Standard'
                                                      ? Colors.orange
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Current Location:'),
                                          Text(record.currentLocation),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Handler:'),
                                          Text(record.currentHandler),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Traceability Events:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      ...record.traceabilityEvents.map((event) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                event.eventType == 'Harvest'
                                                    ? Icons.grain
                                                    : event.eventType == 'Processing'
                                                        ? Icons.build
                                                        : event.eventType == 'Packaging'
                                                            ? Icons.inventory_2
                                                            : event.eventType == 'Transport'
                                                                ? Icons.local_shipping
                                                                : Icons.check_circle,
                                                size: 16,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 5),
                                              Text('${event.eventType} on ${event.eventDate.toString().split(' ').first}'),
                                              const Spacer(),
                                              Text(event.location),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            
            // Certificates Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quality Certificates',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_qualityCertificates.isEmpty)
                      const Center(
                        child: Text('No quality certificates available'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _qualityCertificates.length,
                        itemBuilder: (context, index) {
                          final certificate = _qualityCertificates[index];
                          final record = _supplyChainService.getSupplyChainRecordById(
                              certificate.supplyChainRecordId);
                          return Card(
                            color: certificate.isValid ? Colors.green[50] : Colors.red[50],
                            child: ListTile(
                              title: Text('${certificate.certificateType} Certificate'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${certificate.certificateNumber}'),
                                  Text('Product: ${record?.productName ?? 'Unknown'}'),
                                  Text(
                                    'Status: ${certificate.status} ${certificate.isValid ? '(Valid)' : '(Invalid)'}',
                                    style: TextStyle(
                                      color: certificate.isValid ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Expires: ${certificate.expiryDate.toString().split(' ').first}',
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                certificate.isValid ? Icons.verified : Icons.warning,
                                color: certificate.isValid ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            
            // Buyers Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verified Buyers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_buyerVerifications.isEmpty)
                      const Center(
                        child: Text('No buyer verifications available'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _buyerVerifications.length,
                        itemBuilder: (context, index) {
                          final buyer = _buyerVerifications[index];
                          return Card(
                            color: buyer.isVerified ? Colors.green[50] : Colors.grey[100],
                            child: ListTile(
                              title: Text(buyer.buyerName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(buyer.companyName),
                                  Text(
                                    'Status: ${buyer.verificationStatus}',
                                    style: TextStyle(
                                      color: buyer.isVerified ? Colors.green : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Verified on: ${buyer.verificationDate.toString().split(' ').first}',
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                buyer.isVerified ? Icons.verified : Icons.pending,
                                color: buyer.isVerified ? Colors.green : Colors.orange,
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
        floatingActionButton: FloatingActionButton(
          onPressed: _addSupplyChainRecord,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: color,
      child: SizedBox(
        width: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}