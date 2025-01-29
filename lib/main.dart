import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // أضف هذا الاستيراد
import 'cus_man/add_delete.dart'; // استيراد صفحة إدارة العملاء
import 'cus_man/add_transaction.dart'; // استيراد صفحة إضافة عملية مالية
import 'cus_man/search.dart'; // استيراد صفحة البحث
import 'dily_cont/daily_account_page.dart'; // استيراد صفحة الحساب اليومي
import 'backjes.dart'; // استيراد صفحة الحساب اليومي

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // متغير لحالة السمة

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      locale: const Locale('ar', 'SA'), // تعيين اللغة العربية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // العربية
      ],
      home: Directionality(
        textDirection: TextDirection.rtl, // ضبط اتجاه النصوص
        child: HomePage(
          onThemeToggle: () {
            setState(() {
              isDarkMode = !isDarkMode; // تغيير حالة السمة
            });
          },
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  // مفتاح للتحكم في Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // تعيين المفتاح هنا
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'مذكرة الديون',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // فتح الـ Drawer
          },
        ),
        actions: const [
          Icon(
            Icons.monetization_on_outlined,
            size: 30,
            color: Color(0xFF76F77B),
          ),
          SizedBox(width: 28),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(
                            context); // إغلاق الـ Drawer عند الضغط على الزر
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'القائمة الجانبية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(
                isDarkMode ? 'الوضع الفاتح' : 'الوضع الداكن',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: onThemeToggle, // تغيير السمة دون إغلاق الشريط
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          children: [
            _buildIconCard(
              context,
              Icons.person,
              'إدارة الحسابات',
              Colors.blue,
            ),
            _buildIconCard(
              context,
              Icons.account_balance_wallet,
              'إضافة عملية مالية',
              Colors.orange,
            ),
            _buildIconCard(
              context,
              Icons.search,
              'البحث عن عميل',
              Colors.green,
            ),
            _buildIconCard(
              context,
              Icons.attach_money_sharp,
              'حسابي الشخصي',
              Colors.tealAccent,
            ),
            _buildIconCard(
              context,
              Icons.backup_outlined,
              'النسخ  والاستعاده',
              Colors.brown,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(
      BuildContext context, IconData icon, String label, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (label == 'إدارة الحسابات') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddDeletePage()),
            );
          } else if (label == 'إضافة عملية مالية') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddTransactionPage()),
            );
          } else if (label == 'البحث عن عميل') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchClientPage()),
            );
          } else if (label == 'حسابي الشخصي') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyAccountPage()),
            );
          } else if (label == 'النسخ  والاستعاده') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BackupRestorePage()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





/* import 'package:flutter/material.dart';
import 'cus_man/add_delete.dart'; // استيراد صفحة إدارة العملاء
import 'cus_man/add_transaction.dart'; // استيراد صفحة إضافة عملية مالية
import 'cus_man/search.dart'; // استيراد صفحة إضافة عملية مالية
import 'dily_cont/daily_account_page.dart'; // استيراد صفحة إضافة عملية مالية


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // متغير لحالة السمة

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Directionality(
        textDirection: TextDirection.rtl, // ضبط اتجاه النصوص
        child: HomePage(
          onThemeToggle: () {
            setState(() {
              isDarkMode = !isDarkMode; // تغيير حالة السمة
            });
          },
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  // مفتاح للتحكم في Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // تعيين المفتاح هنا
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'مذكرة الديون',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // فتح الـ Drawer
          },
        ),
        actions: const [
          Icon(
            Icons.monetization_on_outlined,
            size: 30,
            color: Color(0xFF76F77B),
          ),
          SizedBox(width: 28),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(
                            context); // إغلاق الـ Drawer عند الضغط على الزر
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'القائمة الجانبية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(
                isDarkMode ? 'الوضع الفاتح' : 'الوضع الداكن',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: onThemeToggle, // تغيير السمة دون إغلاق الشريط
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildIconCard(
              context,
              Icons.person,
              'إدارة العملاء',
              Colors.blue,
            ),
            _buildIconCard(
              context,
              Icons.account_balance_wallet,
              'إضافة عملية مالية',
              Colors.orange,
            ),
            _buildIconCard(
              context,
              Icons.search,
              'البحث عن عميل',
              Colors.green,
            ),
            _buildIconCard(
              context,
              Icons.help,
              'حسابي الشخصي',
              Colors.red,
            ),
            _buildIconCard(
              context,
              Icons.help,
              'المساعدة',
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(
      BuildContext context, IconData icon, String label, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (label == 'إدارة العملاء') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddDeletePage()),
            );
          } else if (label == 'إضافة عملية مالية') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddTransactionPage()),
            );
          } else if (label == 'البحث عن عميل') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchClientPage()),
            );
          }
          else if (label == 'حسابي الشخصي') {
          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DailyAccountPage()),
);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */

