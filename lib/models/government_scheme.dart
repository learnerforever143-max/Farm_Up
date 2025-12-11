class GovernmentScheme {
  final int? id;
  final String name;
  final String description;
  final String category; // Subsidy, Loan, Grant, Insurance, etc.
  final double maxValue;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final String eligibilityCriteria;
  final String applicationProcess;
  final String contactInfo;
  final String website;
  final bool isActive;
  final String region; // National, State, District, etc.

  GovernmentScheme({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.maxValue,
    this.currency = 'USD',
    required this.startDate,
    required this.endDate,
    required this.eligibilityCriteria,
    required this.applicationProcess,
    required this.contactInfo,
    required this.website,
    this.isActive = true,
    required this.region,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'maxValue': maxValue,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'eligibilityCriteria': eligibilityCriteria,
      'applicationProcess': applicationProcess,
      'contactInfo': contactInfo,
      'website': website,
      'isActive': isActive,
      'region': region,
    };
  }

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      maxValue: json['maxValue'],
      currency: json['currency'] ?? 'USD',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      eligibilityCriteria: json['eligibilityCriteria'],
      applicationProcess: json['applicationProcess'],
      contactInfo: json['contactInfo'],
      website: json['website'],
      isActive: json['isActive'] ?? true,
      region: json['region'],
    );
  }

  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }

  bool get isUpcoming {
    return DateTime.now().isBefore(startDate);
  }

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && isActive;
  }
}

class SubsidyTracker {
  final int? id;
  final int schemeId;
  final String farmerId;
  final double appliedAmount;
  final double approvedAmount;
  final DateTime applicationDate;
  final String status; // Applied, Approved, Rejected, Disbursed
  final String notes;

  SubsidyTracker({
    this.id,
    required this.schemeId,
    required this.farmerId,
    required this.appliedAmount,
    required this.approvedAmount,
    required this.applicationDate,
    required this.status,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schemeId': schemeId,
      'farmerId': farmerId,
      'appliedAmount': appliedAmount,
      'approvedAmount': approvedAmount,
      'applicationDate': applicationDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  factory SubsidyTracker.fromJson(Map<String, dynamic> json) {
    return SubsidyTracker(
      id: json['id'],
      schemeId: json['schemeId'],
      farmerId: json['farmerId'],
      appliedAmount: json['appliedAmount'],
      approvedAmount: json['approvedAmount'],
      applicationDate: DateTime.parse(json['applicationDate']),
      status: json['status'],
      notes: json['notes'] ?? '',
    );
  }
}

class LoanEligibility {
  final int? id;
  final String farmerId;
  final double landSizeHectares;
  final double annualIncome;
  final String cropType;
  final double requestedLoanAmount;
  final String loanPurpose;
  final double estimatedEligibility;
  final List<String> recommendations;

  LoanEligibility({
    this.id,
    required this.farmerId,
    required this.landSizeHectares,
    required this.annualIncome,
    required this.cropType,
    required this.requestedLoanAmount,
    required this.loanPurpose,
    required this.estimatedEligibility,
    List<String>? recommendations,
  }) : recommendations = recommendations ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'landSizeHectares': landSizeHectares,
      'annualIncome': annualIncome,
      'cropType': cropType,
      'requestedLoanAmount': requestedLoanAmount,
      'loanPurpose': loanPurpose,
      'estimatedEligibility': estimatedEligibility,
      'recommendations': recommendations,
    };
  }

  factory LoanEligibility.fromJson(Map<String, dynamic> json) {
    return LoanEligibility(
      id: json['id'],
      farmerId: json['farmerId'],
      landSizeHectares: json['landSizeHectares'],
      annualIncome: json['annualIncome'],
      cropType: json['cropType'],
      requestedLoanAmount: json['requestedLoanAmount'],
      loanPurpose: json['loanPurpose'],
      estimatedEligibility: json['estimatedEligibility'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }
}