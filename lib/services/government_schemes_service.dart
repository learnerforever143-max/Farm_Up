import 'package:farm_up/models/government_scheme.dart';
import 'package:farm_up/services/notification_manager.dart';

class GovernmentSchemesService {
  List<GovernmentScheme> _schemes = [];
  List<SchemeAlert> _schemeAlerts = [];
  final NotificationManager _notificationManager = NotificationManager();
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample government schemes
    final pmkisan = GovernmentScheme(
      id: 1,
      schemeName: 'PM-KISAN',
      description: 'Income support scheme for eligible farmer families',
      eligibilityCriteria: 'Farmer families owning cultivable land upto 2 hectares',
      benefits: '₹6,000 per year transferred directly to bank accounts in 3 equal installments',
      applicationProcess: 'Register through state nodal agencies or Common Service Centers',
      deadline: DateTime(2026, 3, 31),
      category: 'Income Support',
      isActive: true,
    );
    
    final pmmvy = GovernmentScheme(
      id: 2,
      schemeName: 'PMMVY',
      description: 'Maternity Benefit Program for pregnant and lactating women',
      eligibilityCriteria: 'Pregnant women above 19 years of age for first two live births',
      benefits: 'Cash incentive of ₹5,000 for wage earners and ₹6,000 for non-wage earners',
      applicationProcess: 'Apply through Anganwadi centers with required documents',
      deadline: DateTime(2026, 6, 30),
      category: 'Women Welfare',
      isActive: true,
    );
    
    final kcc = GovernmentScheme(
      id: 3,
      schemeName: 'KCC',
      description: 'Kisan Credit Card for farmers to meet cultivation expenses',
      eligibilityCriteria: 'All farmers including tenant farmers and sharecroppers',
      benefits: 'Credit facility up to ₹3 lakh with flexible repayment options',
      applicationProcess: 'Apply through banks with land documents and identity proof',
      deadline: DateTime(2026, 9, 30),
      category: 'Credit Facility',
      isActive: true,
    );
    
    final pmfby = GovernmentScheme(
      id: 4,
      schemeName: 'PMFBY',
      description: 'Crop insurance scheme to provide financial support in case of crop loss',
      eligibilityCriteria: 'All farmers growing notified crops in notified areas',
      benefits: 'Insurance coverage against crop failure due to natural calamities',
      applicationProcess: 'Enroll through insurance companies with crop details',
      deadline: DateTime(2026, 5, 15),
      category: 'Insurance',
      isActive: true,
    );
    
    _schemes = [pmkisan, pmmvy, kcc, pmfby];
    
    // Generate alerts for schemes
    _generateAlerts();
  }
  
  // Generate alerts for schemes with approaching deadlines
  void _generateAlerts() {
    _schemeAlerts.clear();
    
    for (final scheme in _schemes) {
      if (scheme.deadline != null && scheme.isActive) {
        final daysUntilDeadline = scheme.deadline!.difference(DateTime.now()).inDays;
        
        if (daysUntilDeadline <= 30 && daysUntilDeadline > 0) {
          _schemeAlerts.add(SchemeAlert(
            schemeId: scheme.id!,
            alertType: 'Deadline',
            message: '${scheme.schemeName} application deadline is approaching',
            alertDate: DateTime.now(),
          ));
          
          // Send notification for approaching deadline
          _notificationManager.sendSchemeDeadline(scheme);
        }
      }
    }
  }
  
  // Get all government schemes
  List<GovernmentScheme> getAllSchemes() {
    return List.from(_schemes);
  }
  
  // Get active schemes
  List<GovernmentScheme> getActiveSchemes() {
    return _schemes.where((scheme) => scheme.isActive).toList();
  }
  
  // Get schemes by category
  List<GovernmentScheme> getSchemesByCategory(String category) {
    return _schemes
        .where((scheme) => 
            scheme.category.toLowerCase() == category.toLowerCase() && scheme.isActive)
        .toList();
  }
  
  // Search schemes
  List<GovernmentScheme> searchSchemes(String query) {
    return _schemes
        .where((scheme) => 
            (scheme.schemeName.toLowerCase().contains(query.toLowerCase()) ||
             scheme.description.toLowerCase().contains(query.toLowerCase())) &&
            scheme.isActive)
        .toList();
  }
  
  // Get unique categories
  List<String> getCategories() {
    final categories = <String>{};
    for (final scheme in _schemes) {
      if (scheme.isActive) {
        categories.add(scheme.category);
      }
    }
    return categories.toList();
  }
  
  // Apply for a scheme
  void applyForScheme(int schemeId) {
    // In a real app, this would submit an application
    print('Applied for scheme ID: $schemeId');
  }
  
  // Get scheme by ID
  GovernmentScheme? getSchemeById(int id) {
    try {
      return _schemes.firstWhere((scheme) => scheme.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get all scheme alerts
  List<SchemeAlert> getAllAlerts() {
    return List.from(_schemeAlerts);
  }
  
  // Get unresolved alerts
  List<SchemeAlert> getUnresolvedAlerts() {
    return _schemeAlerts.where((alert) => !alert.isResolved).toList();
  }
  
  // Resolve an alert
  void resolveAlert(int alertId) {
    final index = _schemeAlerts.indexWhere((alert) => alert.id == alertId);
    if (index != -1) {
      _schemeAlerts[index] = SchemeAlert(
        id: _schemeAlerts[index].id,
        schemeId: _schemeAlerts[index].schemeId,
        alertType: _schemeAlerts[index].alertType,
        message: _schemeAlerts[index].message,
        alertDate: _schemeAlerts[index].alertDate,
        isResolved: true,
      );
    }
  }
  
  // Get scheme statistics
  Map<String, dynamic> getSchemeStats() {
    final stats = <String, dynamic>{};
    
    // Total schemes
    stats['totalSchemes'] = _schemes.length;
    
    // Active schemes
    stats['activeSchemes'] = _schemes.where((scheme) => scheme.isActive).length;
    
    // Schemes by category
    final categoryCount = <String, int>{};
    for (final scheme in _schemes) {
      if (scheme.isActive) {
        if (categoryCount.containsKey(scheme.category)) {
          categoryCount[scheme.category] = categoryCount[scheme.category]! + 1;
        } else {
          categoryCount[scheme.category] = 1;
        }
      }
    }
    stats['categoryDistribution'] = categoryCount;
    
    return stats;
  }
  
  // Send scheme deadline notification
  Future<void> sendSchemeDeadline(GovernmentScheme scheme) async {
    await _notificationManager.sendSchemeDeadline(scheme);
  }
}