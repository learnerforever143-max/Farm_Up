import 'package:farm_up/models/livestock.dart';

class LivestockService {
  List<Livestock> _livestockList = [];
  
  // Add a new livestock animal
  void addLivestock(Livestock livestock) {
    _livestockList.add(livestock);
  }
  
  // Update an existing livestock animal
  void updateLivestock(Livestock livestock) {
    final index = _livestockList.indexWhere((l) => l.id == livestock.id);
    if (index != -1) {
      _livestockList[index] = livestock;
    }
  }
  
  // Remove a livestock animal
  void removeLivestock(int livestockId) {
    _livestockList.removeWhere((l) => l.id == livestockId);
  }
  
  // Get all livestock animals
  List<Livestock> getAllLivestock() {
    return List.from(_livestockList);
  }
  
  // Get livestock by ID
  Livestock? getLivestockById(int id) {
    try {
      return _livestockList.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get livestock by type
  List<Livestock> getLivestockByType(String type) {
    return _livestockList.where((l) => l.type.toLowerCase() == type.toLowerCase()).toList();
  }
  
  // Get upcoming vaccinations
  List<VaccinationRecord> getUpcomingVaccinations() {
    final upcoming = <VaccinationRecord>[];
    final today = DateTime.now();
    final next30Days = today.add(const Duration(days: 30));
    
    for (var livestock in _livestockList) {
      for (var vaccination in livestock.vaccinationRecords) {
        if (vaccination.nextDueDate.isAfter(today) && 
            vaccination.nextDueDate.isBefore(next30Days)) {
          upcoming.add(vaccination);
        }
      }
    }
    
    return upcoming;
  }
  
  // Get animals needing health checkups
  List<HealthCheckup> getPendingHealthCheckups() {
    final pending = <HealthCheckup>[];
    final today = DateTime.now();
    
    for (var livestock in _livestockList) {
      for (var checkup in livestock.healthCheckups) {
        if (checkup.followUpDate.isBefore(today)) {
          pending.add(checkup);
        }
      }
    }
    
    return pending;
  }
  
  // Calculate total feed cost for a period
  double calculateFeedCost(DateTime startDate, DateTime endDate) {
    double totalCost = 0.0;
    
    for (var livestock in _livestockList) {
      for (var feeding in livestock.feedingRecords) {
        if (feeding.feedDate.isAfter(startDate) && 
            feeding.feedDate.isBefore(endDate)) {
          // In a real app, this would use actual feed prices
          // For now, we'll use a placeholder cost calculation
          totalCost += feeding.quantity * 2.5; // $2.50 per kg
        }
      }
    }
    
    return totalCost;
  }
  
  // Get livestock statistics
  Map<String, dynamic> getLivestockStatistics() {
    final stats = <String, dynamic>{};
    
    // Count by type
    final typeCounts = <String, int>{};
    for (var livestock in _livestockList) {
      if (typeCounts.containsKey(livestock.type)) {
        typeCounts[livestock.type] = typeCounts[livestock.type]! + 1;
      } else {
        typeCounts[livestock.type] = 1;
      }
    }
    
    stats['totalAnimals'] = _livestockList.length;
    stats['typeCounts'] = typeCounts;
    stats['totalValue'] = _livestockList.fold(
      0.0, 
      (sum, livestock) => sum + livestock.purchasePrice
    );
    
    return stats;
  }
  
  // Generate breeding recommendations
  List<String> getBreedingRecommendations() {
    final recommendations = <String>[];
    
    // Group animals by type and gender
    final maleAnimals = <String, List<Livestock>>{};
    final femaleAnimals = <String, List<Livestock>>{};
    
    for (var livestock in _livestockList) {
      if (livestock.gender.toLowerCase() == 'male') {
        if (maleAnimals.containsKey(livestock.type)) {
          maleAnimals[livestock.type]!.add(livestock);
        } else {
          maleAnimals[livestock.type] = [livestock];
        }
      } else if (livestock.gender.toLowerCase() == 'female') {
        if (femaleAnimals.containsKey(livestock.type)) {
          femaleAnimals[livestock.type]!.add(livestock);
        } else {
          femaleAnimals[livestock.type] = [livestock];
        }
      }
    }
    
    // Generate recommendations
    for (var type in maleAnimals.keys) {
      if (femaleAnimals.containsKey(type)) {
        final maleCount = maleAnimals[type]!.length;
        final femaleCount = femaleAnimals[type]!.length;
        
        if (maleCount > 0 && femaleCount > 0) {
          recommendations.add(
            'Consider breeding: $maleCount male and $femaleCount female ${type.toLowerCase()}s'
          );
        }
      } else {
        recommendations.add(
          'Add female ${type.toLowerCase()}s for breeding program'
        );
      }
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('No breeding recommendations at this time');
    }
    
    return recommendations;
  }
  
  // Get health alerts
  List<String> getHealthAlerts() {
    final alerts = <String>[];
    
    for (var livestock in _livestockList) {
      if (livestock.healthStatus.toLowerCase() != 'healthy') {
        alerts.add(
          '${livestock.name} (${livestock.type}) requires attention - Status: ${livestock.healthStatus}'
        );
      }
    }
    
    // Check for overdue vaccinations
    final overdueVaccinations = getUpcomingVaccinations();
    if (overdueVaccinations.isNotEmpty) {
      alerts.add('Vaccinations due for ${overdueVaccinations.length} animals');
    }
    
    // Check for pending health checkups
    final pendingCheckups = getPendingHealthCheckups();
    if (pendingCheckups.isNotEmpty) {
      alerts.add('${pendingCheckups.length} health checkups overdue');
    }
    
    if (alerts.isEmpty) {
      alerts.add('All livestock are healthy and up to date with vaccinations');
    }
    
    return alerts;
  }
}