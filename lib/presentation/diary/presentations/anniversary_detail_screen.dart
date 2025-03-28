import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_anniversary_screen.dart';
import 'diary_screen.dart';

class AnniversaryDetailScreen extends StatefulWidget {
  final Anniversary anniversary;
  const AnniversaryDetailScreen({super.key, required this.anniversary});

  @override
  State<AnniversaryDetailScreen> createState() =>
      _AnniversaryDetailScreenState();
}

class _AnniversaryDetailScreenState extends State<AnniversaryDetailScreen> {
  late Anniversary currentAnn;

  @override
  void initState() {
    super.initState();
    // Sao chép dữ liệu ban đầu
    currentAnn = widget.anniversary;
  }

  // Hàm format ngày
  String get _formattedDate {
    return DateFormat("d/MM/yyyy").format(currentAnn.date);
  }

  // Hàm xử lý khi bấm nút Edit
  Future<void> _editAnniversary() async {
    final updated = await Navigator.push<Anniversary>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAnniversaryScreen(anniversary: currentAnn),
      ),
    );

    if (updated != null) {
      setState(() {
        currentAnn = updated; // cập nhật hiển thị
      });
    }
  }

  // Hàm xử lý khi bấm nút Delete với xác nhận
  Future<void> _deleteAnniversary() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this diary entry?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      // Trả về signal "deleted" cho màn hình trước
      Navigator.pop(context, 'deleted');
    }
  }

  // Hàm thoát màn hình, trả về Anniversary đã update (nếu có)
  void _popWithUpdatedAnniversary() {
    Navigator.pop(context, currentAnn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Detail'),
        actions: [
          // Nút sửa
          IconButton(icon: const Icon(Icons.edit), onPressed: _editAnniversary),
          // Nút xoá
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAnniversary,
          ),
        ],
      ),
      // Khi người dùng bấm nút back mặc định, ta cũng pop về kèm item (có thể đã update)
      body: WillPopScope(
        onWillPop: () async {
          _popWithUpdatedAnniversary();
          return false;
        },
        // Thêm padding bên dưới để nội dung không bị che bởi nút FAB
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ảnh bo tròn
              if (currentAnn.imagePath != null &&
                  currentAnn.imagePath!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(currentAnn.imagePath!),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 300,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Ngày bên trong Container bo góc
              // Thay thế phần hiển thị ngày
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tiêu đề
              Text(
                currentAnn.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Nội dung
              if (currentAnn.content != null && currentAnn.content!.isNotEmpty)
                Text(currentAnn.content!, style: const TextStyle(fontSize: 16))
              else
                const Text(
                  'No content',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ),
      // Đưa nút check ra giữa
      floatingActionButton: FloatingActionButton(
        onPressed: _popWithUpdatedAnniversary,
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
