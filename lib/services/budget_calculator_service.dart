import 'package:farm_up/models/budget_item.dart';
import 'package:farm_up/database/database_helper.dart';

class BudgetCalculatorService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<BudgetItem> _budgetItems = [];
  
  // Add budget item
  Future<void> addBudgetItem(BudgetItem item) async {
    _budgetItems.add(item);
    
    // Save to local database
    try {
      await _dbHelper.insertBudgetItem(item);
    } catch (e) {
      print('Error saving budget item locally: $e');
    }
  }
  
  // Remove budget item
  void removeBudgetItem(BudgetItem item) {
    _budgetItems.remove(item);
  }
  
  // Get budget items
  List<BudgetItem> getBudgetItems() {
    return List.from(_budgetItems);
  }
  
  // Get budget items by user ID (with offline support)
  Future<List<BudgetItem>> getBudgetItemsByUserId(int userId) async {
    try {
      // Try to get from local database first
      final localItems = await _dbHelper.getBudgetItemsByUserId(userId);
      
      // If we have local items, use them
      if (localItems.isNotEmpty) {
        _budgetItems = localItems;
        return localItems;
      }
      
      // Otherwise return in-memory items
      return List.from(_budgetItems);
    } catch (e) {
      print('Error retrieving budget items: $e');
      // Fallback to in-memory items
      return List.from(_budgetItems);
    }
  }
  
  // Get total cost
  double getTotalCost() {
    return _budgetItems.fold(0.0, (sum, item) => sum + item.cost);
  }
  
  // Get cost by category
  Map<String, double> getCostByCategory() {
    Map<String, double> categoryCosts = {};
    
    for (var item in _budgetItems) {
      if (categoryCosts.containsKey(item.category)) {
        categoryCosts[item.category] = categoryCosts[item.category]! + item.cost;
      } else {
        categoryCosts[item.category] = item.cost;
      }
    }
    
    return categoryCosts;
  }
  
  // Get expected revenue
  double getExpectedRevenue(double yieldPerHectare, double pricePerUnit) {
    // This is a simplified calculation
    // In a real app, this would be more complex
    return yieldPerHectare * pricePerUnit;
  }
  
  // Get profit margin
  double getProfitMargin(double yieldPerHectare, double pricePerUnit) {
    double revenue = getExpectedRevenue(yieldPerHectare, pricePerUnit);
    double costs = getTotalCost();
    return revenue - costs;
  }
  
  // Get ROI
  double getROI(double yieldPerHectare, double pricePerUnit) {
    double profit = getProfitMargin(yieldPerHectare, pricePerUnit);
    double investment = getTotalCost();
    
    if (investment == 0) return 0;
    
    return (profit / investment) * 100;
  }
  
  // Save budget items locally
  Future<void> saveBudgetItemsLocally(List<BudgetItem> items) async {
    for (var item in items) {
      try {
        await _dbHelper.insertBudgetItem(item);
      } catch (e) {
        print('Error saving budget item locally: $e');
      }
    }
  }
}