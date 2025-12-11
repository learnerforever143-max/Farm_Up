class Equipment {
  final int? id;
  final String name;
  final String description;
  final String category; // Tractors, Harvesters, Seeders, Tools, etc.
  final double price;
  final String currency;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String sellerName;
  final String sellerLocation;
  final bool isAvailable;
  final String condition; // New, Used, Refurbished
  final DateTime listingDate;
  final String contactInfo;

  Equipment({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.currency = 'USD',
    required this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.sellerName,
    required this.sellerLocation,
    this.isAvailable = true,
    this.condition = 'New',
    required this.listingDate,
    required this.contactInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'sellerName': sellerName,
      'sellerLocation': sellerLocation,
      'isAvailable': isAvailable,
      'condition': condition,
      'listingDate': listingDate.toIso8601String(),
      'contactInfo': contactInfo,
    };
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      currency: json['currency'] ?? 'USD',
      imageUrl: json['imageUrl'],
      rating: json['rating'] ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      sellerName: json['sellerName'],
      sellerLocation: json['sellerLocation'],
      isAvailable: json['isAvailable'] ?? true,
      condition: json['condition'] ?? 'New',
      listingDate: DateTime.parse(json['listingDate']),
      contactInfo: json['contactInfo'],
    );
  }
}

class RentalEquipment extends Equipment {
  final int rentalPeriodDays;
  final double dailyRate;
  final double deposit;
  final List<DateTime> bookedDates;

  RentalEquipment({
    int? id,
    required String name,
    required String description,
    required String category,
    required double price,
    String currency = 'USD',
    required String imageUrl,
    double rating = 0.0,
    int reviewCount = 0,
    required String sellerName,
    required String sellerLocation,
    bool isAvailable = true,
    String condition = 'New',
    required DateTime listingDate,
    required String contactInfo,
    required this.rentalPeriodDays,
    required this.dailyRate,
    required this.deposit,
    List<DateTime>? bookedDates,
  }) : bookedDates = bookedDates ?? [],
       super(
         id: id,
         name: name,
         description: description,
         category: category,
         price: price,
         currency: currency,
         imageUrl: imageUrl,
         rating: rating,
         reviewCount: reviewCount,
         sellerName: sellerName,
         sellerLocation: sellerLocation,
         isAvailable: isAvailable,
         condition: condition,
         listingDate: listingDate,
         contactInfo: contactInfo,
       );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['rentalPeriodDays'] = rentalPeriodDays;
    json['dailyRate'] = dailyRate;
    json['deposit'] = deposit;
    json['bookedDates'] = bookedDates.map((d) => d.toIso8601String()).toList();
    return json;
  }

  factory RentalEquipment.fromJson(Map<String, dynamic> json) {
    return RentalEquipment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      currency: json['currency'] ?? 'USD',
      imageUrl: json['imageUrl'],
      rating: json['rating'] ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      sellerName: json['sellerName'],
      sellerLocation: json['sellerLocation'],
      isAvailable: json['isAvailable'] ?? true,
      condition: json['condition'] ?? 'New',
      listingDate: DateTime.parse(json['listingDate']),
      contactInfo: json['contactInfo'],
      rentalPeriodDays: json['rentalPeriodDays'],
      dailyRate: json['dailyRate'],
      deposit: json['deposit'],
      bookedDates: (json['bookedDates'] as List)
          .map((d) => DateTime.parse(d))
          .toList(),
    );
  }
}