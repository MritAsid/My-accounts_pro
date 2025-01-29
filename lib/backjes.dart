// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // أضف هذا الاستيراد
import 'database/database_helper.dart';
import 'dart:io';

class BackupRestorePage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  BackupRestorePage({super.key});

  // دالة لطلب إذن الوصول إلى الذاكرة الخارجية
  Future<void> requestStoragePermission(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      // print('تم منح إذن الوصول إلى الذاكرة الخارجية');
    } else {
      // print('تم رفض إذن الوصول إلى الذاكرة الخارجية');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم رفض إذن الوصول إلى الذاكرة الخارجية'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createBackup(BuildContext context) async {
    try {
      // طلب إذن الوصول إلى الذاكرة الخارجية قبل إنشاء النسخة الاحتياطية
      await requestStoragePermission(context);

      final backupFile = await dbHelper.exportDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إنشاء النسخة الاحتياطية: ${backupFile.path}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل إنشاء النسخة الاحتياطية: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    try {
      // طلب إذن الوصول إلى الذاكرة الخارجية قبل استعادة النسخة الاحتياطية
      await requestStoragePermission(context);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        // allowedExtensions: ['db'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);

        // التحقق من وجود الملف
        if (await file.exists()) {
          await dbHelper.importDatabase(file);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم استعادة النسخة الاحتياطية بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الملف غير موجود'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل استعادة النسخة الاحتياطية: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي والاستعادة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _createBackup(context),
              child: const Text('إنشاء نسخة احتياطية'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _restoreBackup(context),
              child: const Text('استعادة نسخة احتياطية'),
            ),
          ],
        ),
      ),
    );
  }
}
