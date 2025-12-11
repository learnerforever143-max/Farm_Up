import 'package:flutter/material.dart';
import 'package:farm_up/services/equipment_service.dart';
import 'package:farm_up/models/equipment.dart';

class EquipmentMarketplaceScreen extends StatefulWidget {
  const EquipmentMarketplaceScreen({super.key});

  @override
  State<EquipmentMarketplaceScreen> createState() => _EquipmentMarketplaceScreenState();
}

class _EquipmentMarketplaceScreenState extends State<EquipmentMarketplaceScreen> {
  final EquipmentService _equipmentService = EquipmentService();
  List<Equipment> _equipmentList = [];
  List<RentalEquipment> _rentalEquipmentList = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _showRental = false;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _equipmentService.initializeSampleData();
    _loadEquipmentData();
  }

  void _loadEquipmentData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final equipment = _equipmentService.getAllEquipment();
      final rentalEquipment = _equipmentService.getAllRentalEquipment();
      final categories = _equipmentService.getCategories();
      
      setState(() {
        _equipmentList = equipment;
        _rentalEquipmentList = rentalEquipment;
        _categories = ['All', ...categories];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load equipment: $e')),
        );
      }
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _toggleRentalView(bool showRental) {
    setState(() {
      _showRental = showRental;
    });
  }

  void _searchEquipment(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Equipment> _getFilteredEquipment() {
    List<Equipment> filtered = _showRental 
        ? _rentalEquipmentList.cast<Equipment>() 
        : _equipmentList;
    
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((equipment) => equipment.category == _selectedCategory)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((equipment) =>
              equipment.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              equipment.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    return filtered;
  }

  void _viewEquipmentDetails(Equipment equipment) {
    // In a real app, this would navigate to a detail screen
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(equipment.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  equipment.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(equipment.description),
                const SizedBox(height: 10),
                Text('Seller: ${equipment.sellerName}'),
                Text('Location: ${equipment.sellerLocation}'),
                Text('Condition: ${equipment.condition}'),
                Text(
                  _showRental && equipment is RentalEquipment
                      ? 'Daily Rate: \$${equipment.dailyRate.toStringAsFixed(2)}'
                      : 'Price: \$${equipment.price.toStringAsFixed(2)}',
                ),
                if (_showRental && equipment is RentalEquipment) ...[
                  Text('Deposit: \$${equipment.deposit.toStringAsFixed(2)}'),
                  Text('Rental Period: ${equipment.rentalPeriodDays} days'),
                ],
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text('${equipment.rating} (${equipment.reviewCount} reviews)'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _contactSeller(equipment);
                },
                child: const Text('Contact Seller'),
              ),
            ],
          );
        },
      );
    }
  }

  void _contactSeller(Equipment equipment) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contacting ${equipment.sellerName} at ${equipment.contactInfo}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEquipment = _getFilteredEquipment();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Marketplace'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search equipment...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: _searchEquipment,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('For Sale'),
                Switch(
                  value: _showRental,
                  onChanged: _toggleRentalView,
                ),
                const Text('For Rent'),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (_) => _filterByCategory(category),
                    selectedColor: Colors.green,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredEquipment.isEmpty
                    ? const Center(
                        child: Text(
                          'No equipment found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredEquipment.length,
                        itemBuilder: (context, index) {
                          final equipment = filteredEquipment[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _viewEquipmentDetails(equipment),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        equipment.imageUrl,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            _showRental ? 'RENTAL' : 'SALE',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          equipment.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          equipment.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _showRental && equipment is RentalEquipment
                                                  ? '\$${equipment.dailyRate.toStringAsFixed(2)}/day'
                                                  : '\$${equipment.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                Text(
                                                  equipment.rating.toString(),
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              equipment.sellerLocation,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              equipment.condition,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}