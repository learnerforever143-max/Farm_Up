import 'package:farm_up/models/supply_chain.dart';

class SupplyChainService {
  List<SupplyChainRecord> _supplyChainRecords = [];
  List<QualityCertificate> _qualityCertificates = [];
  List<BuyerVerification> _buyerVerifications = [];
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample traceability events
    final harvestEvent = TraceabilityEvent(
      id: 1,
      supplyChainRecordId: 1,
      eventType: 'Harvest',
      location: 'North Field, Farm ABC',
      handler: 'Farmer John',
      eventDate: DateTime(2025, 12, 1),
      notes: 'Harvested 500 kg of premium wheat',
      metadata: {'moistureLevel': '12%', 'temperature': '25°C'},
    );
    
    final processingEvent = TraceabilityEvent(
      id: 2,
      supplyChainRecordId: 1,
      eventType: 'Processing',
      location: 'ABC Processing Unit',
      handler: 'Processor XYZ',
      eventDate: DateTime(2025, 12, 3),
      notes: 'Cleaning and grading completed',
      metadata: {'grade': 'Premium', 'impurities': '0.5%'},
    );
    
    final packagingEvent = TraceabilityEvent(
      id: 3,
      supplyChainRecordId: 1,
      eventType: 'Packaging',
      location: 'XYZ Packaging Center',
      handler: 'Packager PQR',
      eventDate: DateTime(2025, 12, 4),
      notes: 'Packaged in 50kg bags',
      metadata: {'packagingType': 'Jute bags', 'sealNumber': 'PKG20251204'},
    );
    
    // Sample supply chain record
    final wheatRecord = SupplyChainRecord(
      id: 1,
      productId: 'PRD001',
      productName: 'Premium Wheat',
      farmerId: 'FAR001',
      farmName: 'Green Valley Farm',
      originLocation: 'North Field, Green Valley Farm',
      harvestDate: DateTime(2025, 12, 1),
      quantity: 500.0,
      unit: 'kg',
      qualityGrade: 'Premium',
      traceabilityEvents: [harvestEvent, processingEvent, packagingEvent],
      currentLocation: 'XYZ Packaging Center',
      currentHandler: 'Packager PQR',
      createdAt: DateTime(2025, 12, 1),
      status: 'Packaged',
    );
    
    // Sample quality certificate
    final organicCert = QualityCertificate(
      id: 1,
      certificateNumber: 'ORG20251201',
      supplyChainRecordId: 1,
      certificateType: 'Organic',
      issuingAuthority: 'National Organic Certification Authority',
      issueDate: DateTime(2025, 12, 1),
      expiryDate: DateTime(2026, 12, 1),
      scope: 'Whole farm production',
      status: 'Active',
    );
    
    // Sample buyer verification
    final verifiedBuyer = BuyerVerification(
      id: 1,
      buyerId: 'BUY001',
      buyerName: 'John Smith',
      companyName: 'Premium Foods Ltd.',
      verificationStatus: 'Verified',
      verificationDate: DateTime(2025, 11, 30),
      verifier: 'Certification Body ABC',
      notes: 'Annual verification completed successfully',
    );
    
    _supplyChainRecords = [wheatRecord];
    _qualityCertificates = [organicCert];
    _buyerVerifications = [verifiedBuyer];
  }
  
  // Add new supply chain record
  void addSupplyChainRecord(SupplyChainRecord record) {
    _supplyChainRecords.add(record);
  }
  
  // Get all supply chain records
  List<SupplyChainRecord> getAllSupplyChainRecords() {
    return List.from(_supplyChainRecords);
  }
  
  // Get supply chain record by ID
  SupplyChainRecord? getSupplyChainRecordById(int id) {
    try {
      return _supplyChainRecords.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get supply chain records by product name
  List<SupplyChainRecord> getSupplyChainRecordsByProductName(String productName) {
    return _supplyChainRecords
        .where((record) => 
            record.productName.toLowerCase().contains(productName.toLowerCase()))
        .toList();
  }
  
  // Get supply chain records by farmer ID
  List<SupplyChainRecord> getSupplyChainRecordsByFarmerId(String farmerId) {
    return _supplyChainRecords
        .where((record) => record.farmerId == farmerId)
        .toList();
  }
  
  // Get supply chain records by status
  List<SupplyChainRecord> getSupplyChainRecordsByStatus(String status) {
    return _supplyChainRecords
        .where((record) => record.status.toLowerCase() == status.toLowerCase())
        .toList();
  }
  
  // Update supply chain record status
  bool updateSupplyChainRecordStatus(int recordId, String newStatus, String location, String handler) {
    final index = _supplyChainRecords.indexWhere((record) => record.id == recordId);
    if (index != -1) {
      final record = _supplyChainRecords[index];
      final updatedRecord = SupplyChainRecord(
        id: record.id,
        productId: record.productId,
        productName: record.productName,
        farmerId: record.farmerId,
        farmName: record.farmName,
        originLocation: record.originLocation,
        harvestDate: record.harvestDate,
        quantity: record.quantity,
        unit: record.unit,
        qualityGrade: record.qualityGrade,
        traceabilityEvents: record.traceabilityEvents,
        currentLocation: location,
        currentHandler: handler,
        createdAt: record.createdAt,
        status: newStatus,
      );
      
      _supplyChainRecords[index] = updatedRecord;
      return true;
    }
    return false;
  }
  
  // Add traceability event to a supply chain record
  bool addTraceabilityEvent(int recordId, TraceabilityEvent event) {
    final record = getSupplyChainRecordById(recordId);
    if (record != null) {
      final index = _supplyChainRecords.indexWhere((r) => r.id == recordId);
      final updatedRecord = SupplyChainRecord(
        id: record.id,
        productId: record.productId,
        productName: record.productName,
        farmerId: record.farmerId,
        farmName: record.farmName,
        originLocation: record.originLocation,
        harvestDate: record.harvestDate,
        quantity: record.quantity,
        unit: record.unit,
        qualityGrade: record.qualityGrade,
        traceabilityEvents: [...record.traceabilityEvents, event],
        currentLocation: record.currentLocation,
        currentHandler: record.currentHandler,
        createdAt: record.createdAt,
        status: record.status,
      );
      
      _supplyChainRecords[index] = updatedRecord;
      return true;
    }
    return false;
  }
  
  // Get all quality certificates
  List<QualityCertificate> getAllQualityCertificates() {
    return List.from(_qualityCertificates);
  }
  
  // Get quality certificate by ID
  QualityCertificate? getQualityCertificateById(int id) {
    try {
      return _qualityCertificates.firstWhere((cert) => cert.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get quality certificates by supply chain record ID
  List<QualityCertificate> getQualityCertificatesByRecordId(int recordId) {
    return _qualityCertificates
        .where((cert) => cert.supplyChainRecordId == recordId)
        .toList();
  }
  
  // Add quality certificate
  void addQualityCertificate(QualityCertificate certificate) {
    _qualityCertificates.add(certificate);
  }
  
  // Get all buyer verifications
  List<BuyerVerification> getAllBuyerVerifications() {
    return List.from(_buyerVerifications);
  }
  
  // Get buyer verification by ID
  BuyerVerification? getBuyerVerificationById(int id) {
    try {
      return _buyerVerifications.firstWhere((buyer) => buyer.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get buyer verification by buyer ID
  BuyerVerification? getBuyerVerificationByBuyerId(String buyerId) {
    try {
      return _buyerVerifications.firstWhere((buyer) => buyer.buyerId == buyerId);
    } catch (e) {
      return null;
    }
  }
  
  // Add buyer verification
  void addBuyerVerification(BuyerVerification verification) {
    _buyerVerifications.add(verification);
  }
  
  // Get verified buyers only
  List<BuyerVerification> getVerifiedBuyers() {
    return _buyerVerifications
        .where((buyer) => buyer.isVerified)
        .toList();
  }
  
  // Get supply chain statistics
  Map<String, dynamic> getSupplyChainStats() {
    final stats = <String, dynamic>{};
    
    stats['totalRecords'] = _supplyChainRecords.length;
    stats['activeRecords'] = _supplyChainRecords
        .where((record) => record.status != 'Delivered')
        .length;
    
    // Count by status
    final statusCount = <String, int>{};
    for (final record in _supplyChainRecords) {
      if (statusCount.containsKey(record.status)) {
        statusCount[record.status] = statusCount[record.status]! + 1;
      } else {
        statusCount[record.status] = 1;
      }
    }
    stats['statusDistribution'] = statusCount;
    
    // Verified buyers count
    stats['verifiedBuyers'] = _buyerVerifications
        .where((buyer) => buyer.isVerified)
        .length;
    
    // Active certificates count
    stats['activeCertificates'] = _qualityCertificates
        .where((cert) => cert.isValid)
        .length;
    
    return stats;
  }
}