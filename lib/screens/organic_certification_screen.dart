import 'package:flutter/material.dart';
import 'package:farm_up/services/organic_certification_service.dart';
import 'package:farm_up/models/organic_certification.dart';

class OrganicCertificationScreen extends StatefulWidget {
  const OrganicCertificationScreen({super.key});

  @override
  State<OrganicCertificationScreen> createState() => _OrganicCertificationScreenState();
}

class _OrganicCertificationScreenState extends State<OrganicCertificationScreen> {
  final OrganicCertificationService _certificationService = OrganicCertificationService();
  List<OrganicCertification> _certifications = [];
  List<String> _certificationAlerts = [];
  List<Map<String, dynamic>> _complianceChecklist = [];
  Map<String, dynamic> _certificationStats = {};
  List<String> _certificationBodies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _certificationService.initializeSampleData();
    _loadCertificationData();
  }

  void _loadCertificationData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final certifications = _certificationService.getCertificationsByFarmer('FARMER001');
      final alerts = _certificationService.getCertificationAlerts('FARMER001');
      final checklist = _certificationService.generateComplianceChecklist('FARMER001');
      final stats = _certificationService.getCertificationStats('FARMER001');
      final bodies = _certificationService.getCertificationBodies();
      
      setState(() {
        _certifications = certifications;
        _certificationAlerts = alerts;
        _complianceChecklist = checklist;
        _certificationStats = stats;
        _certificationBodies = bodies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load certification data: $e')),
        );
      }
    }
  }

  void _viewCertificationDetails(OrganicCertification certification) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${certification.farmName} Certification'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certification.certificationBody,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Certification #: ${certification.certificationNumber}'),
                  Text('Area: ${certification.farmAreaHectares} hectares'),
                  Text('Issue Date: ${certification.certificationDate.toString().split(' ').first}'),
                  Text('Expiry Date: ${certification.expiryDate.toString().split(' ').first}'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        certification.isCertified 
                            ? Icons.verified 
                            : Icons.warning,
                        color: certification.isCertified 
                            ? Colors.green 
                            : Colors.orange,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        certification.isCertified 
                            ? 'Certified' 
                            : 'Not Certified',
                        style: TextStyle(
                          color: certification.isCertified 
                              ? Colors.green 
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (certification.isCertified && certification.isExpiringSoon) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Expires in ${certification.daysUntilExpiry} days',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  const Text(
                    'Organic Practices:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...certification.organicPractices.map((practice) => Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Icon(
                              practice.isCompliant 
                                  ? Icons.check_circle 
                                  : Icons.cancel,
                              color: practice.isCompliant 
                                  ? Colors.green 
                                  : Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(practice.practiceName),
                          ],
                        ),
                      )),
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
                  _renewCertification(certification);
                },
                child: const Text('Renew'),
              ),
            ],
          );
        },
      );
    }
  }

  void _renewCertification(OrganicCertification certification) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Renewing certification for ${certification.farmName}...')),
      );
    }
  }

  void _startCertificationProcess() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Starting organic certification process...')),
      );
    }
  }

  void _viewComplianceChecklist() {
    if (mounted) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Compliance Checklist',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Requirements for Organic Certification'),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _complianceChecklist.length,
                    itemBuilder: (context, index) {
                      final item = _complianceChecklist[index];
                      final requirement = item['requirement'] as CertificationRequirement;
                      final completed = item['completed'] as bool;
                      final evidenceProvided = item['evidenceProvided'] as bool;
                      
                      return Card(
                        child: ListTile(
                          title: Text(requirement.requirementName),
                          subtitle: Text(requirement.description),
                          trailing: Icon(
                            completed 
                                ? Icons.check_circle 
                                : Icons.radio_button_unchecked,
                            color: completed ? Colors.green : Colors.grey,
                          ),
                          onTap: () {
                            // Show requirement details
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(requirement.requirementName),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Category: ${requirement.category}'),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Description:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(requirement.description),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Evidence Required:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(requirement.evidenceRequired),
                                        if (item['notes'] != null && item['notes'] != '') ...[
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Your Notes:',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(item['notes']),
                                        ],
                                        if (completed) ...[
                                          const SizedBox(height: 10),
                                          Icon(
                                            evidenceProvided 
                                                ? Icons.verified 
                                                : Icons.warning,
                                            color: evidenceProvided 
                                                ? Colors.green 
                                                : Colors.orange,
                                          ),
                                          Text(
                                            evidenceProvided 
                                                ? 'Evidence Provided' 
                                                : 'Evidence Needed',
                                          ),
                                        ],
                                      ],
                                    ),
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
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Organic Certification'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Certificates'),
              Tab(text: 'Compliance'),
              Tab(text: 'Requirements'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Certificates Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organic Certifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Certification Stats
                      if (_certificationStats.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildStatCard(
                                'Total Certifications',
                                '${_certificationStats['totalCertifications']}',
                                Icons.card_membership,
                                Colors.green,
                              ),
                              const SizedBox(width: 10),
                              _buildStatCard(
                                'Active',
                                '${_certificationStats['activeCertifications']}',
                                Icons.verified,
                                Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              _buildStatCard(
                                'Organic Area',
                                '${_certificationStats['totalOrganicArea']?.toStringAsFixed(1) ?? '0'} ha',
                                Icons.map,
                                Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      // Alerts
                      if (_certificationAlerts.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Alerts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ..._certificationAlerts.map((alert) => Card(
                                  color: alert.contains('expires') 
                                      ? Colors.red[50] 
                                      : Colors.green[50],
                                  child: ListTile(
                                    leading: Icon(
                                      alert.contains('expires') 
                                          ? Icons.warning 
                                          : Icons.check_circle,
                                      color: alert.contains('expires') 
                                          ? Colors.red 
                                          : Colors.green,
                                    ),
                                    title: Text(alert),
                                  ),
                                )),
                            const SizedBox(height: 10),
                          ],
                        ),
                      if (_certifications.isEmpty)
                        const Center(
                          child: Text('No organic certifications found'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _certifications.length,
                          itemBuilder: (context, index) {
                            final cert = _certifications[index];
                            return Card(
                              child: ListTile(
                                title: Text(cert.farmName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cert.certificationBody),
                                    Text('Area: ${cert.farmAreaHectares} hectares'),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      cert.isCertified 
                                          ? Icons.verified 
                                          : Icons.warning,
                                      color: cert.isCertified 
                                          ? Colors.green 
                                          : Colors.orange,
                                    ),
                                    Text(
                                      cert.expiryDate.toString().split(' ').first,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                onTap: () => _viewCertificationDetails(cert),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Compliance Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Compliance Management',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.checklist,
                                size: 50,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Track your compliance with organic standards',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _viewComplianceChecklist,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  'View Checklist',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Recent Inspections',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_certifications.expand((cert) => cert.inspectionReports).isEmpty)
                        const Center(
                          child: Text('No inspection reports available'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _certifications
                              .expand((cert) => cert.inspectionReports)
                              .length,
                          itemBuilder: (context, index) {
                            final reports = _certifications
                                .expand((cert) => cert.inspectionReports)
                                .toList();
                            final report = reports[index];
                            
                            return Card(
                              child: ListTile(
                                title: Text(report.certificationBody),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Inspector: ${report.inspectorName}'),
                                    Text('Date: ${report.inspectionDate.toString().split(' ').first}'),
                                    Text(
                                      'Status: ${report.complianceStatus}',
                                      style: TextStyle(
                                        color: report.complianceStatus == 'Compliant' 
                                            ? Colors.green 
                                            : report.complianceStatus == 'Non-Compliant' 
                                                ? Colors.red 
                                                : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  report.nextInspectionDate.toString().split(' ').first,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Requirements Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Certification Requirements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.description,
                                size: 50,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Understand the requirements for organic certification',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // In a real app, this would open detailed requirements
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Showing detailed requirements...'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('View All Requirements'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Key Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Card(
                        child: ListTile(
                          title: Text('Soil Management'),
                          subtitle: Text('Composting, crop rotation, soil amendments'),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text('Pest Control'),
                          subtitle: Text('Biological controls, beneficial insects'),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text('Seed Sourcing'),
                          subtitle: Text('Organic seed requirements'),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text('Processing & Storage'),
                          subtitle: Text('Preventing contamination, cleaning protocols'),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text('Record Keeping'),
                          subtitle: Text('Documentation of all practices'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Analytics Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Certification Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Benefits of Organic Certification
                      const Text(
                        'Benefits of Organic Certification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const ListTile(
                                leading: Icon(Icons.trending_up, color: Colors.green),
                                title: Text('Premium Prices'),
                                subtitle: Text('Organic products command 20-30% higher prices'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.public, color: Colors.green),
                                title: Text('Market Access'),
                                subtitle: Text('Access to organic markets and retailers'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.eco, color: Colors.green),
                                title: Text('Environmental Benefits'),
                                subtitle: Text('Improved soil health and biodiversity'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.groups, color: Colors.green),
                                title: Text('Consumer Trust'),
                                subtitle: Text('Verified organic status builds customer loyalty'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Getting Started
                      const Text(
                        'Getting Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Begin your journey to organic certification',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _startCertificationProcess,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  'Start Certification Process',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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