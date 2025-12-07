import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobile_computing_capstone/models/job.dart';
import 'package:mobile_computing_capstone/models/swipe.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('job_swiper.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incremented version for schema change
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop the saved_jobs table
      await db.execute('DROP TABLE IF EXISTS saved_jobs');
      // Add saved column to jobs table
      await db.execute(
        'ALTER TABLE jobs ADD COLUMN saved INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Create jobs table
    await db.execute('''
      CREATE TABLE jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        company TEXT NOT NULL,
        description TEXT NOT NULL,
        salary REAL,
        tags TEXT NOT NULL,
        apply_url TEXT NOT NULL,
        saved INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create swipes table
    await db.execute('''
      CREATE TABLE swipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        job_id INTEGER NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('like', 'dislike')),
        timestamp TEXT NOT NULL,
        FOREIGN KEY (job_id) REFERENCES jobs (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute(
      'CREATE INDEX idx_swipes_user_job ON swipes(user_id, job_id)',
    );
    await db.execute('CREATE INDEX idx_jobs_saved ON jobs(saved)');
  }

  // ==================== JOB OPERATIONS ====================

  Future<int> insertJob(Job job) async {
    final db = await database;
    return await db.insert('jobs', job.toMap());
  }

  Future<Job?> getJob(int id) async {
    final db = await database;
    final maps = await db.query('jobs', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Job.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Job>> getAllJobs() async {
    final db = await database;
    final maps = await db.query('jobs', orderBy: 'id DESC');
    return maps.map((map) => Job.fromMap(map)).toList();
  }

  Future<List<Job>> getUnswipedJobs(int userId) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT * FROM jobs
      WHERE id NOT IN (
        SELECT job_id FROM swipes WHERE user_id = ?
      )
      ORDER BY id DESC
    ''',
      [userId],
    );

    return maps.map((map) => Job.fromMap(map)).toList();
  }

  Future<int> updateJob(Job job) async {
    final db = await database;
    return await db.update(
      'jobs',
      job.toMap(),
      where: 'id = ?',
      whereArgs: [job.id],
    );
  }

  Future<int> deleteJob(int id) async {
    final db = await database;
    return await db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== SWIPE OPERATIONS ====================

  Future<int> insertSwipe(Swipe swipe) async {
    final db = await database;
    return await db.insert('swipes', swipe.toMap());
  }

  Future<Swipe?> getSwipe(int userId, int jobId) async {
    final db = await database;
    final maps = await db.query(
      'swipes',
      where: 'user_id = ? AND job_id = ?',
      whereArgs: [userId, jobId],
    );

    if (maps.isNotEmpty) {
      return Swipe.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Swipe>> getUserSwipes(int userId) async {
    final db = await database;
    final maps = await db.query(
      'swipes',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => Swipe.fromMap(map)).toList();
  }

  Future<List<Job>> getLikedJobs(int userId) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT j.* FROM jobs j
      INNER JOIN swipes s ON j.id = s.job_id
      WHERE s.user_id = ? AND s.type = 'like'
      ORDER BY s.timestamp DESC
    ''',
      [userId],
    );

    return maps.map((map) => Job.fromMap(map)).toList();
  }

  Future<int> deleteSwipe(int id) async {
    final db = await database;
    return await db.delete('swipes', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== SAVED JOB OPERATIONS ====================

  Future<int> toggleSaveJob(int jobId, bool saved) async {
    final db = await database;
    return await db.update(
      'jobs',
      {'saved': saved ? 1 : 0},
      where: 'id = ?',
      whereArgs: [jobId],
    );
  }

  Future<bool> isJobSaved(int jobId) async {
    final db = await database;
    final maps = await db.query(
      'jobs',
      columns: ['saved'],
      where: 'id = ?',
      whereArgs: [jobId],
    );
    if (maps.isEmpty) return false;
    return maps.first['saved'] == 1;
  }

  Future<List<Job>> getSavedJobs() async {
    final db = await database;
    final maps = await db.query(
      'jobs',
      where: 'saved = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );

    return maps.map((map) => Job.fromMap(map)).toList();
  }

  // ==================== UTILITY OPERATIONS ====================

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('swipes');
    await db.delete('jobs');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
