import 'package:farm_up/models/inventory_item.dart';
import 'package:farm_up/services/notification_manager.dart';

class InventoryService {
  List<InventoryItem> _inventoryItems = [];
  List<InventoryAlert> _inventoryAlerts = [];
  List<InventoryUsage> _inventoryUsage = [];
  final NotificationManager _notificationManager = NotificationManager();
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample inventory items
    final seeds = InventoryItem(
      id: 1,
      name: 'Hybrid Wheat Seeds',
      category: 'Seeds',
      description: 'High-yield hybrid wheat variety',
      quantity: 50.0,
      unit: 'kg',
      purchaseDate: DateTime(2025, 3, 1),
      expiryDate: DateTime(2026, 3, 1),
      purchasePrice: 8.50,
      currency: 'USD',
      supplier: 'AgriSeeds Ltd.',
      storageLocation: 'Seed Store Room A',
      batchNumber: 'WS2025-001',
      isCritical: true,
    );
    
    final fertilizer = InventoryItem(
      id: 2,
      name: 'NPK Fertilizer 20-20-20',
      category: 'Fertilizers',
      description: 'Balanced NPK fertilizer for all crops',
      quantity: 100.0,
      unit: 'kg',
      purchaseDate: DateTime(2025, 2, 15),
      expiryDate: DateTime(2026, 2, 15),
      purchasePrice: 12.00,
      currency: 'USD',
      supplier: 'NutriFarm Supplies',
      storageLocation: 'Fertilizer Shed',
      batchNumber: 'NPK2025-002',
      isCritical: true,
    );
    
    final pesticide = InventoryItem(
      id: 3,
      name: 'Glyphosate Herbicide',
      category: 'Pesticides',
      description: 'Broad-spectrum herbicide for weed control',
      quantity: 25.0,
      unit: 'liters',
      purchaseDate: DateTime(2025, 1, 10),
      expiryDate: DateTime(2025, 12, 10),
      purchasePrice: 25.00,
      currency: 'USD',
      supplier: 'CropGuard Chemicals',
      storageLocation: 'Chemical Store Room',
      batchNumber: 'GLY2025-003',
      isCritical: false,
    );
    
    final tool = InventoryItem(
      id: 4,
      name: 'Hand Sprayer',
      category: 'Tools',
      description: '16-liter capacity hand sprayer',
      quantity: 5.0,
      unit: 'pieces',
      purchaseDate: DateTime(2024, 11, 5),
      expiryDate: DateTime(2030, 11, 5),
      purchasePrice: 45.00,
      currency: 'USD',
      supplier: 'FarmTools Inc.',
      storageLocation: 'Tool Shed',
      batchNumber: 'HS2024-004',
      isCritical: false,
    );
    
    _inventoryItems = [seeds, fertilizer, pesticide, tool];
    
    // Generate alerts based on inventory items
    _generateAlerts();
  }
  
  // Generate alerts for inventory items
  void _generateAlerts() {
    _inventoryAlerts.clear();
    
    for (final item in _inventoryItems) {
      if (item.isExpired) {
        _inventoryAlerts.add(InventoryAlert(
          itemId: item.id!,
          alertType: 'Expiry',
          message: '${item.name} has expired',
          alertDate: DateTime.now(),
        ));
        
        // Send notification for expired item
        _notificationManager.sendInventoryAlert(item, 'Expiry');
      } else if (item.isExpiringSoon) {
        _inventoryAlerts.add(InventoryAlert(
          itemId: item.id!,
          alertType: 'Expiry',
          message: '${item.name} expires in ${item.expiryDate.difference(DateTime.now()).inDays} days',
          alertDate: DateTime.now(),
        ));
        
        // Send notification for expiring soon item
        _notificationManager.sendInventoryAlert(item, 'Expiry');
      }
      
      if (item.isLowStock) {
        _inventoryAlerts.add(InventoryAlert(
          itemId: item.id!,
          alertType: 'LowStock',
          message: 'Low stock alert for ${item.name} (${item.quantity} ${item.unit} remaining)',
          alertDate: DateTime.now(),
        ));
        
        // Send notification for low stock item
        _notificationManager.sendInventoryAlert(item, 'LowStock');
      }
      
      if (item.isCritical && item.isLowStock) {
        _inventoryAlerts.add(InventoryAlert(
          itemId: item.id!,
          alertType: 'CriticalItem',
          message: 'Critical item ${item.name} is running low',
          alertDate: DateTime.now(),
        ));
        
        // Send notification for critical low stock item
        _notificationManager.sendInventoryAlert(item, 'CriticalItem');
      }
    }
  }
  
  // Get all inventory items
  List<InventoryItem> getAllInventoryItems() {
    return List.from(_inventoryItems);
  }
  
  // Get inventory items by category
  List<InventoryItem> getItemsByCategory(String category) {
    return _inventoryItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  // Get inventory items by storage location
  List<InventoryItem> getItemsByLocation(String location) {
    return _inventoryItems
        .where((item) => item.storageLocation.toLowerCase() == location.toLowerCase())
        .toList();
  }
  
  // Get inventory item by ID
  InventoryItem? getInventoryItemById(int id) {
    try {
      return _inventoryItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Search inventory items
  List<InventoryItem> searchItems(String query) {
    return _inventoryItems
        .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase()) ||
            item.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  // Get unique categories
  List<String> getCategories() {
    final categories = <String>{};
    for (final item in _inventoryItems) {
      categories.add(item.category);
    }
    return categories.toList();
  }
  
  // Get unique storage locations
  List<String> getStorageLocations() {
    final locations = <String>{};
    for (final item in _inventoryItems) {
      locations.add(item.storageLocation);
    }
    return locations.toList();
  }
  
  // Add new inventory item
  void addItem(InventoryItem item) {
    _inventoryItems.add(item);
    _generateAlerts();
  }
  
  // Update inventory item
  void updateItem(InventoryItem item) {
    final index = _inventoryItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _inventoryItems[index] = item;
      _generateAlerts();
    }
  }
  
  // Remove inventory item
  void removeItem(int itemId) {
    _inventoryItems.removeWhere((item) => item.id == itemId);
    _generateAlerts();
  }
  
  // Record item usage
  void recordUsage(InventoryUsage usage) {
    _inventoryUsage.add(usage);
    
    // Update item quantity
    final item = getInventoryItemById(usage.itemId);
    if (item != null) {
      final updatedItem = InventoryItem(
        id: item.id,
        name: item.name,
        category: item.category,
        description: item.description,
        quantity: item.quantity - usage.quantityUsed,
        unit: item.unit,
        purchaseDate: item.purchaseDate,
        expiryDate: item.expiryDate,
        purchasePrice: item.purchasePrice,
        currency: item.currency,
        supplier: item.supplier,
        storageLocation: item.storageLocation,
        batchNumber: item.batchNumber,
        isCritical: item.isCritical,
      );
      
      updateItem(updatedItem);
    }
  }
  
  // Get usage records for an item
  List<InventoryUsage> getUsageByItemId(int itemId) {
    return _inventoryUsage
        .where((usage) => usage.itemId == itemId)
        .toList();
  }
  
  // Get all inventory alerts
  List<InventoryAlert> getAllAlerts() {
    return List.from(_inventoryAlerts);
  }
  
  // Get unresolved alerts
  List<InventoryAlert> getUnresolvedAlerts() {
    return _inventoryAlerts
        .where((alert) => !alert.isResolved)
        .toList();
  }
  
  // Resolve an alert
  void resolveAlert(int alertId) {
    final index = _inventoryAlerts.indexWhere((alert) => alert.id == alertId);
    if (index != -1) {
      _inventoryAlerts[index] = InventoryAlert(
        id: _inventoryAlerts[index].id,
        itemId: _inventoryAlerts[index].itemId,
        alertType: _inventoryAlerts[index].alertType,
        message: _inventoryAlerts[index].message,
        alertDate: _inventoryAlerts[index].alertDate,
        isResolved: true,
      );
    }
  }
  
  // Mark alert as notified (used by notification manager)
  void markAlertAsNotified(int alertId) {
    // In a real implementation, we would track which alerts have been notified
    // For now, we'll just log the action
    print('Marked alert $alertId as notified');
  }
  
  // Get inventory statistics
  Map<String, dynamic> getInventoryStats() {
    final stats = <String, dynamic>{};
    
    // Total items count
    stats['totalItems'] = _inventoryItems.length;
    
    // Total value of inventory
    double totalValue = 0;
    for (final item in _inventoryItems) {
      totalValue += item.totalPrice;
    }
    stats['totalValue'] = totalValue;
    
    // Items by category count
    final categoryCounts = <String, int>{};
    for (final item in _inventoryItems) {
      if (categoryCounts.containsKey(item.category)) {
        categoryCounts[item.category] = categoryCounts[item.category]! + 1;
      } else {
        categoryCounts[item.category] = 1;
      }
    }
    stats['categoryCounts'] = categoryCounts;
    
    // Expired items count
    stats['expiredItems'] = _inventoryItems
        .where((item) => item.isExpired)
        .length;
    
    // Low stock items count
    stats['lowStockItems'] = _inventoryItems
        .where((item) => item.isLowStock)
        .length;
    
    return stats;
  }
}