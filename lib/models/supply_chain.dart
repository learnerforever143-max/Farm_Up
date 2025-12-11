class SupplyChainRecord {
  final int? id;
  final String productId;
  final String productName;
  final String farmerId;
  final String farmName;
  final String originLocation;
  final DateTime harvestDate;
  final double quantity;
  final String unit; // kg, quintals, tons
  final String qualityGrade; // Premium, Standard, Low
  final List<TraceabilityEvent> traceabilityEvents;
  final String currentLocation;
  final String currentHandler;
  final DateTime createdAt;
  final String status; // Harvested, Processed, Packaged, In Transit, Delivered

  SupplyChainRecord({
    this.id,
    required this.productId,
    required this.productName,
    required this.farmerId,
    required this.farmName,
    required this.originLocation,
    required this.harvestDate,
    required this.quantity,
    required this.unit,
    required this.qualityGrade,
    List<TraceabilityEvent>? traceabilityEvents,
    required this.currentLocation,
    required this.currentHandler,
    required this.createdAt,
    required this.status,
  }) : traceabilityEvents = traceabilityEvents ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'farmerId': farmerId,
      'farmName': farmName,
      'originLocation': originLocation,
      'harvestDate': harvestDate.toIso8601String(),
      'quantity': quantity,
      'unit': unit,
      'qualityGrade': qualityGrade,
      'traceabilityEvents': traceabilityEvents.map((te) => te.toJson()).toList(),
      'currentLocation': currentLocation,
      'currentHandler': currentHandler,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory SupplyChainRecord.fromJson(Map<String, dynamic> json) {
    return SupplyChainRecord(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      farmerId: json['farmerId'],
      farmName: json['farmName'],
      originLocation: json['originLocation'],
      harvestDate: DateTime.parse(json['harvestDate']),
      quantity: json['quantity'],
      unit: json['unit'],
      qualityGrade: json['qualityGrade'],
      traceabilityEvents: (json['traceabilityEvents'] as List)
          .map((te) => TraceabilityEvent.fromJson(te))
          .toList(),
      currentLocation: json['currentLocation'],
      currentHandler: json['currentHandler'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }

  String get formattedQuantity {
    return '$quantity $unit';
  }
}

class TraceabilityEvent {
  final int? id;
  final int supplyChainRecordId;
  final String eventType; // Harvest, Processing, Packaging, Transport, Delivery
  final String location;
  final String handler;
  final DateTime eventDate;
  final String notes;
  final Map<String, dynamic> metadata;

  TraceabilityEvent({
    this.id,
    required this.supplyChainRecordId,
    required this.eventType,
    required this.location,
    required this.handler,
    required this.eventDate,
    required this.notes,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplyChainRecordId': supplyChainRecordId,
      'eventType': eventType,
      'location': location,
      'handler': handler,
      'eventDate': eventDate.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
    };
  }

  factory TraceabilityEvent.fromJson(Map<String, dynamic> json) {
    return TraceabilityEvent(
      id: json['id'],
      supplyChainRecordId: json['supplyChainRecordId'],
      eventType: json['eventType'],
      location: json['location'],
      handler: json['handler'],
      eventDate: DateTime.parse(json['eventDate']),
      notes: json['notes'],
      metadata: json['metadata'] ?? {},
    );
  }
}

class QualityCertificate {
  final int? id;
  final String certificateNumber;
  final int supplyChainRecordId;
  final String certificateType; // Organic, ISO, HACCP, etc.
  final String issuingAuthority;
  final DateTime issueDate;
  final DateTime expiryDate;
  final String scope;
  final String status; // Active, Expired, Revoked

  QualityCertificate({
    this.id,
    required this.certificateNumber,
    required this.supplyChainRecordId,
    required this.certificateType,
    required this.issuingAuthority,
    required this.issueDate,
    required this.expiryDate,
    required this.scope,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificateNumber': certificateNumber,
      'supplyChainRecordId': supplyChainRecordId,
      'certificateType': certificateType,
      'issuingAuthority': issuingAuthority,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'scope': scope,
      'status': status,
    };
  }

  factory QualityCertificate.fromJson(Map<String, dynamic> json) {
    return QualityCertificate(
      id: json['id'],
      certificateNumber: json['certificateNumber'],
      supplyChainRecordId: json['supplyChainRecordId'],
      certificateType: json['certificateType'],
      issuingAuthority: json['issuingAuthority'],
      issueDate: DateTime.parse(json['issueDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      scope: json['scope'],
      status: json['status'],
    );
  }

  bool get isValid {
    return status == 'Active' && DateTime.now().isBefore(expiryDate);
  }
}

class BuyerVerification {
  final int? id;
  final String buyerId;
  final String buyerName;
  final String companyName;
  final String verificationStatus; // Verified, Pending, Rejected
  final DateTime verificationDate;
  final String verifier;
  final String notes;

  BuyerVerification({
    this.id,
    required this.buyerId,
    required this.buyerName,
    required this.companyName,
    required this.verificationStatus,
    required this.verificationDate,
    required this.verifier,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'companyName': companyName,
      'verificationStatus': verificationStatus,
      'verificationDate': verificationDate.toIso8601String(),
      'verifier': verifier,
      'notes': notes,
    };
  }

  factory BuyerVerification.fromJson(Map<String, dynamic> json) {
    return BuyerVerification(
      id: json['id'],
      buyerId: json['buyerId'],
      buyerName: json['buyerName'],
      companyName: json['companyName'],
      verificationStatus: json['verificationStatus'],
      verificationDate: DateTime.parse(json['verificationDate']),
      verifier: json['verifier'],
      notes: json['notes'],
    );
  }

  bool get isVerified {
    return verificationStatus == 'Verified';
  }
}