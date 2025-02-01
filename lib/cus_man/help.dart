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
            _buildSummaryRow('المبلغ المستحق الكلي', summary['totalOutstanding']!),
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