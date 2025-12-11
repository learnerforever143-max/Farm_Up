import 'package:farm_up/models/organic_certification.dart';

class OrganicCertificationService {
  List<OrganicCertification> _certifications = [];
  List<CertificationRequirement> _requirements = [];
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample certification requirements
    final soilRequirement = CertificationRequirement(
      id: 1,
      requirementName: 'Soil Management',
      description: 'Implementation of organic soil management practices',
      category: 'Soil Management',
      isMandatory: true,
      evidenceRequired: 'Soil test reports, composting records',
    );
    
    final pestRequirement = CertificationRequirement(
      id: 2,
      requirementName: 'Pest Control',
      description: 'Use of organic pest control methods',
      category: 'Pest Management',
      isMandatory: true,
      evidenceRequired: 'Pest control logs, biological control records',
    );
    
    final seedRequirement = CertificationRequirement(
      id: 3,
      requirementName: 'Seed Sourcing',
      description: 'Use of certified organic seeds',
      category: 'Seed Management',
      isMandatory: true,
      evidenceRequired: 'Seed supplier certificates, purchase receipts',
    );
    
    _requirements = [soilRequirement, pestRequirement, seedRequirement];
    
    // Sample organic practices
    final compostingPractice = OrganicPractice(
      id: 1,
      practiceName: 'Composting',
      description: 'On-farm composting of organic waste',
      implementationDate: DateTime(2024, 1, 15),
      isCompliant: true,
      evidence: 'Compost production logs',
    );
    
    final cropRotationPractice = OrganicPractice(
      id: 2,
      practiceName: 'Crop Rotation',
      description: 'Three-year crop rotation plan',
      implementationDate: DateTime(2024, 3, 10),
      isCompliant: true,
      evidence: 'Crop rotation plan document',
    );
    
    // Sample inspection report
    final inspectionReport = InspectionReport(
      id: 1,
      inspectorName: 'Dr. Sarah Johnson',
      certificationBody: 'Organic Farmers Association',
      inspectionDate: DateTime(2025, 3, 15),
      findings: 'All practices compliant with organic standards',
      recommendations: 'Continue current practices, improve record keeping',
      complianceStatus: 'Compliant',
      nextInspectionDate: DateTime(2026, 3, 15),
    );
    
    // Sample organic certification
    final certification = OrganicCertification(
      id: 1,
      farmerId: 'FARMER001',
      farmName: 'Green Acres Farm',
      farmAreaHectares: 10.5,
      certificationBody: 'Organic Farmers Association',
      certificationNumber: 'OFA-2025-001',
      certificationDate: DateTime(2025, 3, 20),
      expiryDate: DateTime(2028, 3, 19),
      certificationStatus: 'Certified',
      organicPractices: [compostingPractice, cropRotationPractice],
      inspectionReports: [inspectionReport],
      notes: 'Initial certification granted after successful inspection',
    );
    
    _certifications = [certification];
  }
  
  // Get certifications for a farmer
  List<OrganicCertification> getCertificationsByFarmer(String farmerId) {
    return _certifications
        .where((cert) => cert.farmerId == farmerId)
        .toList();
  }
  
  // Get certification by ID
  OrganicCertification? getCertificationById(int id) {
    try {
      return _certifications.firstWhere((cert) => cert.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get active certifications for a farmer
  List<OrganicCertification> getActiveCertificationsByFarmer(String farmerId) {
    return _certifications
        .where((cert) => 
            cert.farmerId == farmerId && 
            cert.isCertified)
        .toList();
  }
  
  // Add new certification
  void addCertification(OrganicCertification certification) {
    _certifications.add(certification);
  }
  
  // Update certification
  void updateCertification(OrganicCertification certification) {
    final index = _certifications.indexWhere((c) => c.id == certification.id);
    if (index != -1) {
      _certifications[index] = certification;
    }
  }
  
  // Get all certification requirements
  List<CertificationRequirement> getAllRequirements() {
    return List.from(_requirements);
  }
  
  // Get requirements by category
  List<CertificationRequirement> getRequirementsByCategory(String category) {
    return _requirements
        .where((req) => req.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  // Get mandatory requirements
  List<CertificationRequirement> getMandatoryRequirements() {
    return _requirements
        .where((req) => req.isMandatory)
        .toList();
  }
  
  // Get certification alerts
  List<String> getCertificationAlerts(String farmerId) {
    final alerts = <String>[];
    
    final activeCertifications = getActiveCertificationsByFarmer(farmerId);
    
    for (final cert in activeCertifications) {
      if (cert.isExpiringSoon) {
        alerts.add(
          '${cert.farmName} certification expires in ${cert.daysUntilExpiry} days'
        );
      }
    }
    
    if (alerts.isEmpty) {
      alerts.add('All certifications are up to date');
    }
    
    return alerts;
  }
  
  // Get certification statistics
  Map<String, dynamic> getCertificationStats(String farmerId) {
    final stats = <String, dynamic>{};
    
    final certifications = getCertificationsByFarmer(farmerId);
    
    // Total certifications
    stats['totalCertifications'] = certifications.length;
    
    // Active certifications
    stats['activeCertifications'] = certifications
        .where((cert) => cert.isCertified)
        .length;
    
    // Expiring soon certifications
    stats['expiringSoon'] = certifications
        .where((cert) => cert.isExpiringSoon)
        .length;
    
    // Total farm area under organic certification
    double totalArea = 0;
    for (final cert in certifications) {
      if (cert.isCertified) {
        totalArea += cert.farmAreaHectares;
      }
    }
    stats['totalOrganicArea'] = totalArea;
    
    return stats;
  }
  
  // Generate compliance checklist
  List<Map<String, dynamic>> generateComplianceChecklist(String farmerId) {
    final checklist = <Map<String, dynamic>>[];
    
    // Add all requirements to the checklist
    for (final requirement in _requirements) {
      checklist.add({
        'requirement': requirement,
        'completed': false,
        'evidenceProvided': false,
        'notes': '',
      });
    }
    
    // Mark completed requirements based on existing practices
    final certifications = getCertificationsByFarmer(farmerId);
    for (final cert in certifications) {
      for (final practice in cert.organicPractices) {
        // Match practices to requirements (simplified matching)
        for (int i = 0; i < checklist.length; i++) {
          final req = checklist[i]['requirement'] as CertificationRequirement;
          if (practice.practiceName.toLowerCase().contains(req.category.toLowerCase())) {
            checklist[i]['completed'] = true;
            checklist[i]['evidenceProvided'] = practice.evidence.isNotEmpty;
            checklist[i]['notes'] = practice.description;
          }
        }
      }
    }
    
    return checklist;
  }
  
  // Get certification bodies
  List<String> getCertificationBodies() {
    final bodies = <String>{};
    for (final cert in _certifications) {
      bodies.add(cert.certificationBody);
    }
    for (final report in _certifications.expand((cert) => cert.inspectionReports)) {
      bodies.add(report.certificationBody);
    }
    return bodies.toList();
  }
}