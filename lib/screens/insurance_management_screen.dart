import 'package:flutter/material.dart';
import 'package:farm_up/services/insurance_service.dart';
import 'package:farm_up/models/insurance_policy.dart';

class InsuranceManagementScreen extends StatefulWidget {
  const InsuranceManagementScreen({super.key});

  @override
  State<InsuranceManagementScreen> createState() => _InsuranceManagementScreenState();
}

class _InsuranceManagementScreenState extends State<InsuranceManagementScreen> {
  final InsuranceService _insuranceService = InsuranceService();
  List<InsurancePolicy> _policies = [];
  List<InsuranceClaim> _claims = [];
  List<RiskAssessment> _riskAssessments = [];
  List<String> _insuranceRecommendations = [];
  Map<String, dynamic> _insuranceStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _insuranceService.initializeSampleData();
    _loadInsuranceData();
  }

  void _loadInsuranceData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final policies = _insuranceService.getPoliciesByFarmer('FARMER001');
      final claims = _insuranceService.getClaimsByFarmer('FARMER001');
      final assessments = _insuranceService.getRiskAssessmentsByFarmer('FARMER001');
      final recommendations = _insuranceService.getInsuranceRecommendations('FARMER001');
      final stats = _insuranceService.getInsuranceStats('FARMER001');
      
      setState(() {
        _policies = policies;
        _claims = claims;
        _riskAssessments = assessments;
        _insuranceRecommendations = recommendations;
        _insuranceStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load insurance data: $e')),
        );
      }
    }
  }

  void _viewPolicyDetails(InsurancePolicy policy) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(policy.policyName),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    policy.provider,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Coverage Type: ${policy.coverageType}'),
                  Text('Policy Number: ${policy.policyNumber}'),
                  Text('Sum Insured: \$${policy.sumInsured.toStringAsFixed(0)}'),
                  Text('Premium: \$${policy.premiumAmount.toStringAsFixed(0)}'),
                  Text('Start Date: ${policy.startDate.toString().split(' ').first}'),
                  Text('End Date: ${policy.endDate.toString().split(' ').first}'),
                  const SizedBox(height: 10),
                  const Text(
                    'Terms & Conditions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(policy.termsAndConditions),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        policy.isActive 
                            ? Icons.check_circle 
                            : policy.isExpired 
                                ? Icons.cancel 
                                : Icons.schedule,
                        color: policy.isActive 
                            ? Colors.green 
                            : policy.isExpired 
                                ? Colors.red 
                                : Colors.orange,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        policy.isActive 
                            ? 'Active' 
                            : policy.isExpired 
                                ? 'Expired' 
                                : 'Inactive',
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
                  _renewPolicy(policy);
                },
                child: const Text('Renew'),
              ),
            ],
          );
        },
      );
    }
  }

  void _viewClaimDetails(InsuranceClaim claim) {
    // Get policy details for this claim
    final policy = _insuranceService.getPolicyById(claim.policyId);
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(policy?.policyName ?? 'Insurance Claim'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Claim Reason: ${claim.claimReason}'),
                  Text('Claimed Amount: \$${claim.claimedAmount.toStringAsFixed(0)}'),
                  Text('Approved Amount: \$${claim.approvedAmount.toStringAsFixed(0)}'),
                  Text('Status: ${claim.status}'),
                  Text('Date: ${claim.claimDate.toString().split(' ').first}'),
                  if (claim.documentation.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Documentation:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(claim.documentation),
                  ],
                  if (claim.notes.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Notes:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(claim.notes),
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
    }
  }

  void _viewRiskAssessment(RiskAssessment assessment) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${assessment.cropType} Risk Assessment'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${assessment.location}'),
                  Text('Date: ${assessment.assessmentDate.toString().split(' ').first}'),
                  Text(
                    'Risk Score: ${assessment.riskScore.toStringAsFixed(1)}/10.0',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Risk Level: ${assessment.riskLevel}'),
                  const SizedBox(height: 10),
                  const Text(
                    'Risk Factors:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...assessment.riskFactors.map((factor) => Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Text('${factor.factorName}: '),
                            Text(
                              '${factor.impactScore.toStringAsFixed(1)}/10.0',
                              style: TextStyle(
                                color: factor.impactScore > 7.0 
                                    ? Colors.red 
                                    : factor.impactScore > 5.0 
                                        ? Colors.orange 
                                        : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  const Text(
                    'Recommendations:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(assessment.recommendations),
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
    }
  }

  void _renewPolicy(InsurancePolicy policy) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Renewing ${policy.policyName}...')),
      );
    }
  }

  void _fileClaim() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening claim filing form...')),
      );
    }
  }

  void _requestRiskAssessment() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Requesting new risk assessment...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insurance & Risk Management'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Policies'),
              Tab(text: 'Claims'),
              Tab(text: 'Risk Assessment'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Policies Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Insurance Policies',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Insurance Stats
                      if (_insuranceStats.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildStatCard(
                                'Total Policies',
                                '${_insuranceStats['totalPolicies']}',
                                Icons.policy,
                                Colors.green,
                              ),
                              const SizedBox(width: 10),
                              _buildStatCard(
                                'Active Policies',
                                '${_insuranceStats['activePolicies']}',
                                Icons.verified,
                                Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              _buildStatCard(
                                'Total Premiums',
                                '\$${_insuranceStats['totalPremiums']?.toStringAsFixed(0) ?? '0'}',
                                Icons.attach_money,
                                Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      // Recommendations
                      if (_insuranceRecommendations.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recommendations',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ..._insuranceRecommendations.map((recommendation) => Card(
                                  color: Colors.blue[50],
                                  child: ListTile(
                                    leading: const Icon(Icons.lightbulb, color: Colors.blue),
                                    title: Text(recommendation),
                                  ),
                                )),
                            const SizedBox(height: 10),
                          ],
                        ),
                      if (_policies.isEmpty)
                        const Center(
                          child: Text('No insurance policies found'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _policies.length,
                          itemBuilder: (context, index) {
                            final policy = _policies[index];
                            return Card(
                              child: ListTile(
                                title: Text(policy.policyName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(policy.provider),
                                    Text('${policy.coverageType} Insurance'),
                                    Text(
                                      'Sum Insured: \$${policy.sumInsured.toStringAsFixed(0)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '\$${policy.premiumAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Icon(
                                      policy.isActive 
                                          ? Icons.check_circle 
                                          : policy.isExpired 
                                              ? Icons.cancel 
                                              : Icons.schedule,
                                      color: policy.isActive 
                                          ? Colors.green 
                                          : policy.isExpired 
                                              ? Colors.red 
                                              : Colors.orange,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                onTap: () => _viewPolicyDetails(policy),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Claims Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Insurance Claims',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Claims Stats
                      if (_insuranceStats.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildStatCard(
                                'Total Claims',
                                '${_insuranceStats['totalClaims']}',
                                Icons.description,
                                Colors.green,
                              ),
                              const SizedBox(width: 10),
                              _buildStatCard(
                                'Approved Value',
                                '\$${_insuranceStats['approvedClaimsValue']?.toStringAsFixed(0) ?? '0'}',
                                Icons.check_circle,
                                Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              _buildStatCard(
                                'Success Rate',
                                '${_insuranceStats['claimsSuccessRate']?.toStringAsFixed(1) ?? '0'}%',
                                Icons.trending_up,
                                Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (_claims.isEmpty)
                        const Center(
                          child: Text('No insurance claims filed'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _claims.length,
                          itemBuilder: (context, index) {
                            final claim = _claims[index];
                            // Get policy details for this claim
                            final policy = _insuranceService.getPolicyById(claim.policyId);
                            
                            return Card(
                              child: ListTile(
                                title: Text(policy?.policyName ?? 'Unknown Policy'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(claim.claimReason),
                                    Text(
                                      'Claimed: \$${claim.claimedAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      'Approved: \$${claim.approvedAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      claim.claimDate.toString().split(' ').first,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Icon(
                                      claim.status == 'Approved' 
                                          ? Icons.check_circle 
                                          : claim.status == 'Rejected' 
                                              ? Icons.cancel 
                                              : Icons.schedule,
                                      color: claim.status == 'Approved' 
                                          ? Colors.green 
                                          : claim.status == 'Rejected' 
                                              ? Colors.red 
                                              : Colors.orange,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                onTap: () => _viewClaimDetails(claim),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Risk Assessment Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Risk Assessment',
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
                                Icons.assessment,
                                size: 50,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Request a comprehensive risk assessment for your farm',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _requestRiskAssessment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  'Request Assessment',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_riskAssessments.isEmpty)
                        const Center(
                          child: Text('No risk assessments available'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _riskAssessments.length,
                          itemBuilder: (context, index) {
                            final assessment = _riskAssessments[index];
                            return Card(
                              child: ListTile(
                                title: Text('${assessment.cropType} Risk Assessment'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(assessment.location),
                                    Text('Risk Level: ${assessment.riskLevel}'),
                                    Text(
                                      'Score: ${assessment.riskScore.toStringAsFixed(1)}/10.0',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  assessment.assessmentDate.toString().split(' ').first,
                                ),
                                onTap: () => _viewRiskAssessment(assessment),
                              ),
                            );
                          },
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
                      'Insurance Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Premium Calculator
                      const Text(
                        'Premium Calculator',
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
                                'Estimate insurance premiums for your farm',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // In a real app, this would open a premium calculator form
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Opening premium calculator...'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Calculate Premium'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Coverage Insights
                      const Text(
                        'Coverage Insights',
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
                                'Your farm is protected against key risks',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              const ListTile(
                                leading: Icon(Icons.check_circle, color: Colors.green),
                                title: Text('Natural Calamities'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.check_circle, color: Colors.green),
                                title: Text('Pest and Disease Damage'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.check_circle, color: Colors.green),
                                title: Text('Livestock Mortality'),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Consider additional coverage for:',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              const ListTile(
                                leading: Icon(Icons.info, color: Colors.orange),
                                title: Text('Farm Equipment'),
                              ),
                              const ListTile(
                                leading: Icon(Icons.info, color: Colors.orange),
                                title: Text('Post-Harvest Losses'),
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
        floatingActionButton: FloatingActionButton(
          onPressed: _fileClaim,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add_comment),
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