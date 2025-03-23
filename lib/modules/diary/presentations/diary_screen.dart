import 'package:flutter/material.dart';
import '../../../utils/helpers/database_helper.dart';
import 'add_anniversary_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class Anniversary {
  final int? id; // id trong DB (có thể null khi chưa lưu)
  final String title; // tiêu đề
  final DateTime date; // ngày kỷ niệm
  final String? imagePath; // đường dẫn ảnh trong máy

  Anniversary({
    this.id,
    required this.title,
    required this.date,
    this.imagePath,
  });

  // Tạo bản sao (copyWith) để cập nhật id
  Anniversary copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? imagePath,
  }) {
    return Anniversary(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
    );
  }

}

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  // Danh sách các ngày kỷ niệm
  final List<Anniversary> _anniversaries = [];

  @override
  void initState() {
    super.initState();
    _loadAnniversariesFromDB();
  }

  /// Hàm lấy dữ liệu từ DB và setState
  Future<void> _loadAnniversariesFromDB() async {
    final data = await _getAllAnniversaries();
    setState(() {
      _anniversaries.clear();
      _anniversaries.addAll(data);
      // Sắp xếp từ cũ đến mới
      _anniversaries.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  /// Hàm lấy tất cả Anniversary từ DB
  Future<List<Anniversary>> _getAllAnniversaries() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('anniversaries', orderBy: 'date ASC');

    return result.map((row) {
      return Anniversary(
        id: row['id'] as int?,
        title: row['title'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
        imagePath: row['imagePath'] as String?,
      );
    }).toList();
  }

  /// Hàm thêm Anniversary vào DB, trả về ID mới
  Future<int> _insertAnniversary(Anniversary ann) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('anniversaries', {
      'title': ann.title,
      'date': ann.date.millisecondsSinceEpoch,
      'imagePath': ann.imagePath ?? '',
    });
  }

  /// Hàm cập nhật Anniversary trong DB
Future<int> _updateAnniversary(Anniversary ann) async {
  final db = await DatabaseHelper.instance.database;
  return await db.update(
    'anniversaries',
    {
      'title': ann.title,
      'date': ann.date.millisecondsSinceEpoch,
      'imagePath': ann.imagePath ?? '',
    },
    where: 'id = ?',
    whereArgs: [ann.id],
  );
}

/// Hàm xoá Anniversary khỏi DB
Future<int> _deleteAnniversary(Anniversary ann) async {
  final db = await DatabaseHelper.instance.database;
  return await db.delete(
    'anniversaries',
    where: 'id = ?',
    whereArgs: [ann.id],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Center(child: Text('Anniversary Day 🥰')),
      ),
      body: Column(
        children: [
          // Khu vực hiển thị danh sách
          Expanded(
            flex: 9,
            child: _anniversaries.isEmpty
                ? const Center(
                    child: Text(
                      'No anniversaries yet!',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _anniversaries.length,
                    itemBuilder: (context, index) {
                      final item = _anniversaries[index];

                      // Tính chênh lệch ngày giữa "ngày kỷ niệm" và "ngày hiện tại"
                      final differenceInDays =
                          DateTime.now().difference(item.date).inDays;
                      // Nếu < 7 ngày, hiển thị số ngày; nếu >= 7, hiển thị số tuần
                      String timeLabel;
                      if (differenceInDays < 7) {
                        timeLabel = '${differenceInDays}d'; // ví dụ: "3d"
                      } else if (differenceInDays >= 7 &&
                          differenceInDays < 30) {
                        timeLabel = '${differenceInDays ~/ 7}w'; // ví dụ: "2w"
                      } else if (differenceInDays >= 30 &&
                          differenceInDays < 365) {
                        timeLabel = '${differenceInDays ~/ 30}m';
                      } else {
                        timeLabel = '${differenceInDays ~/ 365}y';
                      }

                      // Định dạng ngày theo ý muốn (ví dụ: "18 thg 2, 2025")
                      final dateString =
                          DateFormat("  d/M/yyyy  ").format(item.date);

                      return Card(
                        // Màu nền cho card
                        color: Colors.lightBlue.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        elevation: 4,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              // Phần hiển thị ảnh + tiêu đề + ngày
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ảnh (nếu có)
                                  if (item.imagePath != null && item.imagePath!.isNotEmpty) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(item.imagePath!),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ] else ...[
                                    // Nếu không có ảnh, hiển thị icon
                                    const Icon(
                                      Icons.image,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  // Phần text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Tiêu đề
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 19.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Ngày
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month,
                                              color: Colors.white,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white
                                                    .withValues(alpha: 0.8),
                                              ),
                                              child: Text(
                                                ' $dateString',
                                                style: TextStyle(
                                                  color: Colors.lightBlue
                                                      .withValues(alpha: 0.7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Ô nhỏ hiển thị "2w" hoặc "3d" ở góc
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    timeLabel,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // Popup menu ở góc phải
                              Positioned(
                                top: 0,
                                right: 0,
                                child: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      // Chuyển sang màn hình chỉnh sửa, truyền dữ liệu hiện tại
                                      final updatedAnniversary = await Navigator.push<Anniversary>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddAnniversaryScreen(
                                            anniversary: item, // cần chỉnh sửa AddAnniversaryScreen để hỗ trợ edit
                                          ),
                                        ),
                                      );
                                      if (updatedAnniversary != null) {
                                        // Cập nhật trong DB
                                        await _updateAnniversary(updatedAnniversary);
                                        // Cập nhật lại list trong UI
                                        setState(() {
                                          final index = _anniversaries.indexWhere((ann) => ann.id == item.id);
                                          if (index != -1) {
                                            _anniversaries[index] = updatedAnniversary;
                                            _anniversaries.sort((a, b) => b.date.compareTo(a.date));
                                          }
                                        });
                                      }
                                    } else if (value == 'delete') {
                                      // Hiển thị hộp thoại xác nhận xoá
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Delete Confirmation'),
                                          content: const Text('Are you sure you want to delete this item?'),
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
                                        // Xoá khỏi DB
                                        await _deleteAnniversary(item);
                                        // Xoá khỏi list UI
                                        setState(() {
                                          _anniversaries.removeWhere((ann) => ann.id == item.id);
                                        });
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Nút bấm ở cuối màn hình
          Expanded(
            flex: 2,
            child: IconButton(
              // Thay thế đoạn code trong onPressed (ở DiaryScreen) như sau:
              onPressed: () async {
                // Mở màn hình thêm ngày kỷ niệm
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAnniversaryScreen(),
                  ),
                );

                if (result != null && result is Anniversary) {
                  // BƯỚC QUAN TRỌNG: Lưu vào DB
                  final newId = await _insertAnniversary(result);

                  // Cập nhật list trên UI kèm ID từ DB
                  setState(() {
                    final newItem = result.copyWith(id: newId);
                    _anniversaries.add(newItem);
                    // Sắp xếp từ cũ đến mới
                    _anniversaries.sort((a, b) => b.date.compareTo(a.date));
                  });
                }
              },

              color: Colors.white,
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withValues(alpha: .9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
