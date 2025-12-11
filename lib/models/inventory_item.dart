class InventoryItem {
  final int? id;
  final String name;
  final String category; // Seeds, Fertilizers, Pesticides, Tools, etc.
  final String description;
  final double quantity;
  final String unit; // kg, liters, pieces, bags, etc.
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final double purchasePrice;
  final String currency;
  final String supplier;
  final String storageLocation;
  final String batchNumber;
  final bool isCritical;

  InventoryItem({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.purchaseDate,
    required this.expiryDate,
    required this.purchasePrice,
    this.currency = 'USD',
    required this.supplier,
    required this.storageLocation,
    required this.batchNumber,
    this.isCritical = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'purchasePrice': purchasePrice,
      'currency': currency,
      'supplier': supplier,
      'storageLocation': storageLocation,
      'batchNumber': batchNumber,
      'isCritical': isCritical,
    };
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      quantity: json['quantity'],
      unit: json['unit'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      purchasePrice: json['purchasePrice'],
      currency: json['currency'] ?? 'USD',
      supplier: json['supplier'],
      storageLocation: json['storageLocation'],
      batchNumber: json['batchNumber'],
      isCritical: json['isCritical'] ?? false,
    );
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }

  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  bool get isLowStock {
    // This would depend on the item type and farm requirements
    // For demonstration, we'll use a simple threshold
    return quantity < 5.0;
  }

  double get totalPrice {
    return quantity * purchasePrice;
  }
}

class InventoryAlert {
  final int? id;
  final int itemId;
  final String alertType; // Expiry, LowStock, CriticalItem
  final String message;
  final DateTime alertDate;
  final bool isResolved;

  InventoryAlert({
    this.id,
    required this.itemId,
    required this.alertType,
    required this.message,
    required this.alertDate,
    this.isResolved = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'alertType': alertType,
      'message': message,
      'alertDate': alertDate.toIso8601String(),
      'isResolved': isResolved,
    };
  }

  factory InventoryAlert.fromJson(Map<String, dynamic> json) {
    return InventoryAlert(
      id: json['id'],
      itemId: json['itemId'],
      alertType: json['alertType'],
      message: json['message'],
      alertDate: DateTime.parse(json['alertDate']),
      isResolved: json['isResolved'] ?? false,
    );
  }
}

class InventoryUsage {
  final int? id;
  final int itemId;
  final double quantityUsed;
  final DateTime usageDate;
  final String purpose; // Application, Repair, Consumption, etc.
  final String notes;

  InventoryUsage({
    this.id,
    required this.itemId,
    required this.quantityUsed,
    required this.usageDate,
    required this.purpose,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'quantityUsed': quantityUsed,
      'usageDate': usageDate.toIso8601String(),
      'purpose': purpose,
      'notes': notes,
    };
  }

  factory InventoryUsage.fromJson(Map<String, dynamic> json) {
    return InventoryUsage(
      id: json['id'],
      itemId: json['itemId'],
      quantityUsed: json['quantityUsed'],
      usageDate: DateTime.parse(json['usageDate']),
      purpose: json['purpose'],
      notes: json['notes'] ?? '',
    );
  }
}