import 'package:flutter/material.dart';
import 'package:farm_up/services/inventory_service.dart';
import 'package:farm_up/models/inventory_item.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final InventoryService _inventoryService = InventoryService();
  List<InventoryItem> _inventoryItems = [];
  List<InventoryAlert> _inventoryAlerts = [];
  List<String> _categories = [];
  List<String> _locations = [];
  Map<String, dynamic> _inventoryStats = {};
  String _selectedCategory = 'All';
  String _selectedLocation = 'All';
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _inventoryService.initializeSampleData();
    _loadInventoryData();
  }

  void _loadInventoryData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = _inventoryService.getAllInventoryItems();
      final alerts = _inventoryService.getUnresolvedAlerts();
      final categories = _inventoryService.getCategories();
      final locations = _inventoryService.getStorageLocations();
      final stats = _inventoryService.getInventoryStats();
      
      setState(() {
        _inventoryItems = items;
        _inventoryAlerts = alerts;
        _categories = ['All', ...categories];
        _locations = ['All', ...locations];
        _inventoryStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load inventory data: $e')),
        );
      }
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _filterByLocation(String location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _searchItems(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<InventoryItem> _getFilteredItems() {
    List<InventoryItem> filtered = _inventoryItems;
    
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item.category == _selectedCategory)
          .toList();
    }
    
    if (_selectedLocation != 'All') {
      filtered = filtered
          .where((item) => item.storageLocation == _selectedLocation)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    return filtered;
  }

  void _viewItemDetails(InventoryItem item) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(item.name),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text('Category: ${item.category}'),
                  Text('Quantity: ${item.quantity} ${item.unit}'),
                  Text('Purchase Date: ${item.purchaseDate.toString().split(' ').first}'),
                  Text('Expiry Date: ${item.expiryDate.toString().split(' ').first}'),
                  Text(
                    'Purchase Price: ${item.purchasePrice} ${item.currency}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Total Value: ${item.totalPrice.toStringAsFixed(2)} ${item.currency}'),
                  const SizedBox(height: 10),
                  Text('Supplier: ${item.supplier}'),
                  Text('Storage Location: ${item.storageLocation}'),
                  Text('Batch Number: ${item.batchNumber}'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        item.isExpired 
                            ? Icons.error 
                            : item.isExpiringSoon 
                                ? Icons.warning 
                                : Icons.check_circle,
                        color: item.isExpired 
                            ? Colors.red 
                            : item.isExpiringSoon 
                                ? Colors.orange 
                                : Colors.green,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.isExpired 
                            ? 'Expired' 
                            : item.isExpiringSoon 
                                ? 'Expiring Soon' 
                                : 'Good Condition',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _editItem(item);
                },
                child: const Text('Edit'),
              ),
            ],
          );
        },
      );
    }
  }

  void _addItem() {
    // In a real app, this would open a form to add new inventory items
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding new inventory item...')),
      );
    }
  }

  void _editItem(InventoryItem item) {
    // In a real app, this would open a form to edit the item
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Editing ${item.name}...')),
      );
    }
  }

  void _resolveAlert(InventoryAlert alert) {
    _inventoryService.resolveAlert(alert.id!);
    _loadInventoryData(); // Refresh the data
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alert resolved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredItems();
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Management'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Inventory'),
              Tab(text: 'Alerts'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Inventory Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search inventory...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: _searchItems,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) => _filterByCategory(category),
                            selectedColor: Colors.green,
                          );
                        });
                      }),
                      const SizedBox(width: 10),
                      ..._locations.map((location) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(location),
                            selected: _selectedLocation == location,
                            onSelected: (_) => _filterByLocation(location),
                            selectedColor: Colors.green,
                          );
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Inventory Stats
                if (_inventoryStats.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildStatCard(
                          'Total Items',
                          '${_inventoryStats['totalItems']}',
                          Icons.inventory,
                          Colors.green,
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          'Total Value',
                          '\$${_inventoryStats['totalValue']?.toStringAsFixed(0) ?? '0'}',
                          Icons.attach_money,
                          Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          'Expired',
                          '${_inventoryStats['expiredItems']}',
                          Icons.error,
                          Colors.red,
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          'Low Stock',
                          '${_inventoryStats['lowStockItems']}',
                          Icons.warning,
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredItems.isEmpty
                          ? const Center(
                              child: Text(
                                'No inventory items found',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(item.name),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.description),
                                        Text(
                                          '${item.category} - ${item.storageLocation}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity} ${item.unit}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          item.isExpired 
                                              ? Icons.error 
                                              : item.isExpiringSoon 
                                                  ? Icons.warning 
                                                  : item.isLowStock 
                                                      ? Icons.low_priority 
                                                      : Icons.check_circle,
                                          color: item.isExpired 
                                              ? Colors.red 
                                              : item.isExpiringSoon 
                                                  ? Colors.orange 
                                                  : item.isLowStock 
                                                      ? Colors.yellow 
                                                      : Colors.green,
                                          size: 16,
                                        ),
                                        Text(
                                          item.expiryDate.toString().split(' ').first,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    onTap: () => _viewItemDetails(item),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            
            // Alerts Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inventory Alerts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_inventoryAlerts.isEmpty)
                      const Center(
                        child: Text('No alerts at this time'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _inventoryAlerts.length,
                        itemBuilder: (context, index) {
                          final alert = _inventoryAlerts[index];
                          // Get item details for this alert
                          final item = _inventoryService.getItemById(alert.itemId);
                          
                          return Card(
                            color: alert.alertType == 'Expiry' 
                                ? Colors.red[50] 
                                : alert.alertType == 'LowStock' 
                                    ? Colors.orange[50] 
                                    : Colors.blue[50],
                            child: ListTile(
                              title: Text(item?.name ?? 'Unknown Item'),
                              subtitle: Text(alert.message),
                              trailing: ElevatedButton(
                                onPressed: () => _resolveAlert(alert),
                                child: const Text('Resolve'),
                              ),
                              leading: Icon(
                                alert.alertType == 'Expiry' 
                                    ? Icons.error 
                                    : alert.alertType == 'LowStock' 
                                        ? Icons.warning 
                                        : Icons.info,
                                color: alert.alertType == 'Expiry' 
                                    ? Colors.red 
                                    : alert.alertType == 'LowStock' 
                                        ? Colors.orange 
                                        : Colors.blue,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            
            // Analytics Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inventory Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Category Distribution
                      const Text(
                        'Items by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if ((_inventoryStats['categoryCounts'] as Map?)?.isEmpty ?? true)
                        const Center(
                          child: Text('No category data available'),
                        )
                      else
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: (_inventoryStats['categoryCounts'] as Map?)
                                  ?.entries
                                  .map((entry) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(entry.key),
                                            Text('${entry.value} items'),
                                          ],
                                        ),
                                      ))
                                  .toList() ??
                                  [],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Storage Locations
                      const Text(
                        'Storage Locations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_locations.length <= 1)
                        const Center(
                          child: Text('No location data available'),
                        )
                      else
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: _locations
                                  .where((loc) => loc != 'All')
                                  .map((location) {
                                    final locationItems = _inventoryService.getItemsByLocation(location);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(location),
                                          Text('${locationItems.length} items'),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addItem,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: color,
      child: SizedBox(
        width: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}