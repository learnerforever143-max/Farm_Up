import 'package:farm_up/models/insurance_policy.dart';

class InsuranceService {
  List<InsurancePolicy> _policies = [];
  List<InsuranceClaim> _claims = [];
  List<RiskAssessment> _riskAssessments = [];
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample insurance policies
    final cropPolicy = InsurancePolicy(
      id: 1,
      policyName: 'Pradhan Mantri Fasal Bima Yojana',
      provider: 'Government of India',
      coverageType: 'Crop',
      premiumAmount: 500.0,
      currency: 'USD',
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 12, 31),
      sumInsured: 5000.0,
      policyNumber: 'PMFBY-2025-001',
      farmerId: 'FARMER001',
      status: 'Active',
      termsAndConditions: 'Coverage for crop loss due to natural calamities, pests, and diseases',
    );
    
    final livestockPolicy = InsurancePolicy(
      id: 2,
      policyName: 'Livestock Insurance Scheme',
      provider: 'National Insurance Company',
      coverageType: 'Livestock',
      premiumAmount: 300.0,
      currency: 'USD',
      startDate: DateTime(2025, 3, 1),
      endDate: DateTime(2026, 2, 28),
      sumInsured: 3000.0,
      policyNumber: 'LIS-2025-002',
      farmerId: 'FARMER001',
      status: 'Active',
      termsAndConditions: 'Coverage for death of livestock due to accident, illness, or natural causes',
    );
    
    _policies = [cropPolicy, livestockPolicy];
    
    // Sample insurance claims
    final claim1 = InsuranceClaim(
      id: 1,
      policyId: 1,
      farmerId: 'FARMER001',
      claimReason: 'Crop damage due to unseasonal rains',
      claimedAmount: 2500.0,
      approvedAmount: 2000.0,
      claimDate: DateTime(2025, 7, 15),
      status: 'Approved',
      documentation: 'Photos of damaged crops, FIR copy',
      notes: 'Claim processed within 30 days',
    );
    
    _claims = [claim1];
    
    // Sample risk assessments
    final riskFactor1 = RiskFactor(
      factorName: 'Weather Patterns',
      impactScore: 8.5,
      description: 'Unpredictable monsoon patterns affecting crop growth',
    );
    
    final riskFactor2 = RiskFactor(
      factorName: 'Pest Infestation',
      impactScore: 6.0,
      description: 'Potential threat from locusts in the region',
    );
    
    final riskAssessment = RiskAssessment(
      id: 1,
      farmerId: 'FARMER001',
      cropType: 'Wheat',
      location: 'Punjab',
      assessmentDate: DateTime(2025, 4, 1),
      riskScore: 7.2,
      riskLevel: 'High',
      riskFactors: [riskFactor1, riskFactor2],
      recommendations: 'Consider crop diversification and enhanced pest control measures',
    );
    
    _riskAssessments = [riskAssessment];
  }
  
  // Get all policies for a farmer
  List<InsurancePolicy> getPoliciesByFarmer(String farmerId) {
    return _policies
        .where((policy) => policy.farmerId == farmerId)
        .toList();
  }
  
  // Get active policies for a farmer
  List<InsurancePolicy> getActivePoliciesByFarmer(String farmerId) {
    return _policies
        .where((policy) => 
            policy.farmerId == farmerId && 
            policy.isActive)
        .toList();
  }
  
  // Get policy by ID
  InsurancePolicy? getPolicyById(int id) {
    try {
      return _policies.firstWhere((policy) => policy.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get policies by coverage type
  List<InsurancePolicy> getPoliciesByCoverageType(String coverageType) {
    return _policies
        .where((policy) => policy.coverageType.toLowerCase() == coverageType.toLowerCase())
        .toList();
  }
  
  // Add new policy
  void addPolicy(InsurancePolicy policy) {
    _policies.add(policy);
  }
  
  // Update policy
  void updatePolicy(InsurancePolicy policy) {
    final index = _policies.indexWhere((p) => p.id == policy.id);
    if (index != -1) {
      _policies[index] = policy;
    }
  }
  
  // Get claims for a farmer
  List<InsuranceClaim> getClaimsByFarmer(String farmerId) {
    return _claims
        .where((claim) => claim.farmerId == farmerId)
        .toList();
  }
  
  // Get claims by policy ID
  List<InsuranceClaim> getClaimsByPolicyId(int policyId) {
    return _claims
        .where((claim) => claim.policyId == policyId)
        .toList();
  }
  
  // Get claim by ID
  InsuranceClaim? getClaimById(int id) {
    try {
      return _claims.firstWhere((claim) => claim.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Add new claim
  void addClaim(InsuranceClaim claim) {
    _claims.add(claim);
  }
  
  // Update claim
  void updateClaim(InsuranceClaim claim) {
    final index = _claims.indexWhere((c) => c.id == claim.id);
    if (index != -1) {
      _claims[index] = claim;
    }
  }
  
  // Get risk assessments for a farmer
  List<RiskAssessment> getRiskAssessmentsByFarmer(String farmerId) {
    return _riskAssessments
        .where((assessment) => assessment.farmerId == farmerId)
        .toList();
  }
  
  // Get risk assessment by ID
  RiskAssessment? getRiskAssessmentById(int id) {
    try {
      return _riskAssessments.firstWhere((assessment) => assessment.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Add new risk assessment
  void addRiskAssessment(RiskAssessment assessment) {
    _riskAssessments.add(assessment);
  }
  
  // Calculate premium estimate
  double calculatePremiumEstimate({
    required String coverageType,
    required double sumInsured,
    required String cropType,
    required String location,
  }) {
    double baseRate = 0.0;
    
    // Base rates by coverage type
    switch (coverageType.toLowerCase()) {
      case 'crop':
        baseRate = 0.05; // 5% of sum insured
        break;
      case 'livestock':
        baseRate = 0.08; // 8% of sum insured
        break;
      case 'farm equipment':
        baseRate = 0.10; // 10% of sum insured
        break;
      default:
        baseRate = 0.05;
    }
    
    // Adjust based on crop type
    if (['rice', 'sugarcane'].contains(cropType.toLowerCase())) {
      baseRate *= 1.2; // Higher risk crops
    }
    
    // Adjust based on location risk factors
    if (['coastal', 'desert', 'hilly'].any((region) => 
        location.toLowerCase().contains(region))) {
      baseRate *= 1.15; // Higher risk locations
    }
    
    return sumInsured * baseRate;
  }
  
  // Get insurance recommendations
  List<String> getInsuranceRecommendations(String farmerId) {
    final recommendations = <String>[];
    
    final activePolicies = getActivePoliciesByFarmer(farmerId);
    final coverageTypes = activePolicies
        .map((policy) => policy.coverageType)
        .toSet();
    
    // Recommend crop insurance if not covered
    if (!coverageTypes.contains('Crop')) {
      recommendations.add('Consider crop insurance to protect against yield losses');
    }
    
    // Recommend livestock insurance if not covered
    if (!coverageTypes.contains('Livestock')) {
      recommendations.add('Livestock insurance can protect against animal deaths');
    }
    
    // Recommend equipment insurance if not covered
    if (!coverageTypes.contains('Farm Equipment')) {
      recommendations.add('Farm equipment insurance protects valuable machinery');
    }
    
    // Check for expiring policies
    final expiringPolicies = activePolicies
        .where((policy) => policy.daysRemaining < 30)
        .toList();
    
    if (expiringPolicies.isNotEmpty) {
      recommendations.add('${expiringPolicies.length} policies expiring soon. Consider renewal.');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Your insurance coverage is comprehensive');
    }
    
    return recommendations;
  }
  
  // Get insurance statistics
  Map<String, dynamic> getInsuranceStats(String farmerId) {
    final stats = <String, dynamic>{};
    
    final policies = getPoliciesByFarmer(farmerId);
    final claims = getClaimsByFarmer(farmerId);
    
    // Total policies
    stats['totalPolicies'] = policies.length;
    
    // Active policies
    stats['activePolicies'] = policies
        .where((policy) => policy.isActive)
        .length;
    
    // Total premiums paid
    double totalPremiums = 0;
    for (final policy in policies) {
      totalPremiums += policy.premiumAmount;
    }
    stats['totalPremiums'] = totalPremiums;
    
    // Total claims filed
    stats['totalClaims'] = claims.length;
    
    // Approved claims value
    double approvedClaimsValue = 0;
    for (final claim in claims) {
      approvedClaimsValue += claim.approvedAmount;
    }
    stats['approvedClaimsValue'] = approvedClaimsValue;
    
    // Claims success rate
    if (claims.isNotEmpty) {
      final approvedClaims = claims
          .where((claim) => claim.status == 'Approved')
          .length;
      stats['claimsSuccessRate'] = (approvedClaims / claims.length) * 100;
    } else {
      stats['claimsSuccessRate'] = 0.0;
    }
    
    return stats;
  }
}