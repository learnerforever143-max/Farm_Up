import 'package:farm_up/models/equipment.dart';

class EquipmentService {
  List<Equipment> _equipmentList = [];
  List<RentalEquipment> _rentalEquipmentList = [];
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample equipment for sale
    final tractor1 = Equipment(
      id: 1,
      name: 'John Deere 5075E',
      description: '24.8 kW (34 hp) 4WD Utility Tractor with Loader',
      category: 'Tractors',
      price: 25000.0,
      currency: 'USD',
      imageUrl: 'assets/images/tractor1.jpg',
      rating: 4.8,
      reviewCount: 42,
      sellerName: 'Farm Equipment Plus',
      sellerLocation: 'Springfield, IL',
      isAvailable: true,
      condition: 'New',
      listingDate: DateTime.now().subtract(const Duration(days: 5)),
      contactInfo: 'contact@farmequipmentplus.com',
    );
    
    final harvester1 = Equipment(
      id: 2,
      name: 'Case IH Axial-Flow 7130',
      description: 'High-capacity combine harvester for wheat and corn',
      category: 'Harvesters',
      price: 185000.0,
      currency: 'USD',
      imageUrl: 'assets/images/harvester1.jpg',
      rating: 4.6,
      reviewCount: 28,
      sellerName: 'AgriMachines Inc.',
      sellerLocation: 'Omaha, NE',
      isAvailable: true,
      condition: 'Used',
      listingDate: DateTime.now().subtract(const Duration(days: 2)),
      contactInfo: 'sales@agrimachines.com',
    );
    
    final seeder1 = Equipment(
      id: 3,
      name: 'Great Plains Turbo Drop',
      description: 'Precision seed drill for accurate planting',
      category: 'Seeders',
      price: 18500.0,
      currency: 'USD',
      imageUrl: 'assets/images/seeder1.jpg',
      rating: 4.7,
      reviewCount: 35,
      sellerName: 'Precision Planting Co.',
      sellerLocation: 'Lincoln, NE',
      isAvailable: true,
      condition: 'New',
      listingDate: DateTime.now().subtract(const Duration(days: 10)),
      contactInfo: 'info@precisionplanting.com',
    );
    
    // Sample rental equipment
    final rentalTractor = RentalEquipment(
      id: 4,
      name: 'Kubota BX23L1',
      description: 'Compact utility tractor with loader - perfect for small farms',
      category: 'Tractors',
      price: 15000.0,
      currency: 'USD',
      imageUrl: 'assets/images/compact_tractor.jpg',
      rating: 4.9,
      reviewCount: 56,
      sellerName: 'Local Farm Rentals',
      sellerLocation: 'Green Valley, CA',
      isAvailable: true,
      condition: 'Refurbished',
      listingDate: DateTime.now().subtract(const Duration(days: 3)),
      contactInfo: 'rentals@localfarm.com',
      rentalPeriodDays: 7,
      dailyRate: 150.0,
      deposit: 2000.0,
    );
    
    _equipmentList = [tractor1, harvester1, seeder1];
    _rentalEquipmentList = [rentalTractor];
  }
  
  // Get all equipment for sale
  List<Equipment> getAllEquipment() {
    return List.from(_equipmentList);
  }
  
  // Get all rental equipment
  List<RentalEquipment> getAllRentalEquipment() {
    return List.from(_rentalEquipmentList);
  }
  
  // Get equipment by category
  List<Equipment> getEquipmentByCategory(String category) {
    return _equipmentList
        .where((equipment) => equipment.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  // Get rental equipment by category
  List<RentalEquipment> getRentalEquipmentByCategory(String category) {
    return _rentalEquipmentList
        .where((equipment) => equipment.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  // Search equipment by name or description
  List<Equipment> searchEquipment(String query) {
    return _equipmentList
        .where((equipment) =>
            equipment.name.toLowerCase().contains(query.toLowerCase()) ||
            equipment.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  // Search rental equipment by name or description
  List<RentalEquipment> searchRentalEquipment(String query) {
    return _rentalEquipmentList
        .where((equipment) =>
            equipment.name.toLowerCase().contains(query.toLowerCase()) ||
            equipment.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  // Get equipment by ID
  Equipment? getEquipmentById(int id) {
    try {
      return _equipmentList.firstWhere((equipment) => equipment.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get rental equipment by ID
  RentalEquipment? getRentalEquipmentById(int id) {
    try {
      return _rentalEquipmentList.firstWhere((equipment) => equipment.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get unique categories
  List<String> getCategories() {
    final categories = <String>{};
    for (final equipment in _equipmentList) {
      categories.add(equipment.category);
    }
    for (final equipment in _rentalEquipmentList) {
      categories.add(equipment.category);
    }
    return categories.toList();
  }
  
  // Add new equipment listing
  void addEquipment(Equipment equipment) {
    _equipmentList.add(equipment);
  }
  
  // Add new rental equipment listing
  void addRentalEquipment(RentalEquipment equipment) {
    _rentalEquipmentList.add(equipment);
  }
  
  // Get featured equipment (high-rated items)
  List<Equipment> getFeaturedEquipment() {
    return _equipmentList
        .where((equipment) => equipment.rating >= 4.5)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }
  
  // Get featured rental equipment
  List<RentalEquipment> getFeaturedRentalEquipment() {
    return _rentalEquipmentList
        .where((equipment) => equipment.rating >= 4.5)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }
  
  // Filter by price range
  List<Equipment> filterEquipmentByPrice(double minPrice, double maxPrice) {
    return _equipmentList
        .where((equipment) => 
            equipment.price >= minPrice && equipment.price <= maxPrice)
        .toList();
  }
  
  // Filter rental equipment by daily rate
  List<RentalEquipment> filterRentalEquipmentByRate(double minRate, double maxRate) {
    return _rentalEquipmentList
        .where((equipment) => 
            equipment.dailyRate >= minRate && equipment.dailyRate <= maxRate)
        .toList();
  }
}