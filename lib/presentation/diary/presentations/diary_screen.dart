import 'package:flutter/material.dart';
import 'dart:io';

import '../../../shared/utils/helpers/database_helper.dart';
import 'add_anniversary_screen.dart';
import 'anniversary_detail_screen.dart';

class Anniversary {
  final int? id; // id trong DB (có thể null khi chưa lưu)
  final String title; // tiêu đề
  final DateTime date; // ngày kỷ niệm
  final String? imagePath; // đường dẫn ảnh trong máy
  final String? content; // nội dung nhật ký

  Anniversary({
    this.id,
    required this.title,
    required this.date,
    this.imagePath,
    this.content,
  });

  Anniversary copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? imagePath,
    String? content,
  }) {
    return Anniversary(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      content: content ?? this.content,
    );
  }
}

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final List<Anniversary> _anniversaries = [];

  @override
  void initState() {
    super.initState();
    _loadAnniversariesFromDB();
  }

  Future<void> _loadAnniversariesFromDB() async {
    final data = await _getAllAnniversaries();
    setState(() {
      _anniversaries.clear();
      _anniversaries.addAll(data);
      // Sắp xếp từ cũ đến mới
      _anniversaries.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  Future<List<Anniversary>> _getAllAnniversaries() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('anniversaries', orderBy: 'date ASC');

    return result.map((row) {
      return Anniversary(
        id: row['id'] as int?,
        title: row['title'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
        imagePath: row['imagePath'] as String?,
        content: row['content'] as String?,
      );
    }).toList();
  }

  Future<int> _insertAnniversary(Anniversary ann) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('anniversaries', {
      'title': ann.title,
      'date': ann.date.millisecondsSinceEpoch,
      'imagePath': ann.imagePath ?? '',
      'content': ann.content ?? '',
    });
  }

  Future<int> _updateAnniversary(Anniversary ann) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'anniversaries',
      {
        'title': ann.title,
        'date': ann.date.millisecondsSinceEpoch,
        'imagePath': ann.imagePath ?? '',
        'content': ann.content ?? '',
      },
      where: 'id = ?',
      whereArgs: [ann.id],
    );
  }

  Future<int> _deleteAnniversary(Anniversary ann) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'anniversaries',
      where: 'id = ?',
      whereArgs: [ann.id],
    );
  }

  // Hàm tính toán chuỗi thời gian (0d, 6d, 2w, ...)
  String _calculateTimeLabel(Anniversary item) {
    final differenceInDays = DateTime.now().difference(item.date).inDays;
    if (differenceInDays < 7) {
      return '${differenceInDays}d';
    } else if (differenceInDays < 30) {
      return '${differenceInDays ~/ 7}w';
    } else if (differenceInDays < 365) {
      return '${differenceInDays ~/ 30}m';
    } else {
      return '${differenceInDays ~/ 365}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anniversary Day 🥰'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _anniversaries.isEmpty
                    ? const Center(
                      child: Text(
                        'No anniversaries yet!',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _anniversaries.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 cột
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1, // tỷ lệ 1:1 (vuông)
                          ),
                      itemBuilder: (context, index) {
                        final item = _anniversaries[index];
                        final timeLabel = _calculateTimeLabel(item);

                        return GestureDetector(
                          onTap: () async {
                            // Mở màn hình chi tiết
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AnniversaryDetailScreen(
                                      anniversary: item,
                                    ),
                              ),
                            );

                            // Xử lý khi quay về từ màn hình chi tiết
                            if (result is Anniversary) {
                              // Người dùng đã sửa => cập nhật DB + list
                              await _updateAnniversary(result);
                              setState(() {
                                final idx = _anniversaries.indexWhere(
                                  (ann) => ann.id == item.id,
                                );
                                if (idx != -1) {
                                  _anniversaries[idx] = result;
                                  _anniversaries.sort(
                                    (a, b) => b.date.compareTo(a.date),
                                  );
                                }
                              });
                            } else if (result == 'deleted') {
                              // Người dùng đã xóa => xóa DB + list
                              await _deleteAnniversary(item);
                              setState(() {
                                _anniversaries.removeWhere(
                                  (ann) => ann.id == item.id,
                                );
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              // Ảnh (hoặc icon nếu chưa có ảnh), bo tròn
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Bo tròn ảnh
                                  child:
                                      item.imagePath != null &&
                                              item.imagePath!.isNotEmpty
                                          ? Image.file(
                                            File(item.imagePath!),
                                            fit: BoxFit.cover,
                                          )
                                          : Container(
                                            color: Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                ),
                              ),
                              // Nhãn thời gian
                              Positioned(
                                top: 4,
                                left: 4,
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
                            ],
                          ),
                        );
                      },
                    ),
          ),

          // Nút bấm ở cuối màn hình (IconButton)
          // Dịch lên một chút bằng cách thêm margin/bottom
          SizedBox(
            height: 100, // Tăng chiều cao, để nút nằm cao hơn
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                ), // Đẩy nút lên trên 1 chút
                child: IconButton(
                  onPressed: () async {
                    // Mở màn hình thêm ngày kỷ niệm
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAnniversaryScreen(),
                      ),
                    );

                    if (result != null && result is Anniversary) {
                      // Lưu vào DB
                      final newId = await _insertAnniversary(result);
                      // Cập nhật list
                      setState(() {
                        final newItem = result.copyWith(id: newId);
                        _anniversaries.add(newItem);
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
            ),
          ),
        ],
      ),
    );
  }
}
