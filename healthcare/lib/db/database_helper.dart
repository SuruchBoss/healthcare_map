import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Local on-device database replacing the Firebase/Firestore backend.
/// This app is a portfolio demo, so data lives only on the device and is
/// re-seeded with sample records the first time the database is created.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'healthcare.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        lastName TEXT NOT NULL,
        age INTEGER NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Clinics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        detail TEXT NOT NULL,
        phone TEXT NOT NULL,
        lat TEXT NOT NULL,
        lon TEXT NOT NULL,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clinicName TEXT NOT NULL,
        dateTime INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Promotions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        discountPercent INTEGER NOT NULL,
        clinicName TEXT NOT NULL,
        imageUrl TEXT NOT NULL
      )
    ''');

    await _seedDemoData(db);
  }

  Future<void> _seedDemoData(Database db) async {
    await db.insert('Customers', {
      'name': 'Admin',
      'lastName': 'Demo',
      'age': 30,
      'username': 'admin',
      'password': 'admin',
    });

    final clinicIds = <int>[];
    for (final clinic in _demoClinics) {
      clinicIds.add(await db.insert('Clinics', clinic));
    }

    final now = DateTime.now();
    final demoBookings = [
      {
        'clinicName': _demoClinics[0]['name'],
        'dateTime': DateTime(now.year, now.month, now.day, 10)
            .millisecondsSinceEpoch,
      },
      {
        'clinicName': _demoClinics[1]['name'],
        'dateTime': DateTime(now.year, now.month, now.day + 2, 14)
            .millisecondsSinceEpoch,
      },
    ];
    for (final booking in demoBookings) {
      await db.insert('Bookings', booking);
    }

    for (final promotion in _demoPromotions) {
      await db.insert('Promotions', promotion);
    }
  }

  static final List<Map<String, Object?>> _demoClinics = [
    {
      'name': 'Bangkok Wellness Clinic',
      'detail': 'General checkup and family medicine clinic in Bangkok.',
      'phone': '02-111-2222',
      'lat': '13.7563',
      'lon': '100.5018',
      'imageUrl': 'assets/clinic/clinic_1.png',
    },
    {
      'name': 'Sukhumvit Dental Care',
      'detail': 'Dental clinic offering checkups and cosmetic dentistry.',
      'phone': '02-222-3333',
      'lat': '13.7307',
      'lon': '100.5418',
      'imageUrl': 'assets/clinic/clinic_2.png',
    },
    {
      'name': 'Chatuchak Physio Center',
      'detail': 'Physiotherapy and rehabilitation clinic.',
      'phone': '02-333-4444',
      'lat': '13.7998',
      'lon': '100.5501',
      'imageUrl': 'assets/clinic/clinic_3.png',
    },
    {
      'name': 'Silom Eye Clinic',
      'detail': 'Eye examination and vision care clinic.',
      'phone': '02-444-5555',
      'lat': '13.7248',
      'lon': '100.5340',
      'imageUrl': 'assets/clinic/clinic_4.png',
    },
  ];

  static final List<Map<String, Object?>> _demoPromotions = [
    {
      'title': 'New Patient Special',
      'description': '20% off your first general checkup.',
      'discountPercent': 20,
      'clinicName': _demoClinics[0]['name'],
      'imageUrl': _demoClinics[0]['imageUrl'],
    },
    {
      'title': 'Bright Smile Package',
      'description': '15% off teeth cleaning and whitening.',
      'discountPercent': 15,
      'clinicName': _demoClinics[1]['name'],
      'imageUrl': _demoClinics[1]['imageUrl'],
    },
    {
      'title': 'Recovery Boost',
      'description': '10% off a 5-session physiotherapy package.',
      'discountPercent': 10,
      'clinicName': _demoClinics[2]['name'],
      'imageUrl': _demoClinics[2]['imageUrl'],
    },
  ];
}
