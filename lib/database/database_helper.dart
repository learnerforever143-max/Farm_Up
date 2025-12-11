import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:farm_up/models/user.dart';
import 'package:farm_up/models/soil_data.dart';
import 'package:farm_up/models/crop_recommendation.dart';
import 'package:farm_up/models/budget_item.dart';
import 'package:farm_up/models/weather_data.dart';
import 'package:farm_up/models/water_schedule.dart';
import 'package:farm_up/models/disease_record.dart';
import 'package:farm_up/models/video_tutorial.dart';
import 'package:farm_up/models/livestock.dart';
import 'package:farm_up/models/market_price.dart';
import 'package:farm_up/models/equipment.dart';
import 'package:farm_up/models/government_scheme.dart';
import 'package:farm_up/models/community_post.dart';
import 'package:farm_up/models/yield_data.dart';
import 'package:farm_up/models/organic_certification.dart';
import 'package:farm_up/models/inventory_item.dart';
import 'package:farm_up/models/insurance_policy.dart';
import 'package:farm_up/models/supply_chain.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'farm_up.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        farmName TEXT,
        farmSize REAL,
        location TEXT,
        createdAt TEXT
      )
    ''');

    // Create soil_data table
    await db.execute('''
      CREATE TABLE soil_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        pH REAL,
        nitrogen REAL,
        phosphorus REAL,
        potassium REAL,
        moisture REAL,
        organicCarbon REAL,
        temperature REAL,
        createdAt TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create crop_recommendations table
    await db.execute('''
      CREATE TABLE crop_recommendations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        soilDataId INTEGER,
        cropName TEXT,
        expectedYield REAL,
        season TEXT,
        profitabilityScore REAL,
        recommendations TEXT,
        createdAt TEXT,
        FOREIGN KEY (soilDataId) REFERENCES soil_data(id)
      )
    ''');

    // Create budget_items table
    await db.execute('''
      CREATE TABLE budget_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        itemName TEXT,
        itemType TEXT,
        quantity REAL,
        unitPrice REAL,
        totalPrice REAL,
        date TEXT,
        category TEXT,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create weather_data table
    await db.execute('''
      CREATE TABLE weather_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        date TEXT,
        temperature REAL,
        humidity REAL,
        rainfall REAL,
        windSpeed REAL,
        forecast TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create water_schedules table
    await db.execute('''
      CREATE TABLE water_schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        fieldName TEXT,
        scheduledDate TEXT,
        durationMinutes INTEGER,
        waterAmount REAL,
        irrigationMethod TEXT,
        status TEXT,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create disease_records table
    await db.execute('''
      CREATE TABLE disease_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        cropName TEXT,
        diseaseName TEXT,
        imageUrl TEXT,
        diagnosisDate TEXT,
        severity TEXT,
        treatment TEXT,
        status TEXT,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create video_tutorials table
    await db.execute('''
      CREATE TABLE video_tutorials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        category TEXT,
        duration TEXT,
        url TEXT,
        thumbnailUrl TEXT,
        isFavorite INTEGER,
        viewCount INTEGER,
        uploadDate TEXT
      )
    ''');

    // Create livestock table
    await db.execute('''
      CREATE TABLE livestock (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        animalType TEXT,
        breed TEXT,
        name TEXT,
        age INTEGER,
        weight REAL,
        healthStatus TEXT,
        lastVaccination TEXT,
        nextVaccination TEXT,
        feedType TEXT,
        dailyFeedCost REAL,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create market_prices table
    await db.execute('''
      CREATE TABLE market_prices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cropName TEXT,
        marketName TEXT,
        price REAL,
        unit TEXT,
        date TEXT,
        trend TEXT,
        qualityGrade TEXT
      )
    ''');

    // Create equipment table
    await db.execute('''
      CREATE TABLE equipment (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        description TEXT,
        dailyRate REAL,
        ownerId INTEGER,
        location TEXT,
        availabilityStatus TEXT,
        rating REAL,
        rentalCount INTEGER
      )
    ''');

    // Create government_schemes table
    await db.execute('''
      CREATE TABLE government_schemes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        schemeName TEXT,
        description TEXT,
        eligibilityCriteria TEXT,
        benefits TEXT,
        applicationProcess TEXT,
        deadline TEXT,
        category TEXT,
        isActive INTEGER
      )
    ''');

    // Create community_posts table
    await db.execute('''
      CREATE TABLE community_posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        content TEXT,
        category TEXT,
        likes INTEGER,
        comments INTEGER,
        shares INTEGER,
        createdAt TEXT,
        updatedAt TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create yield_data table
    await db.execute('''
      CREATE TABLE yield_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        cropName TEXT,
        fieldName TEXT,
        areaHectares REAL,
        plantingDate TEXT,
        harvestDate TEXT,
        yieldInQuintals REAL,
        yieldPerHectare REAL,
        season TEXT,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create organic_certifications table
    await db.execute('''
      CREATE TABLE organic_certifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        certificateNumber TEXT,
        certificationBody TEXT,
        issueDate TEXT,
        expiryDate TEXT,
        status TEXT,
        scope TEXT,
        documents TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create inventory_items table
    await db.execute('''
      CREATE TABLE inventory_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        itemName TEXT,
        category TEXT,
        quantity REAL,
        unit TEXT,
        purchaseDate TEXT,
        expiryDate TEXT,
        supplier TEXT,
        batchNumber TEXT,
        costPerUnit REAL,
        totalCost REAL,
        storageCondition TEXT,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create insurance_policies table
    await db.execute('''
      CREATE TABLE insurance_policies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        policyNumber TEXT,
        insurerName TEXT,
        coverageType TEXT,
        startDate TEXT,
        endDate TEXT,
        premiumAmount REAL,
        sumInsured REAL,
        status TEXT,
        claimHistory TEXT,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create supply_chain_records table
    await db.execute('''
      CREATE TABLE supply_chain_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT,
        productName TEXT,
        userId INTEGER,
        farmName TEXT,
        originLocation TEXT,
        harvestDate TEXT,
        quantity REAL,
        unit TEXT,
        qualityGrade TEXT,
        currentLocation TEXT,
        currentHandler TEXT,
        createdAt TEXT,
        status TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Create traceability_events table
    await db.execute('''
      CREATE TABLE traceability_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        supplyChainRecordId INTEGER,
        eventType TEXT,
        location TEXT,
        handler TEXT,
        eventDate TEXT,
        notes TEXT,
        metadata TEXT,
        FOREIGN KEY (supplyChainRecordId) REFERENCES supply_chain_records(id)
      )
    ''');
  }

  // User methods
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toJson());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Generic methods for other tables could be added here
  // For brevity, I'm showing examples for a few key tables

  // Soil data methods
  Future<int> insertSoilData(SoilData soilData) async {
    final db = await database;
    return await db.insert('soil_data', soilData.toJson());
  }

  Future<List<SoilData>> getSoilDataByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'soil_data',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return SoilData.fromJson(maps[i]);
    });
  }

  // Budget item methods
  Future<int> insertBudgetItem(BudgetItem budgetItem) async {
    final db = await database;
    return await db.insert('budget_items', budgetItem.toJson());
  }

  Future<List<BudgetItem>> getBudgetItemsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'budget_items',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return BudgetItem.fromJson(maps[i]);
    });
  }

  // Disease record methods
  Future<int> insertDiseaseRecord(DiseaseRecord record) async {
    final db = await database;
    return await db.insert('disease_records', record.toJson());
  }

  Future<List<DiseaseRecord>> getDiseaseRecordsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'disease_records',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return DiseaseRecord.fromJson(maps[i]);
    });
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}