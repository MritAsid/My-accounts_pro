// ignore_for_file: use_build_context_synchronously

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
                    color: Colors.cyan,
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
                  color: Colors.cyan,
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
                          primary: Colors.orange,
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

  @override
  Widget build(BuildContext context) {
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
              // const SizedBox(height: 8.0),
              Container(
                // padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                // width: 240,

                // alignment: AlignmentDirectional.,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.white,
                  // border: Border.all(color: Colors.cyan, width: 3),
                ),
                child: // أيقونتي العملاء والوكلاء
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        color:
                            !_showCustomersTable ? Colors.orange : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () => _toggleTable(false),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 8.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                  color: _showCustomersTable ? Colors.blue : Colors.orange,
                ),
                child: Text(
                  _showCustomersTable ? 'جدول العملاء' : 'جدول الوكلاء',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
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
                          children: const [
                            Expanded(
                              flex: 7,
                              child: Text(
                                'الاسم',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
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

  void _showAgentDetails(String name, String phone, int id) {
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
                      ' تفاصيل الوكيل',
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
                          color: Colors.orange,
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
                            _deleteAgent(id);
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
                            _updateAgent(id, name, phone);
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
