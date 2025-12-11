import 'package:flutter/material.dart';
import 'package:farm_up/models/budget_item.dart';
import 'package:farm_up/services/budget_calculator_service.dart';

class BudgetCalculatorScreen extends StatefulWidget {
  const BudgetCalculatorScreen({super.key});

  @override
  State<BudgetCalculatorScreen> createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  final BudgetCalculatorService _budgetService = BudgetCalculatorService();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  
  List<BudgetItem> _budgetItems = [];
  Map<String, double> _categoryCosts = {};
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _updateBudgetSummary();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _updateBudgetSummary() {
    setState(() {
      _budgetItems = _budgetService.getBudgetItems();
      _categoryCosts = _budgetService.getCostByCategory();
      _totalCost = _budgetService.getTotalCost();
    });
  }

  void _addBudgetItem() {
    if (_formKey.currentState!.validate()) {
      final item = BudgetItem(
        name: _nameController.text,
        cost: double.tryParse(_costController.text) ?? 0.0,
        category: _categoryController.text,
        date: DateTime.now(),
      );
      
      _budgetService.addBudgetItem(item);
      _updateBudgetSummary();
      
      // Clear form
      _nameController.clear();
      _costController.clear();
      _categoryController.clear();
    }
  }

  void _removeBudgetItem(BudgetItem item) {
    _budgetService.removeBudgetItem(item);
    _updateBudgetSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Calculator'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Financial Planning',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Track your farming expenses and calculate potential profits.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total Expenses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${_totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an item name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _costController,
                      decoration: const InputDecoration(
                        labelText: 'Cost (\$)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a cost';
                        }
                        final cost = double.tryParse(value);
                        if (cost == null || cost < 0) {
                          return 'Please enter a valid cost';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addBudgetItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Add Expense'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Expense Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_categoryCosts.isEmpty)
                const Center(
                  child: Text('No expenses added yet'),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._categoryCosts.entries.map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(entry.key)),
                                  Text('\$${entry.value.toStringAsFixed(2)}'),
                                ],
                              ),
                            )),
                        const Divider(),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '\$${_totalCost.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Expense History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_budgetItems.isEmpty)
                const Center(
                  child: Text('No expenses recorded'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _budgetItems.length,
                  itemBuilder: (context, index) {
                    final item = _budgetItems[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.category} - ${item.date.toString().split(' ').first}'),
                        trailing: Text('\$${item.cost.toStringAsFixed(2)}'),
                        onLongPress: () => _removeBudgetItem(item),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}