import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:intl/intl.dart'; // مكتبة للتعامل مع التاريخ

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

// ============================================
//           ادارة قاعدة البيانات
// ============================================
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
// حذف قاعدة البيانات إذا كانت موجودة (للتطوير فقط)
    // await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 5, // زيادة رقم الإصدار لأننا أضفنا جداول جديدة
      onCreate: _onCreate,
    );
  }

//  انشاء الجدوال
  Future<void> _onCreate(Database db, int version) async {
    // إنشاء جدول العملاء
    await db.execute('''
    CREATE TABLE customers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL
    )
  ''');

    // إنشاء جدول العمليات للعملاء
    await db.execute('''
    CREATE TABLE operations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      client_id INTEGER NOT NULL,
      amount REAL,
      details TEXT,
      type TEXT,
      date TEXT,
      FOREIGN KEY (client_id) REFERENCES customers (id)
    )
  ''');

    // إنشاء جدول الحساب اليومي
    await db.execute('''
    CREATE TABLE daily_account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL NOT NULL,
      details TEXT NOT NULL,
      type TEXT NOT NULL,
      date TEXT NOT NULL
    )
  ''');

    // إنشاء جدول الوكلاء
    await db.execute('''
    CREATE TABLE agents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL
    )
  ''');

    // إنشاء جدول عمليات الوكلاء
    await db.execute('''
    CREATE TABLE agent_operations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      agent_id INTEGER NOT NULL,
      amount REAL,
      details TEXT,
      type TEXT,
      date TEXT,
      FOREIGN KEY (agent_id) REFERENCES agents (id)
    )
  ''');
  }

  // دالة للتحقق من وجود جدول
  Future<bool> doesTableExist(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return result.isNotEmpty;
  }

// ================================================================
//               ادارة العملاء والتجار
// ================================================================

  // إضافة عميل جديد
  Future<int> insertCustomer(String name, String phone) async {
    final db = await database;

    // إزالة الفراغات من بداية ونهاية الاسم
    String trimmedName = name.trim();

    return await db.insert('customers', {'name': trimmedName, 'phone': phone});
  }

  // استرجاع جميع العملاء
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await database;
    return await db.query('customers');
  }

  // تحديث بيانات عميل
  Future<int> updateCustomer(int id, String name, String phone) async {
    final db = await database;
    String trimmedName = name.trim();

    return await db.update(
      'customers',
      {'name': trimmedName, 'phone': phone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // حذف عميل
  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

/* 
  Future<Map<String, double>> getTotalSummary() async {
    final db = await database;

    // استعلام للحصول على إجمالي المبالغ التي نوعها "إضافة" لجميع العملاء
    final additionsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalAdditions
    FROM operations o
    WHERE o.type = "إضافة"
    ''',
    );

    // استعلام للحصول على إجمالي المبالغ التي نوعها "تسديد" لجميع العملاء
    final paymentsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalPayments
    FROM operations o
    WHERE o.type = "تسديد"
    ''',
    );

    // استخراج القيم من النتائج
    final totalAdditions =
        additionsResult.first['totalAdditions'] as double? ?? 0.0;
    final totalPayments =
        paymentsResult.first['totalPayments'] as double? ?? 0.0;

    // حساب المبلغ المستحق الكلي
    final totalOutstanding = totalAdditions - totalPayments;

    return {
      'totalAdditions': totalAdditions,
      'totalPayments': totalPayments,
      'totalOutstanding': totalOutstanding,
    };
  }
 */
  Future<Map<String, dynamic>> getTotalSummary() async {
    final db = await database;

    // استعلام للحصول على إجمالي المبالغ التي نوعها "إضافة" لجميع العملاء
    final additionsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalAdditions
    FROM operations o
    WHERE o.type = "إضافة"
    ''',
    );

    // استعلام للحصول على إجمالي المبالغ التي نوعها "تسديد" لجميع العملاء
    final paymentsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalPayments
    FROM operations o
    WHERE o.type = "تسديد"
    ''',
    );

    // استعلام للحصول على عدد العملاء
    final customersCountResult = await db.rawQuery(
      '''
    SELECT COUNT(*) as totalCustomers
    FROM customers
    ''',
    );

    // استخراج القيم من النتائج
    final totalAdditions =
        additionsResult.first['totalAdditions'] as double? ?? 0.0;
    final totalPayments =
        paymentsResult.first['totalPayments'] as double? ?? 0.0;
    final totalCustomers =
        customersCountResult.first['totalCustomers'] as int? ?? 0;

    // حساب المبلغ المستحق الكلي
    final totalOutstanding = totalAdditions - totalPayments;

    return {
      'totalAdditions': totalAdditions,
      'totalPayments': totalPayments,
      'totalOutstanding': totalOutstanding,
      'totalCustomers': totalCustomers,
    };
  }

// إضافة وكيل جديد
  Future<int> insertAgent(String name, String phone) async {
    final db = await database;

    // إزالة الفراغات من بداية ونهاية الاسم
    String trimmedName = name.trim();

    return await db.insert('agents', {'name': trimmedName, 'phone': phone});
  }

  // استرجاع جميع الوكلاء
  Future<List<Map<String, dynamic>>> getAllAgents() async {
    final db = await database;
    return await db.query('agents');
  }

  // حذف وكيل
  Future<int> deleteAgent(int id) async {
    final db = await database;
    return await db.delete('agents', where: 'id = ?', whereArgs: [id]);
  }

  // تعديل وكيل
  Future<int> updateAgent(int id, String name, String phone) async {
    final db = await database;
    return await db.update(
      'agents',
      {'name': name, 'phone': phone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

/* ===============================================
   ============== اضافة عملية====================
   ===============================================*/

/* ==================================
   ============== العملاء ============
   ==================================*/
  //==========  التحقق من وجود العميل=========
  Future<bool> doesClientExist(String name) async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

//  =============  بحث الاسماء المطابقة لما يكتب في الحقل ==============
  Future<List<String>> getClientNames(String query) async {
    final db = await database;

    // البحث عن الأسماء التي تحتوي على النص المدخل
    final result = await db.rawQuery(
      "SELECT name FROM customers WHERE name LIKE ?",
      ['%$query%'],
    );

    // تحويل النتائج إلى قائمة من النصوص
    return result.map((row) => row['name'].toString()).toList();
  }

// =============== ارجاع الاسماء المطابقه للعملاء=============
  Future<List<Map<String, dynamic>>> searchClientsByName(String query) async {
    final db = await database;
    return await db.query(
      'customers',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      limit: 10, // تحديد عدد النتائج
    );
  }

// ============   اضافة عمليه لعميل ===========
  Future<void> insertOperation(
      int clientId, double amount, String details, String type) async {
    final db = await database;
    String creetDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    await db.insert('operations', {
      'client_id': clientId, // حفظ ID العميل
      'amount': amount,
      'details': details,
      'type': type,
      'date': creetDate,
    });
  }

// ===============ارجاع العمليات وعرضها للعملاء======================
  Future<List<Map<String, dynamic>>> getOperationsByDate(DateTime date) async {
    final db = await database;
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return await db.rawQuery('''
    SELECT 
      operations.id AS operation_id, 
      operations.client_id, 
      operations.amount, 
      operations.details, 
      operations.type, 
      operations.date,
      customers.name AS client_name
    FROM operations
    LEFT JOIN customers ON operations.client_id = customers.id
    WHERE DATE(operations.date) = ?
    ORDER BY operations.id DESC
  ''', [formattedDate]);
  }

// ===================حذف عملية لعميل ==================
  Future<int> deleteOperation(int operationId) async {
    final db = await database;
    return await db.delete(
      'operations',
      where: 'id = ?',
      whereArgs: [operationId],
    );
  }

// ===================تعديل  عملية  لعميل==================
  Future<int> updateOperation(
      int id, double amount, String details, String type) async {
    final db = await database;
    return await db.update(
      'operations',
      {
        'amount': amount,
        'details': details,
        'type': type,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//===========  ملخص العمليات للعملاء =========
  Future<Map<String, double>> getSummaryByDate(DateTime date) async {
    final db = await database;
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    // جلب إجمالي التسديدات
    final totalPaymentsResult = await db.rawQuery('''
    SELECT SUM(amount) AS total_payments
    FROM operations
    WHERE DATE(date) = ? AND type = 'تسديد'
  ''', [formattedDate]);

    // جلب إجمالي الإضافات
    final totalAdditionsResult = await db.rawQuery('''
    SELECT SUM(amount) AS total_additions
    FROM operations
    WHERE DATE(date) = ? AND type = 'إضافة'
  ''', [formattedDate]);

    // تحويل القيم إلى double مع التعامل مع القيم الفارغة
    final double totalPayments =
        (totalPaymentsResult.first['total_payments'] as num?)?.toDouble() ??
            0.0;
    final double totalAdditions =
        (totalAdditionsResult.first['total_additions'] as num?)?.toDouble() ??
            0.0;

    return {
      'total_payments': totalPayments,
      'total_additions': totalAdditions,
      'balance': totalPayments - totalAdditions,
    };
  }

/* ==================================
   ============== الوكلاء ============
   ==================================*/
// ============ البحث عن أسماء الوكلاء المتطابقة ==============
  Future<List<String>> getAgentNames(String query) async {
    final db = await database;

    // البحث عن الأسماء التي تحتوي على النص المدخل
    final result = await db.rawQuery(
      "SELECT name FROM agents WHERE name LIKE ?",
      ['%$query%'],
    );

    // تحويل النتائج إلى قائمة من النصوص
    return result.map((row) => row['name'].toString()).toList();
  }

// ============ إرجاع أسماء الوكلاء المتطابقة ===============
  Future<List<Map<String, dynamic>>> searchAgentsByName(String query) async {
    final db = await database;
    return await db.query(
      'agents',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      limit: 10, // تحديد عدد النتائج
    );
  }

// ============ إضافة عملية لوكيل ===============
  Future<void> insertAgentOperation(
      int agentId, double amount, String details, String type) async {
    final db = await database;
    String currentDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    await db.insert('agent_operations', {
      'agent_id': agentId, // حفظ ID الوكيل
      'amount': amount,
      'details': details,
      'type': type,
      'date': currentDate,
    });
  }

// ===============ارجاع العمليات وعرضها للوكلاء======================
  Future<List<Map<String, dynamic>>> getAgentOperationsByDate(
      DateTime date) async {
    final db = await database;
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return await db.rawQuery('''
  SELECT 
    agent_operations.id AS operation_id, 
    agent_operations.agent_id, 
    agent_operations.amount, 
    agent_operations.details, 
    agent_operations.type, 
    agent_operations.date,
    agents.name AS agent_name
  FROM agent_operations
  LEFT JOIN agents ON agent_operations.agent_id = agents.id
  WHERE DATE(agent_operations.date) = ?
  ORDER BY agent_operations.id DESC
  ''', [formattedDate]);
  }

// ===================حذف عملية لوكيل ==================
  Future<int> deleteAgentOperation(int operationId) async {
    final db = await database;
    return await db.delete(
      'agent_operations',
      where: 'id = ?',
      whereArgs: [operationId],
    );
  }

// ===================تعديل  عملية  لوكيل==================
  Future<int> updateAgentOperation(
      int id, double amount, String details, String type) async {
    final db = await database;

    // تحديث البيانات
    return await db.update(
      'agent_operations',
      {
        'amount': amount,
        'details': details,
        'type': type,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//===========  ملخص العمليات للوكلاء =========
  Future<Map<String, double>> getAgentSummaryByDate(DateTime date) async {
    final db = await database;
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    // جلب إجمالي التسديدات
    final totalPaymentsResult = await db.rawQuery('''
  SELECT SUM(amount) AS total_payments
  FROM agent_operations
  WHERE DATE(date) = ? AND type = 'تسديد'
  ''', [formattedDate]);

    // جلب إجمالي الإضافات
    final totalAdditionsResult = await db.rawQuery('''
  SELECT SUM(amount) AS total_additions
  FROM agent_operations
  WHERE DATE(date) = ? AND type = 'قرض'
  ''', [formattedDate]);

    // تحويل القيم إلى double مع التعامل مع القيم الفارغة
    final double totalPayments =
        (totalPaymentsResult.first['total_payments'] as num?)?.toDouble() ??
            0.0;
    final double totalAdditions =
        (totalAdditionsResult.first['total_additions'] as num?)?.toDouble() ??
            0.0;

    return {
      'total_payments': totalPayments,
      'total_additions': totalAdditions,
      'balance': totalPayments - totalAdditions,
    };
  }

/* ===============================================
   ============== بحث عن كشف عميل ===============
   ===============================================*/

  //  ============= بحث عن عميل ===============
  Future<List<Map<String, dynamic>>> getOperationsByClientName(
      String name) async {
    final db = await database;

    // استعلام لاسترجاع العمليات المرتبطة باسم العميل المدخل
    return await db.rawQuery('''
    SELECT 
      operations.id AS operation_id, 
      operations.amount, 
      operations.details, 
      operations.type, 
      operations.date, 
      customers.name AS client_name
    FROM operations
    INNER JOIN customers ON operations.client_id = customers.id
    WHERE customers.name = ?
    ORDER BY operations.date DESC
  ''', [name]);
  }

// ============== ملخص عمليات العميل ===========
  Future<Map<String, dynamic>> getSummaryByName(String name) async {
    final db = await database;

    // استعلام للحصول على إجمالي المبالغ التي نوعها "إضافة"
    final additionsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalAdditions
    FROM operations o
    INNER JOIN customers c ON o.client_id = c.id
    WHERE c.name = ? AND o.type = "إضافة"
    ''',
      [name],
    );

    // استعلام للحصول على إجمالي المبالغ التي نوعها "تسديد"
    final paymentsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalPayments
    FROM operations o
    INNER JOIN customers c ON o.client_id = c.id
    WHERE c.name = ? AND o.type = "تسديد"
    ''',
      [name],
    );

    // استخراج القيم من النتائج
    final totalAdditions = additionsResult.first['totalAdditions'] ?? 0.0;
    final totalPayments = paymentsResult.first['totalPayments'] ?? 0.0;

    // حساب المبلغ المستحق
    final outstanding = (totalAdditions as double) - (totalPayments as double);

    return {
      'totalAdditions': totalAdditions,
      'totalPayments': totalPayments,
      'outstanding': outstanding,
    };
  }

// ============== ملخص عمليات العميل ===========
  Future<Map<String, dynamic>> getSummaryAgeentByName(String name) async {
    final db = await database;

    // استعلام للحصول على إجمالي المبالغ التي نوعها "إضافة"
    final additionsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalAdditions
    FROM agent_operations o
    INNER JOIN agents c ON o.agent_id = c.id
    WHERE c.name = ? AND o.type = "قرض"
    ''',
      [name],
    );

    // استعلام للحصول على إجمالي المبالغ التي نوعها "تسديد"
    final paymentsResult = await db.rawQuery(
      '''
    SELECT SUM(o.amount) as totalPayments
    FROM agent_operations o
    INNER JOIN agents c ON o.agent_id = c.id
    WHERE c.name = ? AND o.type = "تسديد"
    ''',
      [name],
    );

    // استخراج القيم من النتائج
    final totalAdditions = additionsResult.first['totalAdditions'] ?? 0.0;
    final totalPayments = paymentsResult.first['totalPayments'] ?? 0.0;

    // حساب المبلغ المستحق
    final outstanding = (totalAdditions as double) - (totalPayments as double);

    return {
      'totalAdditions': totalAdditions,
      'totalPayments': totalPayments,
      'outstanding': outstanding,
    };
  }

//========= دالة لتوليد التاريخ  لطباعة الكشف =======
  String getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy/MM/dd'); // تنسيق التاريخ
    return formatter.format(now);
  }

/* ===============================================
   ============== الحساب الشخصي  ===============
   ===============================================*/
  // دالة لإضافة عملية جديدة
  Future<void> insertDailyTransaction(
      double amount, String details, String type) async {
    final db = await database;
    final date =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()); // تنسيق التاريخ

    await db.insert(
      'daily_account',
      {
        'amount': amount,
        'details': details,
        'type': type,
        'date': date,
      },
    );
  }

//=============== استرجاع العمليات ===================
  Future<List<Map<String, dynamic>>> getDailyTransactions() async {
    final db = await database;
    return await db.query('daily_account',
        orderBy: 'date DESC'); // ترتيب العمليات حسب التاريخ
  }

//=============== حذف عملية ===================
  Future<int> deleteDailyTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'daily_account',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//=============== تعديل  عملية ===================
  Future<int> updateDailyTransaction(
      int id, double amount, String details, String type) async {
    final db = await database;

    return await db.update(
      'daily_account',
      {
        'amount': amount,
        'details': details,
        'type': type,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

/* ===============================================
   ============== النسخ الاحتياطي  ===============
   ===============================================*/

  Future<File> exportDatabase() async {
    final db = await database;
    final dbPath = await getDatabasesPath();
    final dbFile = File(join(dbPath, 'app_database.db'));

    // الحصول على مسار الذاكرة الخارجية
    final directory = Directory('/storage/emulated/0/Documents');
    if (!await directory.exists()) {
      throw Exception('لا يمكن الوصول إلى مجلد Documents');
    }

    // إنشاء مجلد "MritPro" داخل مجلد "Documents" إذا لم يكن موجودًا
    final mritProDir = Directory('${directory.path}/MritPro');
    if (!await mritProDir.exists()) {
      await mritProDir.create(recursive: true);
    }

    // نسخ قاعدة البيانات إلى مجلد MritPro
    final backupFile = File(
        '${mritProDir.path}/app_database_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.db');
    await dbFile.copy(backupFile.path);

    return backupFile;
  }

  // استيراد قاعدة البيانات من ملف
  Future<void> importDatabase(File backupFile) async {
    final dbPath = await getDatabasesPath();
    final dbFile = File(join(dbPath, 'app_database.db'));

    // نسخ الملف الاحتياطي إلى موقع قاعدة البيانات
    await backupFile.copy(dbFile.path);

    // إعادة تهيئة قاعدة البيانات
    _database = await _initDatabase();
  }

  // الحصول على قائمة بجميع ملفات النسخ الاحتياطي
  Future<List<File>> getBackupFiles() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('لا يمكن الوصول إلى مسار التخزين الخارجي');
    }

    final backupDir = Directory('${directory.path}/Backups');
    if (!await backupDir.exists()) {
      return [];
    }

    final files = backupDir.listSync().whereType<File>().toList();
    return files;
  }

// ================================================
}
