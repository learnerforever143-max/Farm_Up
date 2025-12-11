class BudgetItem {
  final String name;
  final double cost;
  final String category; // Seeds, fertilizers, pesticides, irrigation, labor
  final DateTime date;

  BudgetItem({
    required this.name,
    required this.cost,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      name: json['name'],
      cost: json['cost'],
      category: json['category'],
      date: DateTime.parse(json['date']),
    );
  }
}