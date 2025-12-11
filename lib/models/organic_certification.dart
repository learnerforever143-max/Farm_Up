class OrganicCertification {
  final int? id;
  final String farmerId;
  final String farmName;
  final double farmAreaHectares;
  final String certificationBody;
  final String certificationNumber;
  final DateTime certificationDate;
  final DateTime expiryDate;
  final String certificationStatus; // Pending, Certified, Expired, Revoked
  final List<OrganicPractice> organicPractices;
  final List<InspectionReport> inspectionReports;
  final String notes;

  OrganicCertification({
    this.id,
    required this.farmerId,
    required this.farmName,
    required this.farmAreaHectares,
    required this.certificationBody,
    required this.certificationNumber,
    required this.certificationDate,
    required this.expiryDate,
    required this.certificationStatus,
    List<OrganicPractice>? organicPractices,
    List<InspectionReport>? inspectionReports,
    this.notes = '',
  })  : organicPractices = organicPractices ?? [],
        inspectionReports = inspectionReports ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmName': farmName,
      'farmAreaHectares': farmAreaHectares,
      'certificationBody': certificationBody,
      'certificationNumber': certificationNumber,
      'certificationDate': certificationDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'certificationStatus': certificationStatus,
      'organicPractices': organicPractices.map((op) => op.toJson()).toList(),
      'inspectionReports': inspectionReports.map((ir) => ir.toJson()).toList(),
      'notes': notes,
    };
  }

  factory OrganicCertification.fromJson(Map<String, dynamic> json) {
    return OrganicCertification(
      id: json['id'],
      farmerId: json['farmerId'],
      farmName: json['farmName'],
      farmAreaHectares: json['farmAreaHectares'],
      certificationBody: json['certificationBody'],
      certificationNumber: json['certificationNumber'],
      certificationDate: DateTime.parse(json['certificationDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      certificationStatus: json['certificationStatus'],
      organicPractices: (json['organicPractices'] as List)
          .map((op) => OrganicPractice.fromJson(op))
          .toList(),
      inspectionReports: (json['inspectionReports'] as List)
          .map((ir) => InspectionReport.fromJson(ir))
          .toList(),
      notes: json['notes'] ?? '',
    );
  }

  bool get isCertified {
    return certificationStatus == 'Certified' && DateTime.now().isBefore(expiryDate);
  }

  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return isCertified && daysUntilExpiry <= 90 && daysUntilExpiry > 0;
  }

  int get daysUntilExpiry {
    return expiryDate.difference(DateTime.now()).inDays;
  }
}

class OrganicPractice {
  final int? id;
  final String practiceName;
  final String description;
  final DateTime implementationDate;
  final bool isCompliant;
  final String evidence;

  OrganicPractice({
    this.id,
    required this.practiceName,
    required this.description,
    required this.implementationDate,
    this.isCompliant = true,
    required this.evidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'practiceName': practiceName,
      'description': description,
      'implementationDate': implementationDate.toIso8601String(),
      'isCompliant': isCompliant,
      'evidence': evidence,
    };
  }

  factory OrganicPractice.fromJson(Map<String, dynamic> json) {
    return OrganicPractice(
      id: json['id'],
      practiceName: json['practiceName'],
      description: json['description'],
      implementationDate: DateTime.parse(json['implementationDate']),
      isCompliant: json['isCompliant'] ?? true,
      evidence: json['evidence'],
    );
  }
}

class InspectionReport {
  final int? id;
  final String inspectorName;
  final String certificationBody;
  final DateTime inspectionDate;
  final String findings;
  final String recommendations;
  final String complianceStatus; // Compliant, Non-Compliant, Conditional
  final DateTime nextInspectionDate;

  InspectionReport({
    this.id,
    required this.inspectorName,
    required this.certificationBody,
    required this.inspectionDate,
    required this.findings,
    required this.recommendations,
    required this.complianceStatus,
    required this.nextInspectionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectorName': inspectorName,
      'certificationBody': certificationBody,
      'inspectionDate': inspectionDate.toIso8601String(),
      'findings': findings,
      'recommendations': recommendations,
      'complianceStatus': complianceStatus,
      'nextInspectionDate': nextInspectionDate.toIso8601String(),
    };
  }

  factory InspectionReport.fromJson(Map<String, dynamic> json) {
    return InspectionReport(
      id: json['id'],
      inspectorName: json['inspectorName'],
      certificationBody: json['certificationBody'],
      inspectionDate: DateTime.parse(json['inspectionDate']),
      findings: json['findings'],
      recommendations: json['recommendations'],
      complianceStatus: json['complianceStatus'],
      nextInspectionDate: DateTime.parse(json['nextInspectionDate']),
    );
  }
}

class CertificationRequirement {
  final int? id;
  final String requirementName;
  final String description;
  final String category; // Soil Management, Pest Control, Seed Sourcing, etc.
  final bool isMandatory;
  final String evidenceRequired;

  CertificationRequirement({
    this.id,
    required this.requirementName,
    required this.description,
    required this.category,
    this.isMandatory = true,
    required this.evidenceRequired,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requirementName': requirementName,
      'description': description,
      'category': category,
      'isMandatory': isMandatory,
      'evidenceRequired': evidenceRequired,
    };
  }

  factory CertificationRequirement.fromJson(Map<String, dynamic> json) {
    return CertificationRequirement(
      id: json['id'],
      requirementName: json['requirementName'],
      description: json['description'],
      category: json['category'],
      isMandatory: json['isMandatory'] ?? true,
      evidenceRequired: json['evidenceRequired'],
    );
  }
}