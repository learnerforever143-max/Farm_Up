class InsurancePolicy {
  final int? id;
  final String policyName;
  final String provider;
  final String coverageType; // Crop, Livestock, Farm Equipment, etc.
  final double premiumAmount;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final double sumInsured;
  final String policyNumber;
  final String farmerId;
  final String status; // Active, Expired, Claimed
  final String termsAndConditions;

  InsurancePolicy({
    this.id,
    required this.policyName,
    required this.provider,
    required this.coverageType,
    required this.premiumAmount,
    this.currency = 'USD',
    required this.startDate,
    required this.endDate,
    required this.sumInsured,
    required this.policyNumber,
    required this.farmerId,
    required this.status,
    required this.termsAndConditions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policyName': policyName,
      'provider': provider,
      'coverageType': coverageType,
      'premiumAmount': premiumAmount,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'sumInsured': sumInsured,
      'policyNumber': policyNumber,
      'farmerId': farmerId,
      'status': status,
      'termsAndConditions': termsAndConditions,
    };
  }

  factory InsurancePolicy.fromJson(Map<String, dynamic> json) {
    return InsurancePolicy(
      id: json['id'],
      policyName: json['policyName'],
      provider: json['provider'],
      coverageType: json['coverageType'],
      premiumAmount: json['premiumAmount'],
      currency: json['currency'] ?? 'USD',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      sumInsured: json['sumInsured'],
      policyNumber: json['policyNumber'],
      farmerId: json['farmerId'],
      status: json['status'],
      termsAndConditions: json['termsAndConditions'],
    );
  }

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && status == 'Active';
  }

  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }

  int get daysRemaining {
    return endDate.difference(DateTime.now()).inDays;
  }
}

class InsuranceClaim {
  final int? id;
  final int policyId;
  final String farmerId;
  final String claimReason;
  final double claimedAmount;
  final double approvedAmount;
  final DateTime claimDate;
  final String status; // Filed, Under Review, Approved, Rejected
  final String documentation;
  final String notes;

  InsuranceClaim({
    this.id,
    required this.policyId,
    required this.farmerId,
    required this.claimReason,
    required this.claimedAmount,
    required this.approvedAmount,
    required this.claimDate,
    required this.status,
    required this.documentation,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policyId': policyId,
      'farmerId': farmerId,
      'claimReason': claimReason,
      'claimedAmount': claimedAmount,
      'approvedAmount': approvedAmount,
      'claimDate': claimDate.toIso8601String(),
      'status': status,
      'documentation': documentation,
      'notes': notes,
    };
  }

  factory InsuranceClaim.fromJson(Map<String, dynamic> json) {
    return InsuranceClaim(
      id: json['id'],
      policyId: json['policyId'],
      farmerId: json['farmerId'],
      claimReason: json['claimReason'],
      claimedAmount: json['claimedAmount'],
      approvedAmount: json['approvedAmount'],
      claimDate: DateTime.parse(json['claimDate']),
      status: json['status'],
      documentation: json['documentation'],
      notes: json['notes'] ?? '',
    );
  }
}

class RiskAssessment {
  final int? id;
  final String farmerId;
  final String cropType;
  final String location;
  final DateTime assessmentDate;
  final double riskScore; // 0.0 to 10.0
  final String riskLevel; // Low, Medium, High, Critical
  final List<RiskFactor> riskFactors;
  final String recommendations;

  RiskAssessment({
    this.id,
    required this.farmerId,
    required this.cropType,
    required this.location,
    required this.assessmentDate,
    required this.riskScore,
    required this.riskLevel,
    List<RiskFactor>? riskFactors,
    required this.recommendations,
  }) : riskFactors = riskFactors ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'cropType': cropType,
      'location': location,
      'assessmentDate': assessmentDate.toIso8601String(),
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'riskFactors': riskFactors.map((rf) => rf.toJson()).toList(),
      'recommendations': recommendations,
    };
  }

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      id: json['id'],
      farmerId: json['farmerId'],
      cropType: json['cropType'],
      location: json['location'],
      assessmentDate: DateTime.parse(json['assessmentDate']),
      riskScore: json['riskScore'],
      riskLevel: json['riskLevel'],
      riskFactors: (json['riskFactors'] as List)
          .map((rf) => RiskFactor.fromJson(rf))
          .toList(),
      recommendations: json['recommendations'],
    );
  }
}

class RiskFactor {
  final int? id;
  final String factorName;
  final double impactScore; // 0.0 to 10.0
  final String description;

  RiskFactor({
    this.id,
    required this.factorName,
    required this.impactScore,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'factorName': factorName,
      'impactScore': impactScore,
      'description': description,
    };
  }

  factory RiskFactor.fromJson(Map<String, dynamic> json) {
    return RiskFactor(
      id: json['id'],
      factorName: json['factorName'],
      impactScore: json['impactScore'],
      description: json['description'],
    );
  }
}