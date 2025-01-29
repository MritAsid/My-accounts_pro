import 'package:flutter/material.dart';
import '../database/database_helper.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

class DailyAccountPage extends StatefulWidget {
  const DailyAccountPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DailyAccountPageState createState() => _DailyAccountPageState();
}

class _DailyAccountPageState extends State<DailyAccountPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _transactions = [];
  DateTime _selectedDate = DateTime.now(); // التاريخ المحدد

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // تحميل عمليات اليوم الحالي
  }

  // دالة لتحميل العمليات من قاعدة البيانات
  Future<void> _loadTransactions() async {
    final transactions = await _dbHelper.getDailyTransactions();
    final today = DateTime.now();
    final filteredTransactions = transactions.where((transaction) {
      final transactionDate = DateTime.parse(transaction['date']);
      return transactionDate.year == today.year &&
          transactionDate.month == today.month &&
          transactionDate.day == today.day;
    }).toList();

    setState(() {
      _transactions = filteredTransactions;
    });
  }

  // دالة لحذف عملية
  Future<void> _deleteTransaction(int id) async {
    await _dbHelper.deleteDailyTransaction(id);
    _loadTransactions(); // إعادة تحميل العمليات بعد الحذف
  }

  // دالة لعرض تفاصيل العملية في نافذة منبثقة
  void _showTransactionDetails(Map<String, dynamic> transaction) {
    // تحويل النص في صف التاريخ إلى كائن DateTime
    final DateTime parsedDate = DateTime.parse(transaction['date']);

    // استخراج التاريخ بصيغة يوم/شهر/سنة
    final String formattedDate =
        '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';

    // استخراج الوقت بصيغة ساعات ودقائق
    final String formattedTime =
        '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            // title: const Text('تفاصيل العملية'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // العنوان
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'تفاصيل العملية',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3.0), // الكلمات التعريفية 20%
                        1: FlexColumnWidth(7.0), // البيانات 80%
                      },
                      border: TableBorder.all(color: Colors.cyan, width: 3),
                      children: [
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'التاريخ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              // child: Text(transaction['date']),
                              child: Text(
                                formattedDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'الساعة',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              // child: Text(transaction['date']),
                              child: Text(
                                formattedTime,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'تفاصيل',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                transaction['details'],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'المبلغ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                transaction['amount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: transaction['type'] == 'صرف'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        /* 
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'النوع',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                transaction['type'],
                                style: TextStyle(
                                  color: transaction['type'] == 'صرف'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      */
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // تنفيذ عملية الحذف
                          _deleteTransaction(transaction['id']);
                          Navigator.pop(context); // إغلاق النافذة
                        },
                        child: const Text('حذف'),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // تنفيذ عملية التعديل
                      //     // يمكنك إضافة الكود الخاص بالتعديل هنا
                      //     Navigator.pop(context); // إغلاق النافذة
                      //   },
                      //   child: const Text('تعديل'),
                      // ),

                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // إغلاق النافذة

                          final result = await showDialog(
                            context: context,
                            builder: (context) => EditTransactionDialog(
                              transaction:
                                  transaction, // تمرير بيانات العملية الحالية
                            ),
                          );

                          if (result != null && result) {
                            _loadTransactions(); // إعادة تحميل العمليات بعد التعديل
                          }
                        },
                        child: const Text('تعديل'),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق النافذة
                    },
                    child: const Text('إلغاء'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// دالة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('ar', 'SA'), // تعيين اللغة العربية
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.cyan, // لون الخلفية
              onPrimary: Colors.white, // لون النص
              surface: Colors.white, // لون الخلفية العامة
              onSurface: Colors.black, // لون النص العام
            ),
            dialogBackgroundColor: Colors.white, // لون خلفية النافذة
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _filterTransactionsByDate(picked);
    }
  }

  // دالة لتصفية العمليات حسب التاريخ
  Future<void> _filterTransactionsByDate(DateTime date) async {
    final transactions = await _dbHelper.getDailyTransactions();
    final filteredTransactions = transactions.where((transaction) {
      final transactionDate = DateTime.parse(transaction['date']);
      return transactionDate.year == date.year &&
          transactionDate.month == date.month &&
          transactionDate.day == date.day;
    }).toList();

    if (filteredTransactions.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يوجد عمليات لليوم المحدد'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _transactions = filteredTransactions;
    });
  }

  // دالة لعرض ملخص العمليات
  void _showSummary() {
    // حساب مجموع الكسب
    final totalIncome = _transactions
        .where((transaction) => transaction['type'] == 'كسب')
        .fold(0.0, (sum, transaction) => sum + transaction['amount']);

    // حساب مجموع الصرف
    final totalExpense = _transactions
        .where((transaction) => transaction['type'] == 'صرف')
        .fold(0.0, (sum, transaction) => sum + transaction['amount']);

    // حساب الربح
    final profit = totalIncome - totalExpense;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFEEEBEB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'ملخص عمليات',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10.0),

                Container(
                  alignment: AlignmentDirectional.center,
                  transformAlignment: AlignmentDirectional.center,
                  padding: EdgeInsets.all(6.0),
                  width: 120.0,
                  color: Colors.cyan,
                  child: Center(
                    child: Text(
                      ' ${_selectedDate.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(7.0), // الكلمات التعريفية 20%
                      1: FlexColumnWidth(3.0), // البيانات 80%
                    },
                    border: TableBorder.all(
                      color: Colors.cyan,
                      width: 3,
                    ),
                    children: [
                      // TableRow(
                      //   children: [
                      //     const Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: Text(
                      //         'الكلمات التعريفية',
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     const Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: Text(
                      //         'البيانات',
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              totalIncome.toString(),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'الكسب',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              totalExpense.toString(),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'الصرف',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              profit.toString(),
                              style: TextStyle(
                                color: profit >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'الربح',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // زر الإغلاق
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

/*         
         Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.cyan, // خلفية زرقاء
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'ملخص عمليات',
                style: TextStyle(
                  color: Colors.white, // نص أبيض
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ' ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Table(
                          columnWidths: const {
                          0: FlexColumnWidth(3.0), // الكلمات التعريفية 20%
                          1: FlexColumnWidth(7.0), // البيانات 80%
                        },
                    border: TableBorder.all(color: Colors.cyan, width: 3,),
                    children: [
                      // TableRow(
                      //   children: [
                      //     const Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: Text(
                      //         'الكلمات التعريفية',
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     const Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: Text(
                      //         'البيانات',
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('الكسب', 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                            totalIncome.toString(),
                             style: TextStyle(color: Colors.green,fontWeight:FontWeight.w800),
                            textAlign: TextAlign.center,

                             ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('الصرف',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(totalExpense.toString(),
                             style: TextStyle(color: Colors.red,fontWeight:FontWeight.w800),
                            textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('الربح',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              profit.toString(),
                              style: TextStyle(
                                color: profit >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            textAlign: TextAlign.center,

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
               
               
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // إغلاق النافذة
                },
                child: Center(
                  child: const Text('إغلاق'),
                ),
                
                 
              ),
            ],
          ),
        );
      
     */
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEBEB),

        resizeToAvoidBottomInset: false, // إصلاح المشكلة عند ظهور لوحة المفاتيح

        // resizeToAvoidBottomInset: false, // إصلاح المشكلة عند ظهور لوحة المفاتيح
        appBar: AppBar(
          title: const Text(
            'حسابي الشخصي اليومي',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22.0),
          ),
          backgroundColor: Colors.cyan,
          leading: IconButton(
            icon: const Icon(Icons.home_outlined, size: 35),
            onPressed: () {
              Navigator.pop(context); // العودة إلى الصفحة الرئيسية
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              const SizedBox(height: 4.0),
              Container(
                // padding: const EdgeInsets.all(2),
                width: 200,
                height: 46,
                alignment: AlignmentDirectional.center,
                // margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.cyan, width: 3),

                  // border: Border(
                  // bottom: BorderSide(width: 3, color: Colors.cyan),
                  // top: BorderSide(width: 2, color: Colors.cyan),
                  // ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.date_range,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      onPressed: () => _selectDate(context),
                    ),
                    Text(
                      ' ${_selectedDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(
                          // fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(6, 10, 6, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.cyan,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 7, // نسبة 70%
                              child: Text(
                                'التفاصيل',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2, // نسبة 30%
                              child: Text(
                                'معلومات',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _transactions[index];

                            // تحديد لون الأيقونة حسب نوع العملية
                            Color iconColor;
                            if (transaction['type'] == 'صرف') {
                              iconColor = Colors.red; // لون أحمر للإضافة
                            } else if (transaction['type'] == 'كسب') {
                              iconColor = Colors.green; // لون أخضر للتسديد
                            } else {
                              iconColor = Colors.blue; // لون افتراضي
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? const Color(0xFFF1F1F1)
                                    : Colors.white,
                                border: const Border(
                                  bottom: BorderSide(
                                      color: Colors.cyan, width: 2.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // عمود التفاصيل
                                  Expanded(
                                    flex: 7, // نسبة 70%
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              color: Colors.cyan, width: 2.0),
                                          right: BorderSide(
                                              color: Colors.cyan, width: 2.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 2,
                                        ),
                                        child: Text(
                                          transaction['details'],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // عمود معلومات
                                  Expanded(
                                    flex: 2, // نسبة 30%
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.info,
                                        color:
                                            iconColor, // اللون يعتمد على نوع العملية
                                      ),
                                      onPressed: () {
                                        _showTransactionDetails(transaction);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0x8300BBD4),
                  border: Border(top: BorderSide(width: 3, color: Colors.cyan)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.search_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.cyan,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add,
                            size: 30, color: Colors.white),
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) => const AddTransactionDialog(),
                          );

                          if (result != null && result) {
                            _loadTransactions(); // إعادة تحميل العمليات بعد الإضافة
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: _showSummary, // عرض ملخص العمليات
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ========================================
}

// نافذة إضافة عملية جديدة
class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({Key? key}) : super(key: key);

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _detailsController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _detailsFocusNode = FocusNode();
  String? _selectedType; // إزالة القيمة الافتراضية

  @override
  void initState() {
    super.initState();
    _amountFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _detailsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: const Color(0xFFF6F6F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'إضافة عملية جديدة',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.cyan,
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _amountController,
                          focusNode: _amountFocusNode,
                          decoration: const InputDecoration(
                            labelText: 'المبلغ',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _detailsFocusNode.requestFocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال المبلغ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _detailsController,
                          focusNode: _detailsFocusNode,
                          decoration: const InputDecoration(
                            labelText: 'التفاصيل',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال التفاصيل';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // الحد العلوي بعرض 3 بكسل
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.cyan,
                ),

                const SizedBox(height: 10.0),

                // اختيار نوع العملية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // خيار "صرف"
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = 'صرف';
                          _amountFocusNode.unfocus();
                          _detailsFocusNode.unfocus();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _selectedType == 'صرف'
                              ? Colors.red
                              : Colors.white,
                          border: Border.all(
                            color: const Color(0xFFFF665B),
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'صرف',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                              color: _selectedType == 'صرف'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // خيار "كسب"
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = 'كسب';
                          _amountFocusNode.unfocus();
                          _detailsFocusNode.unfocus();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _selectedType == 'كسب'
                              ? Colors.green
                              : Colors.white,
                          border: Border.all(
                            color: const Color(0xFF70FF75),
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'كسب',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                              color: _selectedType == 'كسب'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                // الحد العلوي بعرض 3 بكسل
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.cyan,
                ),

                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: // أزرار الحفظ والإلغاء
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final amount =
                                double.tryParse(_amountController.text) ?? 0.0;
                            final details = _detailsController.text;
                            final type = _selectedType;

                            if (type == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('يرجى اختيار نوع العملية'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }

                            final dbHelper = DatabaseHelper();
                            await dbHelper.insertDailyTransaction(
                                amount, details, type);

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true); // حفظ وإغلاق النافذة
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم حفظ العملية بنجاح'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          // ignore: deprecated_member_use
                          primary: Colors.cyan,
                          // ignore: deprecated_member_use
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'حفظ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          // ignore: deprecated_member_use
                          primary: Color(0xFFF6F6F6),
                          // ignore: deprecated_member_use
                          onPrimary: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// نافذة تعديل العملية
class EditTransactionDialog extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const EditTransactionDialog({Key? key, required this.transaction})
      : super(key: key);

  @override
  _EditTransactionDialogState createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _detailsController = TextEditingController();
  String _selectedType = 'كسب';

  @override
  void initState() {
    super.initState();
    // تعبئة الحقول ببيانات العملية الحالية
    _amountController.text = widget.transaction['amount'].toString();
    _detailsController.text = widget.transaction['details'];
    _selectedType = widget.transaction['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: const Color(0xFFF6F6F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'تعديل العملية',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.cyan,
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'المبلغ',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال المبلغ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _detailsController,
                          decoration: const InputDecoration(
                            labelText: 'التفاصيل',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2.0),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال التفاصيل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),

                        // اختيار نوع العملية (صرف/كسب)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // خيار "صرف"
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedType = 'صرف';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: _selectedType == 'صرف'
                                      ? Colors.red
                                      : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFFF665B),
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'صرف',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      color: _selectedType == 'صرف'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // خيار "كسب"
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedType = 'كسب';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: _selectedType == 'كسب'
                                      ? Colors.green
                                      : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF70FF75),
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'كسب',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      color: _selectedType == 'كسب'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // الحد العلوي بعرض 3 بكسل
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.cyan,
                ),

                // const SizedBox(height: 10.0),

                // أزرار الحفظ والإلغاء
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final amount =
                                double.tryParse(_amountController.text) ?? 0.0;
                            final details = _detailsController.text;
                            final type = _selectedType;

                            final dbHelper = DatabaseHelper();
                            await dbHelper.updateDailyTransaction(
                              widget.transaction['id'], // معرف العملية
                              amount,
                              details,
                              type,
                            );

                            Navigator.pop(context, true); // حفظ وإغلاق النافذة
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم تعديل العملية بنجاح'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'حفظ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF6F6F6),
                          onPrimary: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// ====================================
