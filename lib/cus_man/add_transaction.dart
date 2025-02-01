import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_delete.dart';
import 'search.dart';
import '../main.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();

  final TextEditingController _agentNameController = TextEditingController();
  final FocusNode _agentNameFocusNode = FocusNode();
  int? selectedAgentId; // ID الوكيل المختار
  List<Map<String, dynamic>> matchingAgents = []; // قائمة الوكلاء المطابقين
  String _selectedView = 'customers'; // عرض العمليات الحالية (عملاء أو وكلاء)

  String _transactionType = '';
  int? selectedClientId; // ID العميل المختار
  List<Map<String, dynamic>> matchingClients = []; // قائمة الأسماء المطابقة
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _recentTransactions = [];

// =========  نقل المواشر الى اخر حرف ===========
  @override
  void dispose() {
    // التخلص من الـControllers والـFocusNodes
    _nameController.dispose();
    _amountController.dispose();
    _detailsController.dispose();
    _nameFocusNode.dispose();
    _amountFocusNode.dispose();
    _detailsFocusNode.dispose();

    // استدعاء super.dispose() في النهاية
    super.dispose();
  }

// ========= استرجاع الاسماء للعملاء===========
  void _searchClients(String query) async {
    if (query.isEmpty) {
      setState(() {
        matchingClients = [];
      });
      return;
    }
    final results = await DatabaseHelper().searchClientsByName(query);
    setState(() {
      matchingClients = results;
    });
  }

// ========= استرجاع الاسماء للوكلاء===========
  void _searchAgents(String query) async {
    if (query.isEmpty) {
      setState(() {
        matchingAgents = [];
      });
      return;
    }
    final results = await DatabaseHelper().searchAgentsByName(query);
    setState(() {
      matchingAgents = results;
    });
  }

// =========  تحديثات الواجهه  ===========
  @override
  void initState() {
    super.initState();

    _fetchTransactionsByDate(DateTime.now());
    // تحريك المؤشر إلى نهاية النص عند التركيز على الحقل
    _nameFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus) {
        _moveCursorToEnd(_nameController);
      }
    });

    _amountFocusNode.addListener(() {
      if (_amountFocusNode.hasFocus) {
        _moveCursorToEnd(_amountController);
      }
    });

    _detailsFocusNode.addListener(() {
      if (_detailsFocusNode.hasFocus) {
        _moveCursorToEnd(_detailsController);
      }
    });
  }

// ========= نقل المواشر  الى الحقل التالي  ===========
  void _moveCursorToEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  // جلب العمليات  للعملاء بناءً على التاريخ المحدد
  Future<void> _fetchTransactionsByDate(DateTime date) async {
    final transactions = await DatabaseHelper().getOperationsByDate(date);
    setState(() {
      _recentTransactions = transactions;
      _selectedDate = date;
    });
  }

  //  فتح جدول اختيار التاريخ للعملاء
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await _fetchTransactionsByDate(picked);
    }
  }

// جلب العمليات للوكلاء بناءً على التاريخ المحدد
  Future<void> _fetchAgentTransactionsByDate(DateTime date) async {
    final transactions = await DatabaseHelper().getAgentOperationsByDate(date);
    setState(() {
      _recentTransactions = transactions;
      _selectedDate = date;
    });
  }

// فتح جدول اختيار التاريخ للوكلاء
  Future<void> _selectAgentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await _fetchAgentTransactionsByDate(picked);
    }
  }

// =============== الواجهه ==================
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEBEB),
        appBar: AppBar(
          title: const Text(
            'إضافة عملية مالية',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
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
                  builder: (context) =>
                      const MyApp(), // استبدل AddTransactionPage بالصفحة المستهدفة
                ),
              );
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.person,
                  size: 30,
                  color: Color.fromARGB(255, 76, 96, 245),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddDeletePage(), // استبدل AddTransactionPage بالصفحة المستهدفة
                    ),
                  );
                }),
            const SizedBox(width: 8),
            IconButton(
                icon: const Icon(Icons.search,
                    size: 30, color: Color.fromARGB(255, 106, 245, 111)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SearchClientPage(), // استبدل AddTransactionPage بالصفحة المستهدفة
                    ),
                  );
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // أيقونة عرض العملاء
                  IconButton(
                    onPressed: () async {
                      await _fetchTransactionsByDate(
                          DateTime.now()); // جلب عمليات العملاء
                      setState(() {
                        _selectedView = 'customers'; // تعيين العرض للعملاء
                      });
                    },
                    icon: Icon(
                      Icons.people,
                      color: _selectedView == 'customers'
                          ? Colors.blue
                          : Colors.grey,
                      size: 35,
                    ),
                  ),

                  // أيقونة عرض الوكلاء
                  IconButton(
                    icon: Icon(
                      Icons.business,
                      color: _selectedView != 'customers'
                          ? Colors.orange
                          : Colors.grey,
                      size: 35,
                    ),
                    onPressed: () async {
                      await _fetchAgentTransactionsByDate(
                          DateTime.now()); // جلب عمليات الوكلاء
                      setState(() {
                        _selectedView = 'agents'; // تعيين العرض للوكلاء
                      });
                    },
                  ),

                  // أيقونة اختيار التاريخ
                  IconButton(
                    icon: const Icon(
                      Icons.date_range_rounded,
                      color: Colors.cyan,
                      size: 30,
                    ),
                    onPressed: () => _selectedView == 'customers'
                        ? _selectDate(context) // اختيار التاريخ لعمليات العملاء
                        : _selectAgentDate(
                            context), // اختيار التاريخ لعمليات الوكلاء
                  ),

                  if (_selectedDate != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${_selectedDate!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),

              // ==== الجدول ==================
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedView == 'customers'
                          ? Colors.blue
                          : Colors.orange,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // العنوان
                      Container(
                        decoration: BoxDecoration(
                          color: _selectedView == 'customers'
                              ? Colors.blue
                              : Colors.orange,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                _selectedView == 'customers'
                                    ? 'اسم العميل'
                                    : 'اسم المورد',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'المبلغ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
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
                      // المحتوى
                      Expanded(
                        child: _recentTransactions.isEmpty
                            ? const Center(
                                child: Text(
                                  "لا توجد عمليات للتاريخ المحدد",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _recentTransactions.length,
                                itemBuilder: (context, index) {
                                  final transaction =
                                      _recentTransactions[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? const Color(0xFFF1F1F1)
                                          : Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: _selectedView == 'customers'
                                              ? Colors.blue
                                              : Colors.orange,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // عمود الاسم
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 13,
                                                horizontal: 4,
                                              ),
                                              child: Text(
                                                transaction[
                                                    _selectedView == 'customers'
                                                        ? 'client_name'
                                                        : 'agent_name'],
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // عمود المبلغ
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: _selectedView ==
                                                          'customers'
                                                      ? Colors.blue
                                                      : Colors.orange,
                                                  width: 2.0,
                                                ),
                                                right: BorderSide(
                                                  color: _selectedView ==
                                                          'customers'
                                                      ? Colors.blue
                                                      : Colors.orange,
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: 4,
                                              ),
                                              child: Text(
                                                transaction['amount']
                                                        ?.toString() ??
                                                    'غير معروف',
                                                textAlign: TextAlign.center,
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
                                          flex: 2,
                                          child: _buildInfoCell(transaction),
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
                        onPressed: _showAddOperationDialog,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 40,
                      ),

                      //تمرير الدالة كمرجع دون استدعائها
                      onPressed: () async {
                        await _showSummaryDialog(
                            context); // استدعاء الدالة بشكل صحيح
                      },
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

//  ========= نافذة اختيار  الاضافة لعميل او لوكيل  ===========
  void _showAddOperationDialog() {
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
                  'إضافة عملية الى حساب',
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
                        Navigator.pop(context); // إغلاق النافذة الحالية
                        _showAddCustomerOperationDialog(); // فتح نافذة إضافة عملية لعميل
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: const Text('عميل'),
                    ),
                    Text(
                      'او',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.cyan,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // إغلاق النافذة الحالية
                        // فتح نافذة إضافة عملية لوكيل
                        _showAddAgentOperationDialog(); // فتح نافذة إضافة عملية لوكيل
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

// ===============   نافذة اضافة عملية لعميل ==================
  void _showAddCustomerOperationDialog() {
    setState(() {
      matchingClients = []; // إعادة تعيين القائمة المقترحة
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                backgroundColor: const Color.fromARGB(255, 236, 232, 232),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: SingleChildScrollView(
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
                          'اضافة العملية',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 10.0),
                      _buildNameFieldWithSuggestions(setState),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// ===============  انشاء الحقوال والقائمة المشابهة للعملاء==================
  Widget _buildNameFieldWithSuggestions(
      void Function(void Function()) setState) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // حقل الاسم
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.cyan, width: 2.0),
                    bottom: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'الاسم :   ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
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
                                  vertical: 8, horizontal: 4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchClients(value); // تحديث القائمة المقترحة
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال الاسم';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    // حقل المبلغ
                    Row(
                      children: [
                        const Text(
                          'المبلغ :    ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
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
                                  vertical: 8, horizontal: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    // حقل التفاصيل
                    Row(
                      children: [
                        const Text(
                          'تفاصيل : ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _detailsController,
                            focusNode: _detailsFocusNode,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              // إزالة التركيز عند الانتهاء
                              FocusScope.of(context).unfocus();
                            },
                            decoration: const InputDecoration(
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
                                  vertical: 8, horizontal: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),

              // اختيار نوع العملية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // خيار "اظافة"
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _transactionType = 'إضافة';
                        _amountFocusNode.unfocus();
                        _detailsFocusNode.unfocus();
                      });
                      _saveTransaction();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _transactionType == 'إضافة'
                            ? Colors.red
                            : Colors.white,
                        border: Border.all(
                          color: const Color(0xFFFF665B),
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'إضافة',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: _transactionType == 'إضافة'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _transactionType = 'تسديد';
                        _amountFocusNode.unfocus();
                        _detailsFocusNode.unfocus();
                      });
                      _saveTransaction();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _transactionType == 'تسديد'
                            ? Colors.green
                            : Colors.white,
                        border: Border.all(
                          color: const Color(0xFF70FF75),
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'تسديد',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: _transactionType == 'تسديد'
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
            ],
          ),
        ),
        // قائمة الأسماء المقترحة
        if (matchingClients.isNotEmpty)
          Positioned(
            top: 60.0, // تحديد موقع القائمة بالنسبة لحقل الإدخال
            left: 10,
            right: 70,
            child: Container(
              constraints: const BoxConstraints(
                  maxHeight: 140), // الحد الأقصى لارتفاع القائمة
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: Colors.cyan, width: 3.0), // تحديد الحواف
                borderRadius: BorderRadius.circular(8.0), // زوايا مستديرة
              ),
              child: ListView.builder(
                itemCount: matchingClients.length,
                itemBuilder: (context, index) {
                  final client = matchingClients[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 0.0,
                        ),
                        title: Text(
                          client['name'], // عرض اسم العميل
                          textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _nameController.text =
                                client['name']; // تحديث حقل النص
                            selectedClientId = client['id']; // تخزين ID العميل
                            matchingClients = []; // إخفاء القائمة بعد الاختيار
                          });
                        },
                      ),
                      // إضافة فاصل بين العناصر
                      if (index < matchingClients.length - 1)
                        const Divider(
                          color: Colors.cyan,
                          height: 0.0,
                          thickness: 1.7,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

// ===============   نافذة اضافة عملية لوكيل ==================
  void _showAddAgentOperationDialog() {
    setState(() {
      matchingAgents = []; // إعادة تعيين قائمة الاقتراحات
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                backgroundColor: const Color(0xFFF6F6F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // عنوان النافذة
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
                          'إضافة عملية لوكيل',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      // حقل البحث عن اسم الوكيل
                      _buildAgentNameFieldWithSuggestions(setState),

                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// ===============  انشاء الحقوال والقائمة المشابهة لوكيل==================
  Widget _buildAgentNameFieldWithSuggestions(
      void Function(void Function()) setState) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // حقل الاسم
              Row(
                children: [
                  const Text(
                    'الاسم: ',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _agentNameController,
                      focusNode: _agentNameFocusNode,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchAgents(value); // تحديث القائمة المقترحة
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),

              // حقل المبلغ
              Row(
                children: [
                  const Text(
                    'المبلغ: ',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      focusNode: _amountFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),

              // حقل التفاصيل
              Row(
                children: [
                  const Text(
                    'التفاصيل: ',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _detailsController,
                      focusNode: _detailsFocusNode,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),

              // اختيار نوع العملية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _transactionType = 'قرض'; // اختيار نوع العملية قرض
                        _amountFocusNode.unfocus();
                        _detailsFocusNode.unfocus();
                      });
                      _saveAgentOperation();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _transactionType == 'قرض'
                            ? Colors.red
                            : Colors.white,
                        border: Border.all(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'قرض',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: _transactionType == 'قرض'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _transactionType = 'تسديد'; // اختيار نوع العملية تسديد
                        _amountFocusNode.unfocus();
                        _detailsFocusNode.unfocus();
                      });
                      _saveAgentOperation();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _transactionType == 'تسديد'
                            ? Colors.green
                            : Colors.white,
                        border: Border.all(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'تسديد',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: _transactionType == 'تسديد'
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
            ],
          ),
        ),

        // قائمة الوكلاء المطابقة
        if (matchingAgents.isNotEmpty)
          Positioned(
            top: 60.0,
            left: 10,
            right: 55.0,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 140),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.builder(
                itemCount: matchingAgents.length,
                itemBuilder: (context, index) {
                  final agent = matchingAgents[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        title: Text(
                          agent['name'],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _agentNameController.text = agent['name'];
                            selectedAgentId = agent['id'];
                            matchingAgents = [];
                          });
                        },
                      ),
                      if (index < matchingAgents.length - 1)
                        const Divider(
                          color: Colors.orange,
                          height: 1.0,
                          thickness: 1.0,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

//  ========= تحديث الواجهه ===========
  void _refreshTransactions(DateTime date) async {
    final databaseHelper = DatabaseHelper();
    final newTransactions = await databaseHelper.getOperationsByDate(date);
    setState(() {
      _recentTransactions = newTransactions;
    });
  }

//  =========  انشاء عمود معلومات ===========
  Widget _buildInfoCell(Map<String, dynamic> transaction) {
    Color iconColor =
        (transaction['type'] == 'قرض' || transaction['type'] == 'إضافة')
            ? const Color(0xFFFF4134) // أحمر
            : const Color(0xFF66EE6B); // أخضر

    return IconButton(
      icon: Icon(
        Icons.info_sharp,
        color: iconColor,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _buildTransactionDetailsDialog(transaction),
        );
      },
    );
  }

//  ========= نافذة عرض تفاصيل العملية ===========
  Widget _buildTransactionDetailsDialog(Map<String, dynamic> transaction) {
    // التحقق من صحة التاريخ قبل التحليل
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(transaction['date'] ?? '');
    } catch (e) {
      parsedDate = DateTime.now(); // تعيين التاريخ الحالي إذا كان هناك خطأ
    }

    // استخراج التاريخ بصيغة يوم/شهر/سنة
    final String formattedDate =
        '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';

    // استخراج الوقت بصيغة ساعات ودقائق
    final String formattedTime =
        '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE1E1E1),
          borderRadius: BorderRadius.circular(12.0),
        ),
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

            const SizedBox(height: 10.0),

            // جدول التفاصيل
            Container(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.cyan, width: 3.0),
                  bottom: BorderSide(color: Colors.cyan, width: 3.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2.5),
                    1: FlexColumnWidth(7.5),
                  },
                  border: TableBorder.all(
                    color: Colors.cyan,
                    width: 2.5,
                  ),
                  children: [
                    _buildInfoRow(
                      transaction[_selectedView == 'customers'
                              ? 'client_name'
                              : 'agent_name'] ??
                          'غير معروف',
                      'الاسم',
                    ),
                    _buildInfoRow(
                      transaction['amount']?.toString() ?? 'غير معروف',
                      'المبلغ',
                    ),
                    _buildInfoRow(
                      transaction['details'] ?? 'غير معروف',
                      'تفاصيل',
                    ),
                    _buildInfoRow(
                      transaction['type'] ?? 'غير معروف',
                      'النوع',
                    ),
                    _buildInfoRow(formattedDate, 'التاريخ'),
                    _buildInfoRow(formattedTime, 'الوقت'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10.0),

            // الأزرار (حذف وتعديل)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteTransaction(transaction);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(''),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _editTransaction(transaction);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 30,
                  ),
                  label: const Text(''),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                  ),
                ),
              ],
            ),

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
  }

//  ========= انشاء صفوف لتفاصيل العملية ===========
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
            textAlign: TextAlign.center,
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

// ========= حذف عملية ===========
  void _deleteTransaction(Map<String, dynamic> transaction) async {
    // احصل على معرف العملية
    final int? transactionId = transaction['operation_id'];

    if (transactionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('العملية المحددة غير صالحة للحذف'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // احصل على المثيل
      final databaseHelper = DatabaseHelper();

      int rowsAffected = 0;

      if (_selectedView == 'customers') {
        // حذف العملية من جدول العملاء
        rowsAffected = await databaseHelper.deleteOperation(transactionId);
      } else if (_selectedView == 'agents') {
        // حذف العملية من جدول الوكلاء
        rowsAffected = await databaseHelper.deleteAgentOperation(transactionId);
      }

      if (rowsAffected > 0) {
        // تحديث العمليات بناءً على نوع العرض الحالي
        if (_selectedView == 'customers') {
          _refreshTransactions(_selectedDate!); // تحديث عمليات العملاء
        } else if (_selectedView == 'agents') {
          await _fetchAgentTransactionsByDate(
              _selectedDate!); // تحديث عمليات الوكلاء
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف العملية بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في حذف العملية'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء حذف العملية'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

//  =========  تعديل عملية ===========
  Future<void> _editTransaction(Map<String, dynamic> transaction) async {
    // التحقق من وجود المفاتيح المتوقعة
    if (!transaction.containsKey('amount') ||
        !transaction.containsKey('details') ||
        !transaction.containsKey('type')) {
      return;
    }

    // التحقق من أن القيم غير null
    if (transaction['amount'] == null ||
        transaction['details'] == null ||
        transaction['type'] == null) {
      return;
    }

    // إنشاء controllers وتعيين القيم
    final TextEditingController amountController =
        TextEditingController(text: transaction['amount'].toString());
    final TextEditingController detailsController =
        TextEditingController(text: transaction['details']);
    String selectedType = transaction['type']; // النوع الحالي
    String teypTrens = _selectedView == 'customers' ? 'إضافة' : 'قرض';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                backgroundColor: const Color.fromARGB(
                    255, 236, 232, 232), // خلفية النافذة بيضاء
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 10, // إضافة ظل للنافذة
                child: SingleChildScrollView(
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

                      // مربع بحواف زرقاء
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.cyan, width: 2.0),
                            bottom: BorderSide(color: Colors.cyan, width: 2.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            // حقل تعديل المبلغ
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'المبلغ',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.cyan),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyan, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyan, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 20.0),

                            // حقل تعديل التفاصيل
                            TextField(
                              controller: detailsController,
                              decoration: InputDecoration(
                                labelText: 'التفاصيل',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.cyan),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyan, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyan, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
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
                      const SizedBox(height: 10.0),

                      // اختيار نوع العملية
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFFFF665B), width: 2.0),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  teypTrens,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800),
                                ),
                                Radio<String>(
                                  value: teypTrens,
                                  activeColor: Colors.red,
                                  groupValue: selectedType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedType = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFF70FF75), width: 2.0),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'تسديد',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800),
                                ),
                                Radio<String>(
                                  value: 'تسديد',
                                  activeColor: Colors.green,
                                  groupValue: selectedType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedType = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),

                      // أزرار الحفظ والإلغاء
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (amountController.text.isEmpty ||
                                  detailsController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('يرجى تعبئة جميع الحقول'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              try {
                                final databaseHelper = DatabaseHelper();

                                int rowsAffected = 0;

                                if (_selectedView == 'customers') {
                                  rowsAffected =
                                      await databaseHelper.updateOperation(
                                    transaction['operation_id'],
                                    double.parse(amountController.text),
                                    detailsController.text,
                                    selectedType,
                                  );
                                } else if (_selectedView == 'agents') {
                                  rowsAffected =
                                      await databaseHelper.updateAgentOperation(
                                    transaction['operation_id'],
                                    double.parse(amountController.text),
                                    detailsController.text,
                                    selectedType,
                                  );
                                }

                                if (rowsAffected > 0) {
                                  Navigator.of(context).pop();
                                  if (_selectedView == 'customers') {
                                    _refreshTransactions(_selectedDate!);
                                  } else if (_selectedView == 'agents') {
                                    await _fetchAgentTransactionsByDate(
                                        _selectedDate!);
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم تعديل العملية بنجاح'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('فشل في تعديل العملية'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (error) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('حدث خطأ أثناء تعديل العملية'),
                                    backgroundColor: Colors.red,
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
                            child: const Text('حفظ'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
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
                            child: const Text('إلغاء'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

//  =========  فتح نافذة ملخص العمليات ===========
  Future<void> _showSummaryDialog(BuildContext context) async {
    if (_selectedDate == null) return;

    final summary = _selectedView == 'customers'
        ? await DatabaseHelper().getSummaryByDate(_selectedDate!)
        : await DatabaseHelper().getAgentSummaryByDate(_selectedDate!);
    String teypTrens = _selectedView == 'customers' ? 'الديون' : 'سحب اجل';
    String boxTrens =
        _selectedView == 'customers' ? 'صندوق العملاء' : 'صندوق الموردين';
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFEEEBEB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: _selectedView == 'customers'
                      ? Colors.blue
                      : Colors.orange,
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
                padding: const EdgeInsets.all(6.0),
                width: 120.0,
                child: Center(
                  child: Text(
                    "${_selectedDate!.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(5.0), // الكلمات التعريفية 20%
                    1: FlexColumnWidth(5.0), // البيانات 80%
                  },
                  border: TableBorder.all(
                    color: _selectedView == 'customers'
                        ? Colors.blue
                        : Colors.orange,
                    width: 3,
                  ),
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'التسديدات',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            summary['total_payments'].toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            teypTrens,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            summary['total_additions'].toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            boxTrens,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            summary['balance'].toString(),
                            style: TextStyle(
                              color: summary['balance']! >= 0
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق النافذة
                },
                child: const Text("إغلاق"),
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  primary: _selectedView == 'customers'
                      ? Colors.blue
                      : Colors.orange, // لون الزر
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//  =========  التحقق من وجود العميل قبل الحفظ  ===========
  void _saveTransaction() async {
    if (_transactionType.isNotEmpty) {
      final databaseHelper = DatabaseHelper();
      String trimmedName =
          _nameController.text.trim(); // استخدام النص مباشرة من وحدة التحكم

      // التحقق من وجود العميل
      bool clientExists = await databaseHelper.doesClientExist(trimmedName);

      if (!clientExists) {
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) {
            String phoneNumber = '';

            return StatefulBuilder(
              builder: (context, setState) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Dialog(
                      backgroundColor: const Color(0xFFEEEBEB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: SingleChildScrollView(
                          child: Container(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              decoration: const BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                ' اضافة عميل جديد',
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
                              width: double.infinity,
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  const Text(
                                      'اسم العميل غير محفوظ. هل ترغب في حفظه؟'),
                                  const SizedBox(height: 16.0),
                                  TextField(
                                    textDirection: TextDirection.rtl,
                                    decoration: const InputDecoration(
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                      labelText: 'رقم الهاتف',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan),
                                        // البوردر الافتراضي
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan, width: 2.0),
                                        // البوردر عند عدم التركيز
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan,
                                            width: 2.0), // البوردر عند التركيز
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 6,
                                      ),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {
                                      phoneNumber = value;
                                    },
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
                            const SizedBox(height: 18.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // إغلاق النافذة
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
                                    'إلغاء',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (phoneNumber.isNotEmpty) {
                                      await databaseHelper.insertCustomer(
                                          trimmedName, phoneNumber);

                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'تم حفظ العميل والعملية بنجاح'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      // حفظ العملية بعد حفظ العميل
                                      await _saveTransactionToDatabase();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('يرجى إدخال رقم الهاتف'),
                                          backgroundColor: Colors.red,
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
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ))),
                );
              },
            );
          },
        );
      } else {
        // إذا كان العميل موجودًا، قم بحفظ العملية مباشرة
        await _saveTransactionToDatabase();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار نوع العملية')),
      );
    }
  }

// ================  حفظ العملية للعملاء===============
  Future<void> _saveTransactionToDatabase() async {
    double? amount = double.tryParse(_amountController.text.trim());
    String details = _detailsController.text.trim();

    if (selectedClientId == null || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار عميل صحيح ومبلغ أكبر من 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await DatabaseHelper().insertOperation(
      selectedClientId!, // إرسال ID العميل
      amount,
      details,
      _transactionType,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ العملية بنجاح'),
        backgroundColor: Colors.green,
      ),
    );

    await _fetchTransactionsByDate(DateTime.now()); // جلب عمليات العملاء
    setState(() {
      _selectedView = 'customers'; // تعيين العرض للعملاء
    });
  }

// ================  حفظ العملية للوكلاء===============
  void _saveAgentOperation() async {
    if (_transactionType.isNotEmpty) {
      double? amount = double.tryParse(_amountController.text.trim());
      String details = _detailsController.text.trim();

      if (selectedAgentId == null || amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار وكيل صحيح ومبلغ أكبر من 0'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await DatabaseHelper().insertAgentOperation(
        selectedAgentId!,
        amount,
        details,
        _transactionType,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ العملية بنجاح'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

      //  هنا التعديل
      await _fetchAgentTransactionsByDate(DateTime.now()); // جلب عمليات الوكلاء
      setState(() {
        _selectedView = 'agents'; // تعيين العرض للوكلاء
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار نوع العملية')),
      );
    }
  }
}
