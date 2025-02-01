// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_transaction.dart';
import 'search.dart';
import '../main.dart';

class AddDeletePage extends StatefulWidget {
  const AddDeletePage({super.key});

  @override
  State<AddDeletePage> createState() => _AddDeletePageState();
}

class _AddDeletePageState extends State<AddDeletePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _agents = [];
  bool _showCustomersTable = true; // متغير للتبديل بين الجداول
  bool _showSearchField = false; // للتحكم في إظهار حقل البحث
  String _searchQuery = ''; // لتخزين نص البحث
  // final FocusNode _searchFocusNode = FocusNode(); // للتحكم في تركيز حقل البحث

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadAgents();

    _nameFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus) {
        _nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _nameController.text.length),
        );
      }
    });
  }

  void _loadCustomers() async {
    final data = await _dbHelper.getAllCustomers();

    setState(() {
      _customers = data;
    });
  }

  void _loadAgents() async {
    final data = await _dbHelper.getAllAgents();
    setState(() {
      _agents = data;
    });
  }

  void _toggleTable(bool showCustomers) {
    setState(() {
      _showCustomersTable = showCustomers;
    });
  }

// =======================================================
  void _showAddAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: const Color(0xFFF6F6F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'إضافة حساب جديد',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddCustomerDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyan,
                        onPrimary: Colors.white,
                      ),
                      child: const Text('عميل'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddAgentDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      child: const Text('وكيل'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: const Color(0xFFF6F6F6),
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'إضافة عميل',
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
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'الاسم',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.blue,
                ),
                Container(
                  decoration: const BoxDecoration(
                    // color: Colors.white,
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
                        onPressed: _saveCustomer,
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
                          primary: const Color(0xFFF6F6F6),
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
    ).then((_) {
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length),
      );
    });
  }

  void _showAddAgentDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: const Color(0xFFF6F6F6),
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
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'إضافة وكيل',
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
                  color: Colors.orange,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'الاسم',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 2.0),
                          ),
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 2.0),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.orange,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _saveAgent,
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
                          primary: const Color(0xFFF6F6F6),
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
    ).then((_) {
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length),
      );
    });
  }

  void _saveCustomer() async {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      await _dbHelper.insertCustomer(
        _nameController.text,
        _phoneController.text,
      );
      _nameController.clear();
      _phoneController.clear();
      _showSuccessMessage('تم حفظ العميل بنجاح');
      _loadCustomers();
    } else {
      _showErrorMessage('يرجى إدخال جميع البيانات');
    }
    Navigator.pop(context);
  }

  void _saveAgent() async {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      await _dbHelper.insertAgent(
        _nameController.text,
        _phoneController.text,
      );
      _nameController.clear();
      _phoneController.clear();
      _showSuccessMessage('تم حفظ الوكيل بنجاح');
      _loadAgents();
    } else {
      _showErrorMessage('يرجى إدخال جميع البيانات');
    }
    Navigator.pop(context);
  }

// ==============================================================
/* 
  void _showTotalSummaryDialog() async {
    // استدعاء الدالة للحصول على النتائج
    final summary = await _dbHelper.getTotalSummary();

    // عرض النافذة المنبثقة
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'ملخص العمليات الكلي',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow('إجمالي الإضافات', summary['totalAdditions']!),
              const SizedBox(height: 10),
              _buildSummaryRow('إجمالي التسديدات', summary['totalPayments']!),
              const SizedBox(height: 10),
              _buildSummaryRow(
                  'المبلغ المستحق الكلي', summary['totalOutstanding']!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق النافذة
              },
              child: const Text(
                'إغلاق',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
 */
  void _showTotalSummaryDialog() async {
    // استدعاء الدالة للحصول على النتائج
    final summary = await _dbHelper.getTotalSummary();

    // عرض النافذة المنبثقة
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'ملخص العمليات الكلي',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow(
                  'عدد العملاء', summary['totalCustomers']!.toDouble()),
              const SizedBox(height: 10),
              _buildSummaryRow('إجمالي الإضافات', summary['totalAdditions']!),
              const SizedBox(height: 10),
              _buildSummaryRow('إجمالي التسديدات', summary['totalPayments']!),
              const SizedBox(height: 10),
              _buildSummaryRow(
                  'المبلغ المستحق الكلي', summary['totalOutstanding']!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق النافذة
              },
              child: const Text(
                'إغلاق',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// دالة مساعدة لعرض صف في النافذة المنبثقة
/*   Widget _buildSummaryRow(String label, double value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value.toStringAsFixed(2), // عرض القيمة مع منزلتين عشريتين
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
 */

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value == value.toInt()
                ? value.toInt().toString()
                : value
                    .toStringAsFixed(2), // عرض القيمة كعدد صحيح إذا كانت كذلك
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // تصفية القائمة بناءً على نص البحث
    final filteredList = _showCustomersTable
        ? _customers
            .where((customer) => customer['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList()
        : _agents
            .where((agent) => agent['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEBEB),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'إدارة الحسابات',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22.0),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.home,
              size: 35,
              color: Color(0xFFF26157),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            },
          ),
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.account_balance_wallet,
                size: 30,
                color: Color(0xFFFF9334),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionPage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 18),
            IconButton(
              icon: const Icon(
                Icons.search,
                size: 30,
                color: Color.fromARGB(255, 106, 245, 111),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchClientPage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 18),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
/*                   // حقل البحث (يظهر على يمين الشاشة بجانب الأيقونات)
                  if (_showSearchField)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'ابحث بالاسم...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.cyan),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0), // جعل الحقل أصغر
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery =
                                  value; // تحديث نص البحث عند تغيير النص
                            });
                          },
                        ),
                      ),
                    ),
 */
                  if (_showSearchField)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'ابحث بالاسم...',

                            hintStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red), // أيقونة إغلاق
                              onPressed: () {
                                setState(() {
                                  _showSearchField = false; // إخفاء حقل البحث
                                  _searchQuery = ''; // إعادة تعيين نص البحث
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0), // جعل الحقل أصغر
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery =
                                  value; // تحديث نص البحث عند تغيير النص
                            });
                          },
                        ),
                      ),
                    ),

                  /*                  if (_showSearchField)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: TextField(
                          focusNode:
                              _searchFocusNode, // ربط FocusNode بحقل البحث
                          autofocus: true,

                          decoration: InputDecoration(
                            hintText: 'ابحث بالاسم...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red), // أيقونة إغلاق
                              onPressed: () {
                                setState(() {
                                  _showSearchField = false; // إخفاء حقل البحث
                                  _searchQuery = ''; // إعادة تعيين نص البحث
                                  _searchFocusNode
                                      .unfocus(); // إغلاق لوحة المفاتيح
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0), // جعل الحقل أصغر
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery =
                                  value; // تحديث نص البحث عند تغيير النص
                            });
                          },
                        ),
                      ),
                    ),
         */ // أيقونتي العملاء والوكلاء
                  Container(
                    padding: EdgeInsets.all(6.0),
                    width: 130.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.people,
                              color: _showCustomersTable
                                  ? Colors.blue
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () => _toggleTable(true),
                          ),
                          // const SizedBox(width: 20),
                          IconButton(
                            icon: Icon(
                              Icons.business,
                              color: !_showCustomersTable
                                  ? Colors.orange
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () => _toggleTable(false),
                          ),
                        ]),
                  ),
                ],
              ),
              /*              // أيقونتي العملاء والوكلاء
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.people,
                      color: _showCustomersTable ? Colors.blue : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => _toggleTable(true),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      Icons.business,
                      color: !_showCustomersTable ? Colors.orange : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => _toggleTable(false),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_showSearchField) // إظهار حقل البحث إذا كان _showSearchField يساوي true
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث بالاسم...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value; // تحديث نص البحث عند تغيير النص
                      });
                    },
                  ),
                ),
 */
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            _showCustomersTable ? Colors.blue : Colors.orange,
                        width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              _showCustomersTable ? Colors.blue : Colors.orange,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'الاسم',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            if (_showCustomersTable) // إظهار العمود الجديد فقط إذا كان _showCustomersTable يساوي true
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  'المبلغ علية',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            if (!_showCustomersTable) // إظهار العمود الجديد فقط إذا كان _showCustomersTable يساوي true
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  'المبلغ عليك',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            const Expanded(
                              flex: 2,
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
                      /*                      Expanded(
                        child: ListView.builder(
                          
                          itemCount: _showCustomersTable
                              ? _customers.length
                              : _agents.length,
                          itemBuilder: (context, index) {
                            final item = _showCustomersTable
                                ? _customers[index]
                                : _agents[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colors.grey[100]
                                    : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: _showCustomersTable
                                          ? Colors.blue
                                          : Colors.orange,
                                      width: 2.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Text(
                                        item['name'],
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 2.0,
                                    height: 48,
                                    color: _showCustomersTable
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                                  /*                       if (_showCustomersTable) // إظهار العمود الجديد فقط إذا كان _showCustomersTable يساوي true
                                    Expanded(
                                      flex: 3,
                                      child:
                                          FutureBuilder<Map<String, dynamic>>(
                                        future: _dbHelper
                                            .getSummaryByName(item['name']),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'خطأ: ${snapshot.error}');
                                          } else {
                                            final outstanding =
                                                snapshot.data!['outstanding'];
                                            return Text(
                                              outstanding.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  */
                                  if (_showCustomersTable) // إظهار العمود الجديد فقط إذا كان _showCustomersTable يساوي true
                                    Expanded(
                                      flex: 3,
                                      child:
                                          FutureBuilder<Map<String, dynamic>>(
                                        future: _dbHelper
                                            .getSummaryByName(item['name']),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'خطأ: ${snapshot.error}');
                                          } else {
                                            final outstanding =
                                                snapshot.data!['outstanding'];
                                            Color textColor;

                                            // تحديد لون النص بناءً على قيمة المبلغ المستحق
                                            if (outstanding > 0) {
                                              textColor = Colors
                                                  .red; // لون أحمر إذا كان المبلغ المستحق أكبر من 0
                                            } else if (outstanding < 0) {
                                              textColor = Colors
                                                  .green; // لون أخضر إذا كان المبلغ المستحق أقل من 0
                                            } else {
                                              textColor = Colors
                                                  .black; // لون أسود إذا كان المبلغ المستحق يساوي 0
                                            }

                                            return Text(
                                              outstanding.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    textColor, // تطبيق اللون المحدد
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  Container(
                                    width: 2.0,
                                    height: 48,
                                    color: _showCustomersTable
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.info,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        if (_showCustomersTable) {
                                          _showCustomerDetails(
                                            item['name'],
                                            item['phone'],
                                            item['id'],
                                          );
                                        } else {
                                          _showAgentDetails(
                                            item['name'],
                                            item['phone'],
                                            item['id'],
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                   */

                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              filteredList.length, // استخدام القائمة المصفاة
                          itemBuilder: (context, index) {
                            final item = filteredList[
                                index]; // استخدام العنصر من القائمة المصفاة
                            return Container(
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colors.grey[100]
                                    : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: _showCustomersTable
                                          ? Colors.blue
                                          : Colors.orange,
                                      width: 2.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Text(
                                        item['name'],
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 2.0,
                                    height: 48,
                                    color: _showCustomersTable
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                                  if (_showCustomersTable)
                                    Expanded(
                                      flex: 3,
                                      child:
                                          FutureBuilder<Map<String, dynamic>>(
                                        future: _dbHelper
                                            .getSummaryByName(item['name']),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'خطأ: ${snapshot.error}');
                                          } else {
                                            final outstanding =
                                                snapshot.data!['outstanding'];
                                            Color textColor;

                                            if (outstanding > 0) {
                                              textColor = Colors.red;
                                            } else if (outstanding < 0) {
                                              textColor = Colors.green;
                                            } else {
                                              textColor = Colors.black;
                                            }

                                            return Text(
                                              outstanding.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  if (!_showCustomersTable)
                                    Expanded(
                                      flex: 3,
                                      child:
                                          FutureBuilder<Map<String, dynamic>>(
                                        future:
                                            _dbHelper.getSummaryAgeentByName(
                                                item['name']),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'خطأ: ${snapshot.error}');
                                          } else {
                                            final outstanding =
                                                snapshot.data!['outstanding'];
                                            Color textColor;

                                            if (outstanding > 0) {
                                              textColor = Colors.red;
                                            } else if (outstanding < 0) {
                                              textColor = Colors.green;
                                            } else {
                                              textColor = Colors.black;
                                            }

                                            return Text(
                                              outstanding.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  Container(
                                    width: 2.0,
                                    height: 48,
                                    color: _showCustomersTable
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.info,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        if (_showCustomersTable) {
                                          FocusScope.of(context).unfocus();
                                          _showCustomerDetails(
                                            item['name'],
                                            item['phone'],
                                            item['id'],
                                          );
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          _showAgentDetails(
                                            item['name'],
                                            item['phone'],
                                            item['id'],
                                          );
                                        }
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

/*               Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0x8300BBD4),
                  border: Border(top: BorderSide(width: 3, color: Colors.cyan)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      // هنا اضافة عرض حقل البحث
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
                        onPressed: _showAddAccountDialog,
                      ),
                    ),
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ),
        */
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0x8300BBD4),
                  border: Border(top: BorderSide(width: 3, color: Colors.cyan)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          _showSearchField =
                              !_showSearchField; // تبديل حالة إظهار حقل البحث
                          _searchQuery =
                              ''; // إعادة تعيين نص البحث عند إخفاء الحقل
                        });
                      },
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
                        onPressed: _showAddAccountDialog,
                      ),
                    ),
                    // const Icon(
                    //   Icons.info_outline,
                    //   color: Colors.white,
                    //   size: 40,
                    // ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed:
                          _showTotalSummaryDialog, // استدعاء الدالة عند النقر
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

  TableRow _buildInfoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 6.0, 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _deleteCustomer(int id) async {
    await _dbHelper.deleteCustomer(id);
    _showSuccessMessage('تم حذف العميل بنجاح');
    _loadCustomers();
  }

/* 
  void _showCustomerDetails(String name, String phone, int id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFF6F6F6),
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
                      ' تفاصيل العميل',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2.5),
                          1: FlexColumnWidth(7.5),
                        },
                        border: TableBorder.all(
                          color: Colors.cyan,
                          width: 1.5,
                        ),
                        children: [
                          _buildInfoRow(name, 'الاسم'),
                          _buildInfoRow(phone, 'الهاتف')
                        ]),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteCustomer(id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text('حذف'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 10.0),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _updateCustomer(id, name, phone);
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text('تعديل'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 16.0),
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
        });
  }
 */
  void _showCustomerDetails(String name, String phone, int id) async {
    final summary = await _dbHelper.getSummaryByName(name);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFF6F6F6),
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      ' تفاصيل العميل',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(3.5),
                          1: FlexColumnWidth(6.5),
                        },
                        border: TableBorder.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'الاسم',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          // _buildInfoRow(name, 'الاسم'),
                          _buildInfoRow(phone, 'الهاتف'),
                          _buildInfoRow(summary['totalAdditions'].toString(),
                              'كل الديون'),
                          _buildInfoRow(summary['totalPayments'].toString(),
                              'كل التسديدات'),
                          _buildInfoRow(
                              summary['outstanding'].toString(), ' المستحق لك'),
                        ]),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteCustomer(id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(''),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _updateCustomer(id, name, phone);
                          },
                          icon: const Icon(Icons.edit, color: Colors.cyan),
                          label: const Text(''),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 8.0),
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
        });
  }

  void _updateCustomer(int id, String name, String phone) async {
    _nameController.text = name;
    _phoneController.text = phone;

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
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
                      'تعديل بيانات عميل',
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
                    width: double.infinity,
                    height: 3,
                    color: Colors.cyan,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            labelText: 'الاسم',
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
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 6,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            labelText: 'رقم الهاتف',
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
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 3,
                    color: Colors.cyan,
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
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
                            child: const Text('إلغاء'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _dbHelper.updateCustomer(
                                id,
                                _nameController.text,
                                _phoneController.text,
                              );
                              _showSuccessMessage(
                                  'تم تعديل بيانات العميل بنجاح');
                              _loadCustomers();
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
                            child: const Text('حفظ'),
                          ),
                        ],
                      )),
                ],
              )),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _showAgentDetails(String name, String phone, int id) async {
    final summaryAgeen = await _dbHelper.getSummaryAgeentByName(name);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFFF6F6F6),
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
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      ' تفاصيل المورد',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4.0),
                          1: FlexColumnWidth(6.0),
                        },
                        border: TableBorder.all(
                          color: Colors.orange,
                          width: 2.5,
                        ),
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'الاسم',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          // _buildInfoRow(name, 'الاسم'),
                          _buildInfoRow(phone, 'الهاتف'),
                          _buildInfoRow(
                              summaryAgeen['totalAdditions'].toString(),
                              'كل القروضات'),
                          _buildInfoRow(
                              summaryAgeen['totalPayments'].toString(),
                              'كل التسديدات'),
                          _buildInfoRow(summaryAgeen['outstanding'].toString(),
                              'المبلغ المستحق'),
                        ]),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteAgent(id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(''),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _updateAgent(id, name, phone);
                          },
                          icon: const Icon(Icons.edit, color: Colors.cyan),
                          label: const Text(''),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 8.0),
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
        });
  }

  void _deleteAgent(int id) async {
    await _dbHelper.deleteAgent(id);
    _showSuccessMessage('تم حذف الوكيل بنجاح');
    _loadAgents();
  }

  void _updateAgent(int id, String name, String phone) async {
    _nameController.text = name;
    _phoneController.text = phone;

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
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
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'تعديل بيانات وكيل',
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
                    width: double.infinity,
                    height: 3,
                    color: Colors.orange,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            labelText: 'الاسم',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 6,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            labelText: 'رقم الهاتف',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 3,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 4,
                            ),
                            child: const Text('إلغاء'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _dbHelper.updateAgent(
                                id,
                                _nameController.text,
                                _phoneController.text,
                              );
                              _showSuccessMessage(
                                  'تم تعديل بيانات الوكيل بنجاح');
                              _loadAgents();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 4,
                            ),
                            child: const Text('حفظ'),
                          ),
                        ],
                      )),
                ],
              )),
        ),
      ),
    );
  }
}
